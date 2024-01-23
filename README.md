# dumpsterDiver

   _                         _                ___  _                 ==^==
 _| | _ _  _ _ _  ___  ___ _| |_  ___  _ _   | . \[_] _ _  ___  _ _  |[[[|
/ . || | || ' ' || . \[_-|  | |  / ._]| '_] | | || || | |/ ._]| '_]  |[[[|
\___| \__||_|_|_||  _//__/  |_|  \___.|_|   |___/|_||__/ \___.|_|    '---'
                 |_|                                                    
																													Happy Diving!	
														 
dumpsterDiver is a basic tooling/psscript written by GPT and a coding newb to perform crawling in a microsoft AD enviroment to find interesting files, configs and whatnot.
It searches for regexp strings specified within the script. 

$domainAdmins = '(example1|example2)' here specify what domainadmins you want to look for.

Run this and add the respons it to $domainAdmins variable
(Get-ADGroupMember -Identity "Domain Admins" -Recursive | Get-ADUser | Select-Object -ExpandProperty SamAccountName) -join '|'

