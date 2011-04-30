--------
Pomodoro
--------

Pomodoro is an antiprocrastination application that helps in Getting Things Done. 
It is a simple but effective way to manage your time and to boost your productivity to higher levels. 
Can be used for programming, studying, writing, cooking or simply concentrating on something important.
 
You can find more informations on the Pomodoro Technique on http://www.pomodorotechnique.com/
Updates, source code, new releases, manual and fixes on http://pomodoro.ugolandini.com

----------
Developers
----------

Project lead: Ugo Landini
Active Developers: Ugo Landini, Pascal Bihler
Retired Developers: 
 
-------
License
-------
This code is released under BSD license (see License.txt for details) and contains other OSS BSD licensed code:
Growl framework: http://growl.info/
BGHud Appkit: http://code.google.com/p/bghudappkit/

This software contains Waffle Software licensed code:
Shortcut Recorder: http://wafflesoftware.net/shortcut/

Matt Gemmell licensed code:
MGTwitterEngine: http://svn.cocoasourcecode.com/MGTwitterEngine/

Sound samples come from http://www.freesound.org and are licensed under Creative Commons http://creativecommons.org/licenses/sampling+/1.0/

--------------
Building notes
--------------


1) Remove Code signing identity if present (should not, but sometimes I push it back)

XCode 4:
2) Just click build

XCode 3: (not actively maintained)
2) Should work, but I don't maintain it anymore.

-------
Twitter
-------
If you want to use twitter integration, you must have a consumerKey and a secretKey for oAuth/xAuth authentication. You must obtain the secrets from twitter site and then add them in src/TwitterSecrets.h 

#define _consumerkey @"your key" 
#define _secretkey @"your other key"

If you are not interested in Twitter, just don't activate the twitter integration.

------------------------------
Thanks, in no particular order
------------------------------
Everaldo for the gorgeous new icons
Pedro Murillo
Michael Bedward
Dieter Vermandere
Paul Schmidt
Sina Samangooei <sinjax@gmail.com> for debugging (and fixing!)
Alexander Klimetschek
Konrad Mitchell Lawson
Stefano Linguerri for the initial graphic design 
Giulio Cesare Solaroli for the old icons
Luca Ceppelli
Roberto Turchetti
Sergio Bossa 
Andrew Rimmer
Timothy Davis
Simone Gentilini
Francesco Mondora
Michele Mondora
Andy Palmer
Brandon Murray
Valiev Omar
Alexander Willner 
C.Kuehne 
R.Altimari
P.Bihler
