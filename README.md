**Sync Youtube to Itunes Playlist for IPHONE OFFLINE SONGS**
  
**Mandatory: Install itunes from microsoft store.**
  
Steps to follow:
  
1. Run setup.bat file. if prompted, provide admin privilage. "Wait fot setup to complete!"  
2. In config.ini file, Add your playlist link to be in sync with your itunes  
3. If you want to sync only once then Run auto_sync.bat "It will fetch Songs from youtube playlists and convert it to itunes playlists - only once"  
4. For Creating Auto Sync Youtube to itunes Playlist Follow below.  
&emsp;1. Open Task Scheduler,  
&emsp;2. In Left side pane, click on Task Schedule Library,  
&emsp;3. Scroll and Check If 'YouTube Music To iTunes Auto Sync' task already exists or not,
 
&emsp;If **'YouTube Music To iTunes Auto Sync' task not exists**, Then follow below,  
&emsp;&emsp;1. Click Create Task and follow below, **"Note: Don't click create basic task"**  
&emsp;&emsp;2. In General Tab,  
     &emsp;&emsp;&emsp;&emsp;Give name as 'YouTube Music To iTunes Auto Sync'  
     &emsp;&emsp;&emsp;&emsp;Tick Run only when user is logged on.  
   &emsp;&emsp;&emsp;&emsp;Select your windows in Configure For eg. Windows 7 or Windows 10    
   &emsp;&emsp;3. In Trigger tab,  
     &emsp;&emsp;&emsp;&emsp;click create new,  
     &emsp;&emsp;&emsp;&emsp;Select "on workstation unlock"  
     &emsp;&emsp;&emsp;&emsp;Tick specific user  
     &emsp;&emsp;&emsp;&emsp;Tick delay task and select seconds and then edit it to 45 seconds  
     &emsp;&emsp;&emsp;&emsp;Tick enabled  
   &emsp;&emsp;4. In Action Tab,  
     &emsp;&emsp;&emsp;&emsp;create new,  
     &emsp;&emsp;&emsp;&emsp;select "Start a program"  
     &emsp;&emsp;&emsp;&emsp;click browse, navigate to YtToItunesMusic and select auto_sync.bat  
   &emsp;&emsp;5. In condition Tab,  
     &emsp;&emsp;&emsp;&emsp;UnTick all  
     &emsp;&emsp;&emsp;&emsp;Tick "Start Task only when computer is on AC Power" and  
     &emsp;&emsp;&emsp;&emsp;Tick "start only if network connection is available"  and  
     &emsp;&emsp;&emsp;&emsp;Tick "Any available network"  
 
&emsp;If **'YouTube Music To iTunes Auto Sync' task already exists**, Then follow below,  
&emsp;&emsp;1. Right Click 'YouTube Music To iTunes Auto Sync' Task and click properties  
&emsp;&emsp;2. In Trigger tab, Click Edit,  
&emsp;&emsp;&emsp;&emsp; Change "At Log On" to "On Workstation unlock"  
&emsp;&emsp;&emsp;&emsp; Select "on workstation unlock"  
&emsp;&emsp;&emsp;&emsp; Tick specific user  
&emsp;&emsp;&emsp;&emsp; Tick delay task and select seconds and then edit it to 45 seconds  
&emsp;&emsp;&emsp;&emsp; Tick enabled  
&emsp;&emsp;3. In condition Tab, Click Edit,  
     &emsp;&emsp;&emsp;&emsp;UnTick all  
     &emsp;&emsp;&emsp;&emsp;Tick "Start Task only when computer is on AC Power" and  
     &emsp;&emsp;&emsp;&emsp;Tick "start only if network connection is available"  and  
     &emsp;&emsp;&emsp;&emsp;Tick "Any available network"  

By following above instructions, your youtube playlist will be in sync with your itunes playlist.   
EveryTime your open your laptop the YT -> iTunes playlist starts syncing.   
Connect your iphone to laptop, And Sync music so that your iphone will also be in sync with itunes -> YT playlist.  
  
**Note: while Syncing or running scripts if itunes opens by itself dont close it.**  
