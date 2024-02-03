# dumpsterDiver

```
   _                         _               ___  _                  ==^==
 _| | _ _  _ _ _  ___  ___ _| |_  ___  _ _  | . \[_] _ _  ___  _ _   |[[[|
/ . || | || ' ' || . \[_-|  | |  / ._]| '_] | | || || | |/ ._]| '_]  |[[[|        
\___| \__||_|_|_||  _//__/  |_|  \___.|_|   |___/|_||__/ \___.|_|    '---'
                 |_|                                                    
 							     Happy Diving!
```
														 
dumpsterDiver is a basic tooling/ps-script written by GPT and a coding newb (me) for newer verisons on Powershell
to perform crawling in a microsoft AD enviroment to find interesting files, configs and whatnot.
It searches for regexp strings specified within the script so be happy to change the preset to
fit your needs!. The tooling is intended to be used by cybersecurity professionals.

It's a simpler version https://github.com/SnaffCon/Snaffler which can be used on a non domain-joined PC

**Installation Powershell**
```
Invoke-WebRequest https://raw.githubusercontent.com/0xStr0k1rch/dumpsterDiver/main/dumpsterDiver.ps1 -OutFile dumpsterDiver.ps1
```

**Usage**

The tool was written to be used in conjunction with PingCastle and the -shares switch. PingCastle then outputs a file with all the shares. 
you can ofcourse use your own list however it should look like this.

```
\\dc.contoso.local\share1
\\dc.contoso.local\share2
\\files.contoso.local\share1$
\\files.contoso.local\share2$
\\secrets.contoso.local\share1$
```

Then change the $domainAdmins variable from '(example1|example2)' to your specific needs. Specify what domainadmins you want to look for.
You can fetch the the actual targets by running this command.
```
(Get-ADGroupMember -Identity "Domain Admins" -Recursive | Get-ADUser | Select-Object -ExpandProperty SamAccountName) -join '|'
```
Then run the script with, the script will prompt you for credentials to be used
```
.\dumpsterDiver.ps1 "C:\Path\To\Your\ShareList.txt"
```
The script will output logfiles with all it's findings in the same location that your sharelist file is.

![image](https://github.com/0xStr0k1rch/dumpsterDiver/assets/130508141/90477626-9143-4558-8b60-699cc3b0e441)

Happy Diving!
@str0k1rch


