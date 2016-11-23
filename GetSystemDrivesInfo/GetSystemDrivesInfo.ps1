##############

# Author        : Baskar Lingam Ramachandran (B.Ramachandran@iaea.org)
# Created Date  : 18th Nov 2016

##############

$server = $env:computername

$format = @{Expression={$_.DeviceID};Label="Drive"},`
@{Expression={$_.Size / 1GB};Label="Total Size"},`
@{Expression={$_.FreeSpace};Label="Free Space"}

$Drive = get-wmiobject win32_logicaldisk | Select-Object Size, FreeSpace, DeviceID # | Format-Table $format

foreach ($item in $Drive)
{
    Write-Host "`t-----$($item.DeviceID) has $([math]::Round($item.FreeSpace/1GB,2)) GB free space of the total space of $([math]::Round($item.Size / 1GB,2)) GB"
}