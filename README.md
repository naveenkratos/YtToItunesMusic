**Sync Youtube to Itunes Playlist for IPHONE OFFLINE SONGS**

Steps to follow:

1. Run setup.bat file. if prompted, provide admin privilage. "Wait fot setup to complete!"
2. In config.ini file, Add your playlist link to be in sync with your itunes
3. If you want to sync only once then Run auto_sync.bat "It will scrap Songs from youtube playlist and convert it to itunes playlist - one time" 
4. For Auto Sync Youtube to itunes Playlist Folllow below.
   open Task Scheduler,
   In General Tab,
     click Create Task, "Note: don't create basic task"
     Give name as 'YouTube Music To iTunes Auto Sync'
     check Run only when user is logged on.
   In Trigger tab,
     click create new,
     Select "on workstation unlock"
     check specific user
     check delay task and select seconds and then edit it to 45 seconds
     check enabled
   In Action Tab,
     create new,
     select "Start a program"
     click browse, navigate to YtToItunesMusic and select auto_sync.bat
   In condition Tab,
     Uncheck all
     Then check "Start Task only when computer is on AC Power" and
     "start only if network connection is available"
     select "Any available network"

By following above instructions, your youtube playlist will be in sync with your itunes playlist. 
EveryTime your open your laptop the YT -> iTunes playlist starts syncing. 
Connect your iphone to laptop, so that your iphone will also be in sync with YT playlist.

**Note: while Syncing or running scripts if itunes opens by itself dont close it.**
