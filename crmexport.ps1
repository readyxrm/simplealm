# Unmanaged version, you can uncomment and comment out managed import
#Import-CrmSolution -SolutionFilePath "$($solutionPath)\$($solutionShortName)_Unmanaged.zip" -conn $CRMConn -PublishChanges 

param (    
    [Parameter(Mandatory=$True)][ValidateNotNull()][string]$solutionShortName,      
    [string]$username = "joe@test.com",    
    [string]$password = "password123",    
    [string]$exportLocation = "C:\DEV\projectname",    
    [string]$instance = "https://org1234.crm3.dynamics.com/",
    [string]$region = "CAN",    
    [string]$type = "Office365",
    [string]$organisation = "org1234" 
    ) 


Import-Module Microsoft.Xrm.Data.Powershell

# Connect to Dynamics 365/CDS

$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

$CRMConn = Get-CrmConnection -Credential $credentials -DeploymentRegion $region –OnlineType $type –OrganizationName $organisation

# Export both managed and unmanaged

Write-Host "Exporting Solution, please wait."

Export-CrmSolution $solutionShortName $exportLocation -SolutionZipFileName $solutionShortName"_Unmanaged.zip" -conn $CRMConn

Export-CrmSolution $solutionShortName $exportLocation -SolutionZipFileName $solutionShortName"_Managed.zip" -Managed -conn $CRMConn

# Unpack solutions

Write-Host "Expanding Solution, please wait."

Expand-CrmSolution -ZipFile $solutionShortName"_Unmanaged.zip" -PackageType Unmanaged -Folder $solutionShortName

# add, commit and push to source control in the cloud

Write-Host "Staging Changes to Source Control"

git add -A

Write-Host "Committing Changes to Source Control"

$today = Get-Date -Format g

git commit -m "D365 Solution $($today)"

Write-Host "Syncing changes to Source Control"

git push
