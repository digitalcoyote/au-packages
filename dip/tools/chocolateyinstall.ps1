﻿$ErrorActionPreference = 'Stop';

$InstallArgs = @{
    PackageName = $env:ChocolateyPackageName
    FileFullPath = Join-Path (Join-Path $env:ChocolateyInstall (Join-Path 'lib' $env:ChocolateyPackageName)) 'dip.exe'
    URL = ''
    Checksum = ''
    ChecksumType = 'sha512'
}

Get-ChocolateyWebFile @InstallArgs
