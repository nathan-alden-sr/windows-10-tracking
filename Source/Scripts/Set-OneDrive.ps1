function Set-OneDrive {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Enable","Disable")]
        [string] $Action)

    $Path = "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive"

    if (Test-Path $Path\DisableFileSyncNGSC -PathType Leaf) {
        switch ($Action) {
            "Enable" {
                Write-Verbose "Enabling OneDrive"

                Set-ItemProperty $Path DisableFileSyncNGSC 0 -Type DWord -Force
            }
            "Disable" {
                Write-Verbose "Disabling OneDrive"

                Set-ItemProperty $Path DisableFileSyncNGSC 1 -Type DWord -Force
            }
        }
    }
}