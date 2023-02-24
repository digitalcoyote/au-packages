﻿$ErrorActionPreference = 'Stop';

$url64 = 'https://github.com/denoland/deno/releases/download/v1.31.0/deno-x86_64-pc-windows-msvc.zip'
$checksum64 = 'e2513c8d1655809995bdaa660c585d0ed81e2d474eb0511cef39ed7d4bbd80938465ab9629b5f1e05e5b1e423bc449d1ed43c5c6214b4417a918beeaa349cd7c'
$checksumType64 = 'sha512'
$UnzipLocation = Join-Path $env:ChocolateyInstall (Join-Path 'lib' $env:ChocolateyPackageName)


Install-ChocolateyZipPackage -PackageName $env:ChocolateyPackageName -Url64 $url64 -UnzipLocation $UnzipLocation -CheckSum64 $checksum64 -CheckSumType64 $checksumType64

#Create .ignore files so chocolatey does not shim the Exe
$files = get-childitem $UnzipLocation -include *.exe -recurse
foreach ($file in $files) {
  New-Item "$file.ignore" -type file -force | Out-Null
}
Install-ChocolateyPath -PathToInstall $UnzipLocation

# Remove shims installed with the old package
Uninstall-BinFile deno "$UnzipLocation\deno.exe"

Write-Output "Run 'deno --help' to get started"
