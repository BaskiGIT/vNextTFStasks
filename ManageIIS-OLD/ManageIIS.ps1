######################################################################

# Author        : Baskar Lingam Ramachandran (baskidevops@gmail.com)
# Created Date  : 25th Nov 2016
# Modified Date : 27th Nov 2016

######################################################################

param(
    [string]$AppPoolName
)

if(-not(Get-Module WebAdministration))
{
    Import-Module WebAdministration
}

Write-Host "`t`t-------------------------------------------------`r`n"
Write-Host "`t`tStopping application pool $AppPoolName`r`n"
Write-Host "`t`t-------------------------------------------------`r`n"

function Manage-AppPool
{
    [cmdletbinding()]
    Param($AppPoolName)
    if(-not($AppPoolName))
    {
        Write-Host "`t`tApp pool recycle is not done`r`n" -ForegroundColor Green
    }
    else
    {
        if(Test-Path IIS:\AppPools\$AppPoolName)
        {
            Write-Host "`t`tApp Pool $AppPoolName exists`r`n" -ForegroundColor DarkYellow
            if(-not((Get-WebAppPoolState $AppPoolName).Value -eq "stopped"))
            {
                Write-Host "`t`tApp Pool $AppPoolName is not stopped. Stopping it now.`r`n" -ForegroundColor DarkYellow
                Stop-WebAppPool $AppPoolName
            }
            else
            {
                Write-Host "`t`tApp Pool $AppPoolName is already stopped.`r`n" -ForegroundColor DarkGreen
            }
        }
        else
        {
            Write-Host "`t`tApp Pool $AppPoolName does not exist`r`n" -ForegroundColor DarkRed
        }
    }
}

Manage-AppPool $AppPoolName