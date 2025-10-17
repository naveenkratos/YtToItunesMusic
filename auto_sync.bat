@echo off
:: ==========================================
:: Automatic YouTube Playlist → iTunes Music
:: Fully Silent, Tracks Downloads, No Overwriting
:: ==========================================

:: Change working directory to the tools folder
cd /d "C:\Softwares\YTmusicConv\YTMusic"

:: --- Your YouTube playlist link ---
set PLAYLIST=https://youtube.com/playlist?list=PLBVMSiLoYCzbuLpRtyDmEEBbOYV-29hZa

:: --- Destination iTunes Music folder ---
set ITUNESMUSIC=C:\Users\%USERNAME%\Music\iTunes\iTunes Media\Automatically Add to iTunes

:: --- Log file (rotates daily) ---
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set LOGDATE=%%i
set LOGFILE=C:\Softwares\YTmusicConv\YTMusic\logs\sync_log_%LOGDATE%.txt


:: --- Create logs folder if missing ---
if not exist "C:\Softwares\YTmusicConv\YTMusic\logs" mkdir "C:\Softwares\YTmusicConv\YTMusic\logs"


echo ===================================================== >> "%LOGFILE%"
echo [%date% %time%] Starting YouTube → iTunes Sync >> "%LOGFILE%"
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
-o "%ITUNESMUSIC%\%%(title)s.%%(ext)s" ^
--newline ^
--progress ^
%PLAYLIST%  >> "%LOGFILE%" 2>&1

echo -----------------------------------------------------
echo   Sync complete! New songs are now in iTunes Music.
echo -----------------------------------------------------

echo ===================================================== >> "%LOGFILE%"
echo [%date% %time%] YouTube → iTunes Sync Complete  >> "%LOGFILE%"
echo ===================================================== >> "%LOGFILE%"

exit
