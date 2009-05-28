----------------
Pomodoro Desktop
----------------

Pomodoro desktop is a simple utility to manage a kitchen-like timer for your coding activities on the Mac. Pomodoro desktop can be used to track other activities too.
You can find more informations on the Pomodoro Technique on http://www.pomodorotechnique.com/
Updates, source code, new releases and fixes on http://pomodoro.ugolandini.com
 
-------
Manual
-------

Basic Usage:

Just start the pomodoro! Pomodoro will notify you various states of the pomodoro, using both growl and spoken alerts.
You'll need to install Growl Framework separately if you want growl notifications. Just go on http://growl.info/, it's a simple install and a lot of other mac software is Growl enabled. Highly recommended.

Customizing notifications:

Every growl/speech notification can be enabled/disabled and personalized to your needs.
In Interrupt notifications text, you can use $secs placeholder to indicate the interrupt duration. 
In "Every" notification text, you can use $mins, $passed and $time placeholders to indicate respectively interval time, total time passed and how much time is left.

Default values for preferences:

To reset default values, just type this commands:

cd
rm Library/Preferences/com.ugolandini.pomodoro.plist

or just

rm ~/Library/Preferences/com.ugolandini.pomodoro.plist
(the ~ character means your home dir: if it's not on your keyboard you can usually get it pressing alt-5)

-------
License
-------
This code is released under BSD license (see License.txt for details) and contains other OSS BSD licensed code:
Growl framework: http://growl.info/
BGHud Appkit: http://code.google.com/p/bghudappkit/

-------
Thanks
-------
Luca Ceppelli, Roberto Turchetti, Sergio Bossa 
Stefano Linguerri for the great graphics 
