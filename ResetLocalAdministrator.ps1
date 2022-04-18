###############################################################################################################
#
# ABOUT THIS PROGRAM
#
#   ResetLocalAdministrator.ps1
#   https://github.com/Headbolt/ResetLocalAdministrator
#
#   This script was designed to Check the Status the Local Administrator Account,
#	Enable it if needed and set the password 
#	and then exit with an appropriate Exit code.
#
###############################################################################################################
#
# HISTORY
#
#   Version: 1.0 - 18/04/2022
#
#   - 18/04/2022 - V1.0 - Created by Headbolt 
#
Write-Host ""
Write-Host '###############################################################################################################'
Write-Host ""
$Computer = $env:COMPUTERNAME # Grab the local ComputerName
# Grab the name of the Local Administrator Account incase it is different. eg Different Languages
$UserName = ((Get-CimInstance -ClassName Win32_UserAccount -Filter "LocalAccount = TRUE and SID like 'S-1-5-%-500'").Name)
$PassWord = 'P@ssword12345' # Set Password to be used for the Administrator Account
$PassWordSet = ConvertTo-SecureString $PassWord -AsPlainText -Force # Convert the Password to a secure string
#
If ((Get-LocalUser -Name $UserName).Enabled) # Check if Local Administrator account is Enabled
{
	Write-Host "Local User Account $UserName is confirmed as Enabled"
	Write-Host ""
	Write-Host '###############################################################################################################'
	Write-Host ""
}
Else
{
	Write-Host "Local User Account $UserName is confirmed as NOT Enabled"
	Write-Host ""
	Write-Host "Enabling It"
	Enable-LocalUser $UserName # If Local Administrator is Disabled, enable it
	Write-Host ""
	Write-Host '###############################################################################################################'
	Write-Host ""
}
#
Set-LocalUser $UserName -Password $PassWordSet # Set Password
Write-Host "Password for user $UserName has been set"
Write-Host ""
Write-Host '###############################################################################################################'
Write-Host ""
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$Object = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('machine',$Computer)
$Object.ValidateCredentials($UserName, $PassWord) 
If ( $Object.ValidateCredentials($UserName, $PassWord) ) # Verify Password now matches
{
	Write-Host "Password Change Verified"
	Write-Host ""
	Write-Host '###############################################################################################################'
	Write-Host ""
	Write-Host "Exiting"
	Write-Host ""
	Write-Host '###############################################################################################################'
	Exit 0
}
Else
{
	Write-Host "Password Change Verification Failed"
	Write-Host ""
	Write-Host '###############################################################################################################'
	Write-Host ""
	Write-Host "Exiting"
	Write-Host ""
	Write-Host '###############################################################################################################'
	Exit 1
}
