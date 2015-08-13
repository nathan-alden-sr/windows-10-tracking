function Set-Telemetry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Enable","Disable")]
        [string] $Action)

    $Paths = @("HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection","HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\DataCollection")

    switch ($Action) {
        "Enable" {
            Write-Verbose "Enabling telemetry"

            foreach ($Path in $Paths) {
                if (Test-Path $Path\AllowTelemetry -PathType Leaf) {
                    Remove-ItemProperty $Path AllowTelemetry -Force
                }
            }
        }
        "Disable" {
            Write-Verbose "Disabling telemetry"

            foreach ($Path in $Paths) {
                Set-ItemProperty $Path AllowTelemetry "0" -Type String -Force
            }
        }
    }
}