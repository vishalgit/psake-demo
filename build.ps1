﻿cls
# '[psake] is the same as psake but $Error is not polluted'
Remove-Module [p]sake
# find psake's path
$psakeModule = (Get-ChildItem(".\packages\psake*\tools\psake.psm1")).FullName | Sort-Object $_ | select -Last 1

Import-Module $psakeModule

Invoke-psake -buildFile .\Build\default.ps1 `
			 -taskList Test `
			 -framework 4.5.2 `
			 -properties @{"buildConfiguration"="Release";"buildPlatform"="Any CPU"} `
			 -parameters @{"solutionFile"="..\psake.sln"}
Write-Host "Build exit code:" $LastExitCode

# Propogating the exit code so that builds actually fail when there is a problem.

exit $LastExitCode