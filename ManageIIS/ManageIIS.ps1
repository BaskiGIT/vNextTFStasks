#####################################################################

# Author        : Baskar Lingam Ramachandran (B.Ramachandran@iaea.org)
# Created Date  : 25th Nov 2016
# Updated Date  : 30th Nov 2016

######################################################################

[CmdletBinding()]
Param()

Trace-VstsEnteringInvocation $MyInvocation

try
{
    # Get the inputs.
    [string]$PoolName = Get-VstsInput -Name PoolName
    [string]$AppPoolAction = Get-VstsInput -Name AppPoolAction
    [bool]$ResetIIS = Get-VstsInput -Name ResetIIS -AsBool
    [bool]$RecycleAppPool = Get-VstsInput -Name RecycleAppPool -AsBool

    # Load the required module to manage IIS
    if(-not(Get-Module WebAdministration))
    {
        Import-Module WebAdministration
    }

    # Code for App pool stop or start
    if (($AppPoolAction -eq "Stop") -or ($AppPoolAction -eq "Start"))
    {
        if(-not($PoolName))
            {
                Write-Host "`t`tApp pool name is not provided. Please provide the same.`r`n" -ForegroundColor Green
            }
        else
            {
                if($AppPoolAction -eq "Stop")
                {
                    if(Test-Path IIS:\AppPools\$PoolName)
                    {
                        Write-Host "`t`tApp Pool $PoolName exists`r`n"
                        if(-not((Get-WebAppPoolState $PoolName).Value -eq "stopped"))
                        {
                    
                            Write-Host "`t`t-------------------------------------------------`r`n"
                            Write-Host "`t`tStopping application pool $PoolName`r`n"
                            Write-Host "`t`t-------------------------------------------------`r`n"

                            Write-Host "`t`tApp Pool $PoolName is not stopped. Stopping it now.`r`n" -ForegroundColor DarkYellow
                            Stop-WebAppPool $PoolName
                            Write-Host "`t`tThe command execution is complete.`r`n" -ForegroundColor Cyan
                            $appPoolState = Get-WebAppPoolState $PoolName
                            Write-Host "`t`tThe current state of the app pool $PoolName is $($appPoolState.Value).`r`n" -ForegroundColor DarkMagenta
                        }
                        else
                        {
                            Write-Host "`t`tApp Pool $PoolName is already stopped.`r`n" -ForegroundColor DarkGreen
                        }
                    }
                    else
                    {
                        Write-Host "`t`tApp Pool $PoolName does not exist`r`n" -ForegroundColor DarkRed
                    }            
                }
                if($AppPoolAction -eq "Start")
                {
                    if(Test-Path IIS:\AppPools\$PoolName)
                    {
                        Write-Host "`t`tApp Pool $PoolName exists`r`n"
                        if(-not((Get-WebAppPoolState $PoolName).Value -eq "Started"))
                        {

                            Write-Host "`t`t-------------------------------------------------`r`n"
                            Write-Host "`t`tStarting application pool $PoolName`r`n"
                            Write-Host "`t`t-------------------------------------------------`r`n"

                            Write-Host "`t`tApp Pool $PoolName is not started. Starting it now.`r`n" -ForegroundColor DarkYellow
                            Start-WebAppPool $PoolName
                            Write-Host "`t`tThe command execution is complete.`r`n" -ForegroundColor Cyan
                            $appPoolState = Get-WebAppPoolState $PoolName
                            Write-Host "`t`tThe current state of the app pool $PoolName is $($appPoolState.Value).`r`n" -ForegroundColor DarkMagenta
                        }
                        else
                        {
                            Write-Host "`t`tApp Pool $PoolName is already started.`r`n" -ForegroundColor DarkGreen
                        }
                    }
                    else
                    {
                        Write-Host "`t`tApp Pool $PoolName does not exist`r`n" -ForegroundColor DarkRed
                    }            
                }
            }
        }

    if ($ResetIIS -eq "true")
    {
        iisreset -stop -noforce
        if ($LASTEXITCODE -eq 0)
        {
            Write-Host "`t`tInternet services successfully stopped`r`n" -ForegroundColor DarkGreen
        }
        iisreset -start -noforce
        if ($LASTEXITCODE -eq 0)
        {
            Write-Host "`t`tInternet services successfully started`r`n" -ForegroundColor DarkRed
        }
    }

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}