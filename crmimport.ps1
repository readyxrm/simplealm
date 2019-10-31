# Parameters so you don't need to re-enter each time, note case is important here.  Replace orgname, region, password, login, URL, etc
param (    
    [Parameter(Mandatory=$True)][ValidateNotNull()][string]$solutionShortName,      
    [string]$username = "joe@test.com",    
    [string]$password = "password123",    
    [string]$solutionPath = "C:\dev\projectname",  
    [string]$instance = "https://org1234.crm3.dynamics.com",
    [string]$region = "CAN",    
    [string]$type = "Office365",
    [string]$organisation = "org1234" 
    ) 


Import-Module Microsoft.Xrm.Data.Powershell

#get credentials and make connect to instance
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

$CRMConn = Get-CrmConnection –ServerUrl $instance -Credential $credentials -OrganizationName $organisation -MaxCrmConnectionTimeOutMinutes 5

Set-CrmConnectionTimeout -TimeoutInSeconds 3600 -conn $CRMConn

#import managed solution
Write-Host "Importing Solution, please wait."

Write-Host "$($solutionPath)\$($solutionShortName)_Managed.zip"

Import-CrmSolution -SolutionFilePath "$($solutionPath)\$($solutionShortName)_Managed.zip" -conn $CRMConn 

# Unmanaged version, you can uncomment and comment out managed import
#Import-CrmSolution -SolutionFilePath "$($solutionPath)\$($solutionShortName)_Unmanaged.zip" -conn $CRMConn -PublishChanges 