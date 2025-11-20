**Sync Youtube to Itunes Playlist for IPHONE OFFLINE SONGS**
  
**Mandatory: Install itunes from microsoft store.**
  
Steps to follow:
  
1. Run setup.bat file. if prompted, provide admin privilage. "Wait fot setup to complete!"
2. In config.ini file, Add your playlist link to be in sync with your itunes
3. If you want to sync only once then Run auto_sync.bat "It will fetch Songs from youtube playlists and convert it to itunes playlists - only once" 
4. For Auto Sync Youtube to itunes Playlist Folllow below.  
&emsp;1. Open Task Scheduler,  
&emsp;2. In General Tab,  
     &emsp;&emsp;click Create Task, **"Note: don't create basic task"**  
     &emsp;&emsp;Give name as 'YouTube Music To iTunes Auto Sync'  
     &emsp;&emsp;check Run only when user is logged on.  
   &emsp;&emsp;Select your windows in Configure For eg. Windows 7 or Windows 10    
   &emsp;3. In Trigger tab,  
     &emsp;&emsp;click create new,  
     &emsp;&emsp;Select "on workstation unlock"  
     &emsp;&emsp;check specific user  
     &emsp;&emsp;check delay task and select seconds and then edit it to 45 seconds  
     &emsp;&emsp;check enabled  
   &emsp;4. In Action Tab,  
     &emsp;&emsp;create new,  
     &emsp;&emsp;select "Start a program"  
     &emsp;&emsp;click browse, navigate to YtToItunesMusic and select auto_sync.bat  
   &emsp;5. In condition Tab,  
     &emsp;&emsp;Uncheck all  
     &emsp;&emsp;Then check "Start Task only when computer is on AC Power" and  
     &emsp;&emsp;"start only if network connection is available"  
     &emsp;&emsp;select "Any available network"  
  
By following above instructions, your youtube playlist will be in sync with your itunes playlist.   
EveryTime your open your laptop the YT -> iTunes playlist starts syncing.   
Connect your iphone to laptop, And Sync music so that your iphone will also be in sync with itunes -> YT playlist.  
  
**Note: while Syncing or running scripts if itunes opens by itself dont close it.**  
