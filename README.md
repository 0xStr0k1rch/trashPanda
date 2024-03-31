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

trashPanda is a basic tooling/ps-scripd written for newer verisons on Powershell.
it's purpose perform crawling in a microsoft AD and local-PC enviroment to find interesting files, configs and whatnot.
It searches for RegExp strings specified within the script so be happy to change the preset to
fit your needs!. The tooling is intended to be used by cybersecurity professionals, Blue teamers and Red teamers alike.

It's a simpler version https://github.com/SnaffCon/Snaffler which can be used even on a non domain-joined PC which Snaffler requires..
Perfect from an Windows attack host for example!

**Installation Powershell**
```
Invoke-WebRequest https://raw.githubusercontent.com/0xStr0k1rch/trashPanda/main/trashPanda.ps1 -OutFile trashPanda.ps1
```

**Usage**

This tool was written to be used in conjunction with PingCastle and the -shares switch. But any other AD share enumeration work fine aswell. 
The structure of the shares file is supposed to look like the example below.

```
\\dc.contoso.local\share1
\\dc.contoso.local\share2
\\files.contoso.local\share1$
\\files.contoso.local\share2$
\\secrets.contoso.local\share1$
C:\
D:\
```

Change the $domainAdmins variable from '(admin1|admin2)' to specify what domainadmins you want to look for.
You can fetch the the actual targets by running this command below (if ActiveDirecotry module is present ofc).
Put the output within the single-quotes with each user separated by a | pipe.
```
(Get-ADGroupMember -Identity "Domain Admins" -Recursive | Get-ADUser | Select-Object -ExpandProperty SamAccountName) -join '|'
```
To run run the script wit. The script will prompt you for credentials to be used
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
![bild](https://github.com/0xStr0k1rch/trashPanda/assets/130508141/61e73cac-9807-4d30-b517-dec9d7810f7b)

Happy Diving!
@str0k1rch

