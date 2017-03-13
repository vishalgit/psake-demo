Framework 4.5.1

properties{
	$testMessage = 'Executed Test!'
	$compileMessage = 'Executed Compile!'
	$cleanMessage = 'Executed Clean!'
	$solutionDirectory = (Get-Item $solutionFile).DirectoryName
	$outputDirectory = "$solutionDirectory\.build"
	$tempOutputDirectory = "$outputDirectory\temp"
	$buildConfiguration = "Release"
	$buildPlatform = "Any CPU"
}

FormatTaskName "`r`n`r`n-------- Executing {0} Task --------"

task default -depends Test

task Init `
	-description "Initializes the build by removing previous artifacts and creating output directories" `
	-requiredVariables outputDirectory, tempOutputDirectory `
{
	Assert ("Debug","Release" -contains $buildConfiguration ) "Invalid build configuration '$buildConfiguration'. Valid values are 'Debug' and 'Release'"  
	Assert ("x86","x64","Any CPU" -contains $buildPlatform ) "Invalid build configuration '$buildPlatform'. Valid values are 'x86','x64' and 'Any CPU'" 
	# Remove previous build result
	if(Test-Path $outputDirectory){
		Write-Host "Removing output directory located at $outputDirectory"
		Remove-Item $outputDirectory -Force -Recurse
	}	
	Write-Host "Creating output directory located at $outputDirectory"
	New-Item $outputDirectory -ItemType Directory | Out-Null
		
	Write-Host "Creating temp directory located at $tempOutputDirectory"
	New-Item $tempOutputDirectory -ItemType Directory | Out-Null
}

task Clean -description "Removes temperory files" {
	Write-Host $cleanMessage
}

task Compile -depends Init -description "Compile the code" `
	-requiredVariables solutionFile, buildConfiguration, buildPlatform, tempOutputDirectory `
{
	Write-Host $compileMessage
	Exec {
		msbuild $solutionFile "/p:Configuration=$buildConfiguration;Platform=$buildPlatform;OutDir=$tempOutputDirectory"
	}
}

task Test -depends Compile, Clean -description "Run unit tests"{
	Write-Host $testMessage
}