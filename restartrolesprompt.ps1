Write-Output "Welcome, This script is used to restart roles of Cloud Service 1 at a time with 150 Seconds in between"
$subscriptions = Get-AzSubscription `
   | ForEach-Object { $counter = 0 } { $counter++; $_ | Add-Member -Name Number -Value $counter -MemberType NoteProperty -Passthru } `
   | Format-Table number,name
$subscriptionsog = Get-AzSubscription
$subscriptions
$subscription = Read-Host -Prompt 'Input your Subscription number'
$subscriptionsog[$subscription - 1].Name
Set-AzContext -Subscription $subscriptionsog[$subscription - 1].Name
$resourceog = Get-AzResource -ResourceType Microsoft.Compute/cloudServices
$resources = Get-AzResource -ResourceType Microsoft.Compute/cloudServices `
   | ForEach-Object { $counter = 0 } { $counter++; $_ | Add-Member -Name Number -Value $counter -MemberType NoteProperty -Passthru } `
   | Format-Table number,name
$resources
$resource = Read-Host -Prompt 'Input number for your cloud service'
$roleInstances = Get-AzCloudServiceRoleInstance -ResourceGroupName $resourceog[$resource - 1].ResourceGroupName -CloudServiceName $resourceog[$resource - 1].Name -SubscriptionId $subscriptionsog[$subscription - 1].Id
$i = 0
for ($i = 0; $i -lt $roleInstances.Length; $i++)
{
  Write-Output "Restarting" $roleInstances[$i].Name
  Restart-AzCloudService -ResourceGroupName $resourceog[$resource - 1].ResourceGroupName -CloudServiceName $resourceog[$resource - 1].Name -RoleInstance $roleInstances[$i].Name -SubscriptionId $subscriptionsog[$subscription - 1].Id
  Write-Output "Completed!, waiting 2.5 minutes"
  Start-Sleep -Seconds 150
}
Write-Output "Restarts completed"
