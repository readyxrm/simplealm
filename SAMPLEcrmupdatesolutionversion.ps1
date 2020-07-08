param (    
    [Parameter(Mandatory=$True)][ValidateNotNull()][string]$solutionShortName,      
    [string]$username = "",    
    [string]$password = "",    
    [string]$exportLocation = "C:\",    
    [string]$instance = "https://x.crmX.dynamics.com",
    [string]$region = "",    
    [string]$type = "Office365",
    [string]$organisation = "" 
    ) 

cls


Import-Module Microsoft.Xrm.Data.Powershell


$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

$CRMConn = Get-CrmConnection -Credential $credentials -DeploymentRegion $region –OnlineType $type –OrganizationName $organisation


$solutions = Get-CrmRecords -conn $CRMConn -EntityLogicalName solution -FilterAttribute uniquename -FilterOperator eq -FilterValue $solutionShortName -Fields uniquename,solutionid,version 

$solutionid = (($solutions | Where-Object {$_.keys -eq "crmRecords"}).values).solutionid
$version = (($solutions | Where-Object {$_.keys -eq "crmRecords"}).values).version

$version

$verdate = Get-Date -UFormat "%Y.%m.%d"

$newversion ="1.$($verdate)"

$newversion

Set-CrmRecord -conn $CRMConn -EntityLogicalName solution -Id $solutionid -Fields @{"version"=$newversion}

