### dumpsterDiver

dumpsterDiver is a basic tooling/ps-script written by GPT and a coding newb (me) for newer verisons on Powershell.
it's purpose perform crawling in a microsoft AD enviroment to find interesting files, configs and whatnot.
It searches for RegExp strings specified within the script so be happy to change the preset to
fit your needs!. The tooling is intended to be used by cybersecurity professionals, Blue-Teamers and Red-Teamers alike.

It's a simpler version https://github.com/SnaffCon/Snaffler which can be used on a non domain-joined PC which Snaffler requires..

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
C:\
D:\
```

Then change the $domainAdmins variable from '(admin1|admin2)' to specify what domainadmins you want to look for.
You can fetch the the actual targets by running this command below. Put the output withing the parenthesis separated by a | pipe
```
(Get-ADGroupMember -Identity "Domain Admins" -Recursive | Get-ADUser | Select-Object -ExpandProperty SamAccountName) -join '|'
```
Then run the script with, the script will prompt you for credentials to be used
```
.\dumpsterDiver.ps1 "C:\Path\To\Your\ShareList.txt"
```
The script will output logfiles with all it's findings in the same location that your sharelist file is.

How does it look?
![image](https://github.com/0xStr0k1rch/dumpsterDiver/assets/130508141/912ac159-82ba-482a-8509-379f180ac859)
```
GREEN = Interesting files
YELLOW = File match with $searchString Match
BLUE = Content of the file marked above
RED = flags for a match with $domainAdmins
```

![image](https://github.com/0xStr0k1rch/dumpsterDiver/assets/130508141/90477626-9143-4558-8b60-699cc3b0e441)

Happy Diving!
@str0k1rch

