@echo off
:: ==========================================
:: Automatic YouTube Playlist → iTunes Music
:: Fully Silent, Tracks Downloads, No Overwriting
:: ==========================================

:: --- Base tools directory ---
set BASEDIR=%~dp0
:: Remove trailing backslash if present
if "%BASEDIR:~-1%"=="\" set "BASEDIR=%BASEDIR:~0,-1%"
cd /d "%BASEDIR%"

:: Path to config file
set CONFIG_FILE=%BASEDIR%\config.ini


set RUNLOGFILE=%BASEDIR%\last_run_date.txt

:: Get today's date in yyyy-mm-dd format
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set TODAYDATE=%%i


:: Read last run date (if file exists)
set "lastRun="
if exist "%RUNLOGFILE%" for /f "usebackq delims=" %%A in ("%RUNLOGFILE%") do set "lastRun=%%A"

:: Clean up spaces
set "lastRun=%lastRun: =%"

:: Skip if already ran today
if "%lastRun%"=="%TODAYDATE%" exit /b

:: --- Destination iTunes Music folder ---
set ITUNESMUSIC=C:\Users\%USERNAME%\Music\iTunes\iTunes Media\Automatically Add to iTunes

:: --- Log file (rotates daily) ---
set LOGDIR=%BASEDIR%\logs
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

:: Delete logs older than 7 days
forfiles /p "%LOGDIR%" /m *.txt /d -7 /c "cmd /c del @path"

:: Generate daily log filename
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set LOGDATE=%%i
set LOGFILE=%LOGDIR%\sync_log_%LOGDATE%.txt


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
echo [%date% %time%] Updating YTDLP to latest version >> "%LOGFILE%"
echo ===================================================== >> "%LOGFILE%"

yt-dlp -U >> "%LOGFILE%" 2>&1


:: Loop youtube playlist url in config files
for /f "usebackq tokens=1,* delims==" %%A in (`findstr /v "^#" "%CONFIG_FILE%"`) do (
    
	echo =====================================================  >> "%LOGFILE%"
	echo    Downloading YouTube Playlist Songs  >> "%LOGFILE%"
	echo =====================================================  >> "%LOGFILE%"
	echo Playlist %%A: %%B  >> "%LOGFILE%"
	echo Target Folder: %ITUNESMUSIC%  >> "%LOGFILE%"
	echo -----------------------------------------------------  >> "%LOGFILE%"

	:: --- Download & convert to MP3 directly into iTunes folder ---
	yt-dlp -f "bestaudio[ext=m4a]/bestaudio" -x --audio-format alac --audio-quality 0 ^
	--embed-thumbnail --add-metadata ^
	--download-archive downloaded.txt ^
	--newline ^
	--progress ^
	-o "%ITUNESMUSIC%\%%(title)s.%%(ext)s" ^
	%%B  >> "%LOGFILE%" 2>&1

)

echo ===================================================== >> "%LOGFILE%"
echo [%date% %time%] Starting YouTube to iTunes Sync >> "%LOGFILE%"
echo ===================================================== >> "%LOGFILE%"

:: --- Trigger iTunes refresh + reorder playlist ---
powershell -ExecutionPolicy Bypass -File "%BASEDIR%\itunes_playlist.ps1" >> "%LOGFILE%" 2>&1

echo ===================================================== >> "%LOGFILE%"
echo [%date% %time%] YouTube to iTunes Sync Complete!  >> "%LOGFILE%"
echo ===================================================== >> "%LOGFILE%"

:: === Update last run date ===
echo %TODAYDATE% > "%RUNLOGFILE%"

exit /b
