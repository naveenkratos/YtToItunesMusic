# ================================================
# Auto Setup Script: yt-dlp + FFmpeg (with caching)
# ================================================

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$libDir = Join-Path $scriptDir "lib"

# --- Create lib folder if missing ---
if (-not (Test-Path $libDir)) {
    New-Item -ItemType Directory -Path $libDir | Out-Null
    Write-Host "Created library folder: $libDir"
}

# --- URLs for latest versions ---
$ytDLP_URL = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
$ffmpegZipURL = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"

# --- File paths ---
$ytDLP_Path = Join-Path $scriptDir "yt-dlp.exe"
$ytDLP_Lib = Join-Path $libDir "yt-dlp.exe"

$ffmpeg_Path = Join-Path $scriptDir "ffmpeg.exe"
$ffplay_Path = Join-Path $scriptDir "ffplay.exe"
$ffprobe_Path = Join-Path $scriptDir "ffprobe.exe"
$ffmpegZip_Lib = Join-Path $libDir "ffmpeg-release-essentials.zip"

# --- Helper: Download file to lib ---
function Download-ToLib($url, $outputPath) {
    $fileName = [System.IO.Path]::GetFileName($outputPath)
    Write-Host "Downloading $fileName to lib..."
    Invoke-WebRequest -Uri $url -OutFile $outputPath -UseBasicParsing
    Write-Host "✅ Saved $fileName to $outputPath"
}

# --- Helper: Extract FFmpeg executables ---
function Extract-FFmpeg($zipPath, $destination) {
    Write-Host "Extracting FFmpeg executables..."
    $tempDir = Join-Path $env:TEMP "ffmpeg_extract_$([guid]::NewGuid())"
    Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force
    $exeFiles = Get-ChildItem -Path $tempDir -Recurse -Include "ffmpeg.exe","ffplay.exe","ffprobe.exe"
    foreach ($exe in $exeFiles) {
        Copy-Item $exe.FullName -Destination $destination -Force
    }
    Remove-Item $tempDir -Recurse -Force
    Write-Host "✅ Extracted ffmpeg.exe, ffplay.exe, ffprobe.exe"
}

# --- yt-dlp setup ---
if (-not (Test-Path $ytDLP_Path)) {
    if (Test-Path $ytDLP_Lib) {
        Write-Host "Found yt-dlp.exe in lib. Copying..."
        Copy-Item $ytDLP_Lib $ytDLP_Path -Force
    } else {
        Write-Host "yt-dlp.exe not found locally. Downloading..."
        Download-ToLib $ytDLP_URL $ytDLP_Lib
        Copy-Item $ytDLP_Lib $ytDLP_Path -Force
    }
    Write-Host "✅ yt-dlp.exe ready."
} else {
    Write-Host "yt-dlp.exe already exists."
}

# --- FFmpeg setup ---
$needFF = -not ((Test-Path $ffmpeg_Path) -and (Test-Path $ffplay_Path) -and (Test-Path $ffprobe_Path))
if ($needFF) {
    if (-not (Test-Path $ffmpegZip_Lib)) {
        Write-Host "FFmpeg archive not found in lib. Downloading..."
        Download-ToLib $ffmpegZipURL $ffmpegZip_Lib
    } else {
        Write-Host "Found FFmpeg archive in lib."
    }

    Extract-FFmpeg $ffmpegZip_Lib $scriptDir
    Write-Host "✅ FFmpeg executables ready."
} else {
    Write-Host "FFmpeg executables already exist."
}

<#
Creates a user-specific Task Scheduler task only if it doesn't already exist.
Creates a Task Scheduler entry with:
- Name: YouTube Music To iTunes Auto Sync
- Trigger: At Log on + 45s delay
- Action: auto_sync.bat in same folder
- User-specific (no admin needed)
- Runs only when user is logged on
- AC power + network required
#>

# -----------------------------
# PATHS
# -----------------------------
$basePath = $scriptDir
$batFile = Join-Path $basePath "auto_sync.bat"
$taskName = "YouTube Music To iTunes Auto Syncer"

if (-not (Test-Path $batFile)) {
    Write-Host "ERROR: auto_sync.bat not found in: $basePath"
    exit 1
}

try {
    $existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction Stop
    Write-Host "Task '$taskName' already exists. Skipping creation."
    exit
}catch {
    # Task does not exist → continue and create it
	Write-Host "Task '$taskName' doesnt exists going to create it"
}

# -----------------------------
# GENERAL TAB
# -----------------------------

$currentUser = "$env:USERDOMAIN\$env:USERNAME"

$principal = New-ScheduledTaskPrincipal `
    -UserId $currentUser `
    -LogonType Interactive `  # ← Run only when user is logged on

# Configure for detected Windows version
$os = (Get-CimInstance Win32_OperatingSystem).Caption
$settings = New-ScheduledTaskSettingsSet -Compatibility Win7 -ExecutionTimeLimit (New-TimeSpan -Hours 4) # Win7+ compatibility

# -----------------------------
# TRIGGER TAB
# -----------------------------
# Workstation unlock trigger
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $currentUser

# Delay for 45 seconds
$trigger.Delay = "PT45S"    # ISO 8601 format

$trigger.Enabled = $true


# -----------------------------
# ACTION TAB
# -----------------------------
$action = New-ScheduledTaskAction `
    -Execute $batFile

# -----------------------------
# CONDITION TAB
# -----------------------------
# Uncheck all conditions first, then apply specific ones
$settings.StopIfGoingOnBatteries = $false
$settings.DisallowStartIfOnBatteries = $true            # Start only on AC power
$settings.RunOnlyIfNetworkAvailable = $true             # Require network

# -----------------------------
# BUILD TASK
# -----------------------------
$task = New-ScheduledTask `
    -Action $action `
    -Principal $principal `
    -Trigger $trigger `
    -Settings $settings

# -----------------------------
# REGISTER TASK
# -----------------------------
Register-ScheduledTask `
    -TaskName $taskName `
    -InputObject $task `
    -Force
	



Write-Host "`nTask '$taskName' created successfully for $currentUser!"


Write-Host "`nSetup complete. All required tools are installed and ready." -ForegroundColor Green

exit
