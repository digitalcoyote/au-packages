﻿$ErrorActionPreference = 'Stop';
$pp = Get-PackageParameters

$InstallArgs = @{ 
  PackageName = $env:ChocolateyPackageName
  FileType = 'exe'
  SilentArgs = '/VERYSILENT'
  Url64bit = 'https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v3.137.0/install.exe'
  Checksum64 = 'c26df419965ac60877a1185779cd3000f2a283d0a03216e56464bd6aab3766779c404c0e409f6593e19025211d1b6d1376d1700cb034bfe9049be76d029a7678'
  ChecksumType64 = 'sha512'
}

Install-ChocolateyPackage  @InstallArgs

if ($PROFILE -and (Test-Path $PROFILE)) {
  $oldProfile = @(Get-Content $PROFILE)

  $newProfile = @()
  foreach ($line in $oldProfile) {
    if ($line -like 'Import-Module oh-my-posh' -or $line -like 'Invoke-Expression (oh-my-posh --init --shell pwsh*') {
      if ($pp['Theme']) {
        # If a theme is set, Overwrite old line to set new theme
        if (Test-Path "$env:LocalAppDataPrograms/oh-my-posh/themes/$($p['Theme'])).omp.json") {
          $ohMyPoshProfileLine = "Invoke-Expression (oh-my-posh --init --shell pwsh --config ""$env:LocalAppDataPrograms/oh-my-posh/themes/$($p['Theme'])).omp.json"")"
          Write-Host "Overwriting Old Oh-My-Posh line: $line with $ohMyPoshProfileLine"
          $newProfile += $ohMyPoshProfileLine;
        }
        else {
          Throw "Could not find Theme $pp['Theme'] @ $env:LocalAppDataPrograms/oh-my-posh/themes/$($p['Theme'])).omp.json";
        }
      }
      else {        
        $OhMyPoshInProfile = $true
      }
    }      
    else {
      $newProfile += $line
    }
      
  }
  if (-not $OhMyPoshInProfile) {
    if ($pp['Theme']) {
      if (Test-Path "$env:LocalAppDataPrograms/oh-my-posh/themes/$($p['Theme'])).omp.json") {
        $newProfile += "Invoke-Expression (oh-my-posh --init --shell pwsh --config ""$env:LocalAppDataPrograms/oh-my-posh/themes/$($p['Theme'])).omp.json"")";
      }
      else {
        Throw "Could not find Theme $pp['Theme'] @ $env:LocalAppDataPrograms/oh-my-posh/themes/$($p['Theme'])).omp.json";
      }
    }
    else {
      $newProfile += 'Invoke-Expression (oh-my-posh --init --shell pwsh)`n';

    }
  }

  Set-Content -path $profile -value $newProfile -Force
  Write-Host "oh-my-posh has been added to your profile. You may wish to append 'Set-PoshPrompt paradox' to set a theme"
}
else {
  Write-Host 'No Powershell Profile was found. You may wish to create a Profile and append ''Invoke-Expression (oh-my-posh --init --shell pwsh --config "$env:LocalAppDataPrograms/oh-my-posh/themes/themename.omp.json")'' to enable oh-my-posh. ''Get-PoshThemes'' will list available themes for you'
}
