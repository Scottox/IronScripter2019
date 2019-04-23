<#
The Chairman has arranged for another prequel challenge to prepare you for the upcoming Iron Scripter battle. A suggested solution will eventually be provided. In the mean time, see what you can do with this problem.

Using a set of Windows features, like Windows Internal Database, on a baseline server, configure a target server to match. Remove features that aren’t installed on the baseline and install features that are missing on the target. You can configure the source server with any combination of Windows features you’d like. Your goal is to copy the feature set to a target server.

This does not need to be a one-liner or even a function, although you are welcome to do so. What commands would you run in a PowerShell remoting session to accomplish this task? While it is true you could use a technology like Desired State Configuration, see if you can accomplish this task through traditional PowerShell scripting techniques.
#>
param (
$baseComputer = '',
$computername = ''
)
$sourceFeature = ''
$sourceFeature = Get-WindowsFeature -ComputerName $baseComputer
$sourceInstalled = $sourceFeature.where({$PSItem.InstallState -eq 'Installed'})
$targetFeature = Get-WindowsFeature -ComputerName $computername 
$targetInstalled = $targetFeature.where({$PSItem.InstallState -eq 'Installed'})

$compare = Compare-Object -ReferenceObject $sourceInstalled.Name -DifferenceObject $targetInstalled.Name

$install =  $compare.where({$PSItem.SideIndicator -eq '<='})
$remove = $compare.where({$PSItem.SideIndicator -eq '=>'})

Install-WindowsFeature -ComputerName $computername -Name $install.InputObject
Remove-WindowsFeature -ComputerName $computername -Name $remove.InputObject

