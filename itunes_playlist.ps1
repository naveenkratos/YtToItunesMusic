param(
    [string]$playlistURL
)

function Escape-LikeWildcards($str) {
    return ($str -replace '([*?\[\]])','`$1').ToLower().Trim()
}

# === Auto-detect yt-dlp path ===
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ytDLP = Join-Path $scriptDir "yt-dlp.exe"

if (-not (Test-Path $ytDLP)) {
    Write-Host "yt-dlp.exe not found in $scriptDir"
    Write-Host "Please ensure yt-dlp.exe is in the same folder as this script."
    exit 1
}

# === Create iTunes COM object ===
try {
    $itunes = New-Object -ComObject iTunes.Application
} catch {
    Write-Host "Unable to connect to iTunes. Make sure iTunes is installed and running."
    exit 1
}

# === Get playlist info from YouTube ===
Write-Host "Fetching YouTube playlist info..."
try {
	$ytJson = & $ytDLP --flat-playlist -J $playlistURL 2>$null
	$ytInfo = $ytJson | Out-String | ConvertFrom-Json
} catch {
    Write-Host "Failed to fetch YouTube playlist info."
    exit 1
}

$playlistName = ($ytInfo.title -replace '[\\/:*?"<>|]', '_')  # sanitize name
$ytTracksUrls = $ytInfo.entries | ForEach-Object { $_.url }


Write-Host "YTPlaylist: $playlistName ($($ytTracksUrls.Count) tracks)"

# Path to your text file containing YouTube song titles
$txtFile = Join-Path $scriptDir "downloaded.txt"

if (Test-Path $txtFile) {
	# Count number of lines in the file
    $expectedCount = (Get-Content $txtFile | Measure-Object -Line).Lines
}
else{
	$expectedCount = $ytTracksUrls.Count
}


Write-Host "Waiting for $expectedCount tracks to appear in iTunes..."

# Wait loop for iTunes to finish importing
$timeout = 150  # maximum wait in seconds (2.5 min)
$elapsed = 0

do {
    $libraryTracks = $itunes.LibraryPlaylist.Tracks
    if ($libraryTracks.Count -ge $expectedCount-2) { break }
    Start-Sleep -Seconds 5
    $elapsed += 5
} while ($elapsed -lt $timeout)

Write-Host "iTunes library now has $($libraryTracks.Count) tracks"

# === Check for existing playlist in iTunes ===
$existingPlaylist = $itunes.Sources.ItemByName("Library").Playlists | Where-Object { $_.Name -eq $playlistName }

if ($existingPlaylist) {
	Write-Host "Deleting Existing iTunes playlist: $playlistName"
    $existingPlaylist.Delete()
	Start-Sleep -Seconds 2
}

$playlist = $itunes.CreatePlaylist($playlistName)


# --- Cache playlist tracks for faster lookup ---
$existingTracks = @{}

# === Build fast lookup hash for iTunes library ===
Write-Host "Indexing iTunes library for faster matching..."
$libraryTracks = $itunes.LibraryPlaylist.Tracks
$libraryCommentHash = @{}
foreach ($track in @($libraryTracks)) {
    $cleanComment = ($track.Comment -replace '\s*\(.*\)$','').ToLower().Trim()
    if (-not $libraryCommentHash.ContainsKey($cleanComment)) {
        $libraryCommentHash[$cleanComment] = @()
    }
    $libraryCommentHash[$cleanComment] += $track
}
Write-Host "Library index built ($($libraryCommentHash.Count) unique titles)."

# === Add tracks in the same order as YouTube ===

$added = 0
$skipped = 0

foreach ($ytTrackUrl in $ytTracksUrls) {
    $searchUrl = ($ytTrackUrl -replace '\s*\(.*\)$','').ToLower().Trim()
    $foundTracks = $null

    # Exact match
    if ($libraryCommentHash.ContainsKey($searchUrl)) {
		Write-Host "Exact Match Track - $searchUrl "
        $foundTracks = $libraryCommentHash[$searchUrl]
    }


    if (-not $foundTracks) {
        Write-Host "Not found in iTunes: $title"
        continue
    }

    foreach ($track in $foundTracks) {
        $key = "$($track.Comment)|$($track.Location)"
        if (-not $existingTracks.ContainsKey($key)) {
            try {
                $null = $playlist.AddTrack($track)
                $existingTracks[$key] = $true
                $added++
                Write-Host "Added: $($track.Name)"
            } catch {
                Write-Warning "Failed to add '$($track.Name)': $($_.Exception.Message)"
            }
        } else {
            Write-Host "Skipped existing: $($track.Name)"
			$skipped++
        }
    }
}

Write-Host "-----------------------------------------------------"
Write-Host "Playlist Name: $playlistName"
Write-Host "Total Tracks in Library: $($libraryTracks.Count)"
Write-Host "New tracks added: $added"


# Find YTplaylist songs missing in itunesplaylist

$playlistTracks = $playlist.Tracks
$ytPlaylistTrackUrls = $ytTracksUrls | ForEach-Object { $_.Trim() }
$playlistComments = $playlistTracks | ForEach-Object { $_.Comment.Trim() }
$missingInPlaylist = $ytPlaylistTrackUrls | Where-Object { $_ -notin $playlistComments }
Write-Host "Missing Tracks: $($missingInPlaylist.Count)" 
Write-Host "-----------------------------------------------------"
if ($missingInPlaylist) {
	Write-Host "`n=== Adding $($missingInPlaylist.Count) Missing Tracks in Playlist '$playlistName' ===" 
	#Add missing songs to the playlist
	foreach ($missingTrackUrl in $missingInPlaylist) {
		try {
			$trackToAdd = $libraryTracks | Where-Object { $_.Comment.Trim().ToLower() -eq $missingTrackUrl.ToLower() }
			if ($trackToAdd) {
				$null = $playlist.AddTrack($trackToAdd)
				$added++
				Write-Host "Added: $missingTrackUrl" 
				$added++
			} else {
				Write-Host "Not found in library: $missingTrackUrl" 
			}
		}
		catch {
			Write-Warning "Failed to add '$($missingTrackUrl)': $($_.Exception.Message)"
		}
	}
}

Write-Host "-----------------------------------------------------"
Write-Host "iTunes playlist synced successfully: $playlistName"
Write-Host "Total tracks in playlist $playlistName : $($playlist.Tracks.Count)"
Write-Host "-----------------------------------------------------"

# === Close iTunes after short delay ===
Write-Host ""
Write-Host "Waiting 5 seconds before closing iTunes..."
Start-Sleep -Seconds 5
try {
    $itunes.Quit()
    Write-Host "iTunes closed successfully."
} catch {
    Write-Warning "Failed to close iTunes automatically. You may close it manually."
}
Start-Sleep -Seconds 5
