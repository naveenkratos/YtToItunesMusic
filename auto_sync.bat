@echo off
:: ==========================================
:: Automatic YouTube Playlist → iTunes Music
:: Fully Silent, Tracks Downloads, No Overwriting
:: ==========================================

:: --- Base tools directory ---
set BASEDIR=C:\Softwares\YTmusicConv\YTMusic
cd /d "%BASEDIR%"

:: --- Your YouTube playlist link ---
set PLAYLIST=https://youtube.com/playlist?list=PLBVMSiLoYCzbuLpRtyDmEEBbOYV-29hZa

:: --- Destination iTunes Music folder ---
set ITUNESMUSIC=C:\Users\%USERNAME%\Music\iTunes\iTunes Media\Automatically Add to iTunes

:: --- Log file (rotates daily) ---
set LOGDIR=%BASEDIR%\logs
if not exist "%LOGDIR%" mkdir "%LOGDIR%"
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set LOGDATE=%%i
set LOGFILE=%LOGDIR%\sync_log_%LOGDATE%.txt


:: --- Create logs folder if missing ---
if not exist "C:\Softwares\YTmusicConv\YTMusic\logs" mkdir "C:\Softwares\YTmusicConv\YTMusic\logs"


echo ======================================================== >> "%LOGFILE%"
echo [%date% %time%] Starting YouTube to iTunes music scripts >> "%LOGFILE%"
echo ======================================================== >> "%LOGFILE%"


:: --- Close iTunes if open ---
echo Checking if iTunes is running...
tasklist /FI "IMAGENAME eq iTunes.exe" 2>NUL | find /I "iTunes.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo iTunes is currently running. Closing it now...
    taskkill /IM iTunes.exe /F >NUL 2>&1
    timeout /t 3 >NUL
    echo iTunes closed.
) else (
    echo iTunes not running.
)



echo ===================================================== >> "%LOGFILE%"
echo [%date% %time%] Starting YouTube to iTunes Sync >> "%LOGFILE%"
echo ===================================================== >> "%LOGFILE%"

echo =====================================================
echo    Starting YouTube Playlist to iTunes Music Sync
echo =====================================================
echo Playlist: %PLAYLIST%
echo Target Folder: %ITUNESMUSIC%
echo -----------------------------------------------------

:: --- Download & convert to MP3 directly into iTunes folder ---
yt-dlp -f "bestaudio[ext=m4a]/bestaudio" -x --audio-format alac --audio-quality 0 ^
--embed-thumbnail --add-metadata ^
--download-archive downloaded.txt ^
--newline ^
--progress ^
-o "%ITUNESMUSIC%\%%(title)s.%%(ext)s" ^
%PLAYLIST%  >> "%LOGFILE%" 2>&1

:: --- Trigger iTunes refresh + reorder playlist ---
powershell -ExecutionPolicy Bypass -File "%BASEDIR%\itunes_playlist.ps1" "%PLAYLIST%" >> "%LOGFILE%" 2>&1


echo -----------------------------------------------------
echo   Sync complete! New songs are now in iTunes Music.
echo -----------------------------------------------------

echo ===================================================== >> "%LOGFILE%"
echo [%date% %time%] YouTube to iTunes Sync Complete  >> "%LOGFILE%"
echo ===================================================== >> "%LOGFILE%"

exit
