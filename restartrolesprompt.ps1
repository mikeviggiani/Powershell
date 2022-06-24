$Rgname = Read-Host -Prompt 'Input your resource group name'
$CSname = Read-Host -Prompt 'Input your cloud service name'
$roleInstances = Get-AzCloudServiceRoleInstance -ResourceGroupName $Rgname -CloudServiceName $CSname
$i = 0
for ($i = 0; $i -lt $roleInstances.Length; $i++)
{
  Restart-AzCloudService -ResourceGroupName $Rgname -CloudServiceName $CSname -RoleInstance $roleInstances[$i].Name
  Write-Output "Restarted" $roleInstances[$i].Name "waiting 2 minutes"
  Start-Sleep -Seconds 120
}
