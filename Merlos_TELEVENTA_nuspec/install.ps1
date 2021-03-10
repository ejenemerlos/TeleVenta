param($installPath, $toolsPath, $package, $project)

#Write-Host "On install.ps1"
#Write-Host "InstallPath: $installPath";
#Write-Host "toolsPath: $toolsPath";
#Write-Host "package: $package";
#Write-Host "project: $project";

$res = $DTE.ItemOperations.Navigate("http://merlos.net")

