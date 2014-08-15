--------
Timer
--------

Timer is an antiprocrastination application that helps in Getting Things Done. 
It is a simple but effective way to manage your time and to boost your productivity to higher levels. 
Can be used for programming, studying, writing, cooking or simply concentrating on something important.
 
It's inspired by the Pomodoro Technique (http://www.pomodorotechnique.com/)

Updates, source code, new releases, manual and fixes on http://martakostova.github.io/timer

----------
Developers
----------

Maintaining Developer: Marta Kostova
Developed by Ugo Landini and Pascal Bihler
 
-------
License
-------
This code is released under BSD license (see License.txt for details) and contains other OSS BSD licensed code:

BGHud Appkit: http://code.google.com/p/bghudappkit/

This software contains Waffle Software licensed code:
Shortcut Recorder: http://wafflesoftware.net/shortcut/

Sound samples come from http://www.freesound.org and are licensed under Creative Commons http://creativecommons.org/licenses/sampling+/1.0/

--------------
Building notes
--------------

Open Timer.xcodeproj once with XCode, then run "make clean no-sig timer" from the command line.

OR

1) Remove Code signing identity if present (should not, but sometimes I push it back)

Xcode 4.3+ (tips from @sashalaundy):	
1) Product > Edit Scheme
2) At top set Scheme to "Pomodoro" and Destination to "My Mac __-bit"
3) On left select Archive
4) Type in Archive Name "Pomodoro"
5) Hit OK
6) Product > Archive - Xcode builds and then opens Organizer with archive selected
7) Hit Distribute
8) Choose Export as "Application"

Xcode 4:
1) Build a copy for archiving: Product menu -> Build for -> Build for Archiving
2) Open the organizer: Window menu -> Organizer
3) Create a copy of the application: Hit the Share button in the Organizer
4) Choose "Application" from the drop-down menu, and then save it to your Applications folder. 

Xcode 3: (not actively maintained)
1) Should work, but I don't maintain it anymore.


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
