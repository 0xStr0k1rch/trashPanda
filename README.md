```
                                                                      ^...^
 ______  ____    ____  _____ __ __  ____   ____  ____   ___     ____ <_* *_>
|      ||    \  /    |/ ___/|  |  ||    \ /    ||    \ |   \   /    | ¨\_/¨==^== 
|      ||  D  )|  o  (   \_ |  |  ||  o  )  o  ||  _  ||    \ |  o  |==^== |[[[|
|_|  |_||    / |     |\__  ||  _  ||   _/|     ||  |  ||  D  ||     ||[[[| |[[[|
  |  |  |    \ |  _  |/  \ ||  |  ||  |  |  _  ||  |  ||     ||  _  ||[[[| |[[[|
  |__|  |__|\_||__|__| \___||__|__||__|  |__|__||__|__||_____||__|__|'---' '---'
                                               Happy Dumpster Diving! @str0k1rch
```

trashPanda is a basic tooling/ps-script written by GPT and a coding newb (me) for newer verisons on Powershell.
it's purpose perform crawling in a microsoft AD and local-PC enviroment to find interesting files, configs and whatnot.
It searches for RegExp strings specified within the script so be happy to change the preset to
fit your needs!. The tooling is intended to be used by cybersecurity professionals, Blue-Teamers and Red-Teamers alike.

It's a simpler version https://github.com/SnaffCon/Snaffler which can be used even on a non domain-joined PC which Snaffler requires..

**Installation Powershell**
```
Invoke-WebRequest https://raw.githubusercontent.com/0xStr0k1rch/trashPanda/main/trashPanda.ps1 -OutFile trashPanda.ps1
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
.\trashPanda.ps1 "C:\Path\To\Your\ShareList.txt"
```
The script will output logfiles with all it's findings in the same location that your sharelist file is.

How does it look?
![bild](https://github.com/0xStr0k1rch/trashPanda/assets/130508141/2c812186-3ca9-4326-8db1-7f725f2b7259)
```
GREEN = Interesting files
YELLOW = File match with $searchString Match
BLUE = Content of the file marked above
RED = flags for a match with $domainAdmins
```

![bild](https://github.com/0xStr0k1rch/trashPanda/assets/130508141/38f10575-738c-4318-8b2d-39f7a2a7af7c)



Happy Diving!
@str0k1rch

