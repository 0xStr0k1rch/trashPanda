# dumpsterDiver
```
   _                         _                ___  _                 ==^==
 _| | _ _  _ _ _  ___  ___ _| |_  ___  _ _   | . \[_] _ _  ___  _ _  |[[[|
/ . || | || ' ' || . \[_-|  | |  / ._]| '_] | | || || | |/ ._]| '_]  |[[[|        
\___| \__||_|_|_||  _//__/  |_|  \___.|_|   |___/|_||__/ \___.|_|    '---'
                 |_|                                                    
							Happy Diving!
```
														 
dumpsterDiver is a basic tooling/psscript written by GPT and a coding newb (me) to
perform crawling in a microsoft AD enviroment to find interesting files, configs and whatnot.
It searches for regexp strings specified within the script. 



**Installation Powershell**
```
Invoke-WebRequest https://raw.githubusercontent.com/0xStr0k1rch/dumpsterDiver/main/dumpsterDiver.ps1 -OutFile dumpsterDiver.ps1
```

**Usage**
The tool was written to be used in conjunction with PingCastle and the -shares switch. PingCastle then outputs a file with all the shares
like this

\\dc.contoso.net\share
\\dc.contoso.net\share1
\\files.contoso.net\share1$
\\files.contoso.net\share2$
\\secrets.contoso.net\share1$

Then change the $domainAdmins variablefrom '(example1|example2)' to your specifik needs. specify what domainadmins you want to look for.
You can the the actual targets by running this command.
```
(Get-ADGroupMember -Identity "Domain Admins" -Recursive | Get-ADUser | Select-Object -ExpandProperty SamAccountName) -join '|'
```
Then run the script with 
```
.\dumpsterDiver.ps1 "C:\Path\To\Your\ShareList.txt"
```


