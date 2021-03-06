﻿$tools = Split-Path $MyInvocation.MyCommand.Definition
$response = Join-Path $tools 'uninstall.iss'

. $tools\uninstall.ps1

# The uninstall command in the registry contains all sorts of nonsense. We have
# to throw out everything after the EXE path to provide the response file flag,
# anwway.
#
#   "C:\Program Files (x86)\InstallShield Installation Information\{DBCDB997-EEEB-4BE9-BAFF-26B4094DBDE6}\setup.exe" -runfromtemp -l0x0009 UNINSTALL -removeonly
#
(Get-Uninstaller -Name 'ScanSnap Manager') -match '"(?<path>.*)"' | Out-Null
$uninstaller = $matches['path']

# This an InstallShield installer, requiring a response file (.ISS) for silent
# installation.
#
Uninstall-ChocolateyPackage `
    -PackageName 'scansnapmanager' `
    -FileType 'EXE' `
    -SilentArgs "UNINSTALL /S /f1`"$response`"" `
    -File $uninstaller
