function Set-Services {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Enable","Disable","Delete")]
        [string] $Action)

    function Remove-Service {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory=$true)]
            [string] $Name)

        $Service = Get-WmiObject -Class Win32_Service -Filter "Name='$Name'"
        if ($Service) {
            Write-Verbose "Removing $Name service"

            $Service.Delete()
        }
    }

    switch ($Action) {
        "Enable" {
            Write-Verbose "Setting startup type to Automatic for DiagTrack service"

            Set-Service DiagTrack -StartupType Automatic

            Write-Verbose "Starting DiagTrack service"

            Start-Service DiagTrack

            Write-Verbose "Setting startup type to Automatic (Delayed) for dmwappushservice service"

            & sc.exe config dmwappushservice start= delayed-auto

            Write-Verbose "Starting dmwappushservice service"

            Start-Service dmwappushservice
        }
        "Disable" {
            Write-Verbose "Setting startup type to Disabled for DiagTrack service"

            Set-Service DiagTrack -StartupType Disabled

            Write-Verbose "Stopping DiagTrack service"

            Stop-Service DiagTrack -Force

            Write-Verbose "Setting startup type to Disabled for dmwappushservice service"

            Set-Service dmwappushservice -StartupType Disabled

            Write-Verbose "Stopping dmwappushservice service"

            Stop-Service dmwappushservice -Force
        }
        "Delete" {
            Write-Verbose "Stopping DiagTrack service"

            Stop-Service DiagTrack -Force

            Remove-Service DiagTrack

            Write-Verbose "Stopping dmwappushservice service"

            Stop-Service dmwappushservice -Force
            
            Remove-Service dmwappushservice
        }
    }
}