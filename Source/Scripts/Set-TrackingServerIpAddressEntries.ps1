function Set-TrackingServerIpAddressEntries {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Add","Remove")]
        [string] $Action,
        [string[]] $IpAddresses)

    if (!$IpAddresses) {
        $IpAddresses = Get-Content (Join-Path $PSScriptRoot "ip-addresses")
    }

    switch ($Action) {
        "Add" {
            Write-Verbose "Blocking tracking server ip addresses in firewall"
            foreach ($IpAddress in $IpAddresses) {
                New-NetFirewallRule -DisplayName "Block $IpAddress" -Group "Windows 10 Tracking" -Action block -Direction out -Profile Any -Protocol Any -RemoteAddress $IpAddress
            }
        }
        "Remove" {
            Write-Verbose "Removing tracking server ip address rules from firewall"
            foreach ($IpAddress in $IpAddresses) {
                Remove-NetFirewallRule -DisplayName "Block $IpAddress"
            }
        }
    }
}