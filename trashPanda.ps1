
function Get-tpBanner {
Write-Host "
                                                                      ^...^
 ______  ____    ____  _____ __ __  ____   ____  ____   ___     ____ <_* *_>
|      ||    \  /    |/ ___/|  |  ||    \ /    ||    \ |   \   /    | ¨\_/¨==^== 
|      ||  D  )|  o  (   \_ |  |  ||  o  )  o  ||  _  ||    \ |  o  |==^== |[[[|
|_|  |_||    / |     |\__  ||  _  ||   _/|     ||  |  ||  D  ||     ||[[[| |[[[|
  |  |  |    \ |  _  |/  \ ||  |  ||  |  |  _  ||  |  ||     ||  _  ||[[[| |[[[|
  |__|  |__|\_||__|__| \___||__|__||__|  |__|__||__|__||_____||__|__|'---' '---'" -ForegroundColor Green
Write-Host "                                               Happy Dumpster Diving! @str0k1rch" -ForegroundColor Cyan
}

# Define the path to the file containing the list of network shares
$shareListFile = "C:\Path\To\Your\ShareList.txt"
param (
    [string]$shareListFile
)

# Check if $shareListFile is provided
if (-not $shareListFile) {
    Get-tpBanner
    Write-Host ""
    Write-Host "No sharelist found" -ForegroundColor Red
    Write-Host 'Example: .\dumpsterDiver.ps1 "C:\Path\To\Your\ShareList.txt"' -ForegroundColor Green
    Write-Host 'list example:' -ForegroundColor Yellow
    Write-Host '\\dc.contoso.net\share' -ForegroundColor Yellow
    Write-Host '\\files.contoso.net\share1$' -ForegroundColor Yellow
    Write-Host '\\files.contoso.net\share2$' -ForegroundColor Yellow
    Write-Host 'C:\' -ForegroundColor Yellow
    Write-Host 'D:\' -ForegroundColor Yellow
    Write-Host 'etc.. etc..'
    Exit
}

$loggFile = $shareListFile
# Define the regex pattern for search
$searchStringPattern = '(([sS]ql( |)(-sa|sa))|[aA]dmin|key=|[pP]assword|[pP]wd=|[cC]onnection[sS]tring(s|)=|[lL]ösenord|[sS]ecret|[uU]sername=|-----BEGIN( RSA|) PRIVATE KEY-----)'
$domainAdmins = '(admin1|admin2|admin3|admin4)'

# Define the regex pattern for exclusion (e.g., exclude DLLs and EXEs)
$excludeFilePattern = '\.(dll|exe|gdl|htm|xcf|qvd|xcp|msi|gitkeep|log|css|iso|adml)$|7177'
$includeFilePattern = '\.(vhd(x|)|config|cfg|git|kdb|kdbx|db|py|env|properties|pem|yaml|ts|key|pfx|ppk)'

# Get credentials for accessing the network shares
$credentials = Get-Credential

# Read the list of network shares from the file
$networkShares = Get-Content -Path $shareListFile

Get-tpBanner
Write-Host ""
Write-Host ""
Write-Host "Searching Admins: $domainAdmins" -ForegroundColor Red
Write-Host "regEx including: $searchStringPattern" -ForegroundColor Blue
Write-Host "Seperately logging: $includeFilePattern" -ForegroundColor Green
Write-Host "Logging to: $shareListFile.log and $shareListFile.files.log" -ForegroundColor Blue
Write-Host "To modify the strings, just edit the script" -ForegroundColor Green
Write-Host "__________________________________________________________________________"
Write-Host ""
Write-Host ""

# Function to extract context around a match
function Get-ContextAroundMatch {
    param (
        [string]$content,
        [string]$matchValue,
        [int]$contextLength = 40
    )

    $startIndex = $content.IndexOf($matchValue)

    if ($startIndex -eq -1) {
        return $content
    }

    $startIndex = [Math]::Max(0, $startIndex - $contextLength)
    $length = [Math]::Min($content.Length - $startIndex, $matchValue.Length + 2 * $contextLength)

    return $content.Substring($startIndex, $length)
}

# Loop through each network share
foreach ($share in $networkShares) {
    try {
        # Disconnect existing connections
        Get-PSDrive | Where-Object { $_.PSProvider -eq "FileSystem" -and $_.Root -like "$share*" } | Remove-PSDrive -Force

        # Create a temporary PSDrive with credentials
        $null = New-PSDrive -Name TempDrive -PSProvider FileSystem -Root $share -Credential $credentials -ErrorAction Stop

        # Test if the network share is accessible
        if (Test-Path "TempDrive:\") {
            # Recursively search for files containing the specified regex pattern, excluding $excludeFilePattern
            Get-ChildItem -Path "TempDrive:\" -Recurse |
                Where-Object {
                    if ($_.Extension -match $includeFilePattern) {
                        Write-Host "$($_.FullName) <# Look into this file!" -ForegroundColor Green
                        echo "$($_.FullName) <###" >> "$shareListFile.files.log"
                    }  
                    $_.PSIsContainer -eq $false -and
                    $_.Extension -notmatch  $excludeFilePattern -and
                    $_.Length -lt 200MB -and # Set a limit in bytes, adjust as needed
                    $_.Length -ne 0
                } |
                ForEach-Object {
                    $fileContent = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue

                    if ($fileContent -ne $null) {
                    #need more matches add more regexes down here?
                    $matches = [regex]::Matches($fileContent, $searchStringPattern)
                    $domainAdminMatches = [regex]::Matches($fileContent, $domainAdmins)

                    foreach ($match in $matches) {
                        $context = Get-ContextAroundMatch -content $fileContent -matchValue $match.Value
                        Write-Host "$($_.FullName)" -ForegroundColor Yellow
                        Write-Host "$context" -ForegroundColor Blue
                        echo "$($_.FullName)" >> "$shareListFile.log"
                        echo "--------File content-----------" >> "$shareListFile.log"
                        echo "$context" >> "$shareListFile.log"
                        echo "-------------------" >> "$shareListFile.log"
                        break
                    }
                    
                    foreach ($match in $domainAdminMatches) {
                        $context = Get-ContextAroundMatch -content $fileContent -matchValue $match.Value
                        Write-Host "$($_.FullName)" -ForegroundColor Yellow
                        Write-Host "Domain Admin reference found!" -ForegroundColor Red
                        Write-Host "$context" -ForegroundColor Blue
                        echo "$($_.FullName)" >> "$shareListFile.log"
                        echo "--------File content-----------" >> "$shareListFile.log"
                        echo "DA reference found!" >> "$shareListFile.log"
                        echo "$context" >> "$shareListFile.log"
                        echo "-------------------" >> "$shareListFile.log"
                        break
                    }
                    }
                }
        } else {
            Write-Host "Unable to access $($share)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error accessing $($share): $_" -ForegroundColor Red

    } finally {
        # Remove the temporary PSDrive
        Remove-PSDrive -Name TempDrive -ErrorAction SilentlyContinue
    }
}
