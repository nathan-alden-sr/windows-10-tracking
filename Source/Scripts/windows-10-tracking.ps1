#Require Version 4

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("EnableTracking","DisableTracking","DisableTrackingAndDeleteServices")]
    [string] $Action)

Set-StrictMode -Version Latest

. .\Clear-DiagTrackLog.ps1
. .\Set-OneDrive.ps1
. .\Set-Services.ps1
. .\Set-Telemetry.ps1
. .\Set-TrackingServerHostsEntries.ps1

switch ($Action) {
    "EnableTracking" {
        Set-Telemetry Enable
        Set-Services Enable
        Set-TrackingServerHostsEntries Remove
        Set-OneDrive Enable
    }
    "DisableTracking" {
        Set-Telemetry Disable
        Set-Services Disable
        Clear-DiagTrackLog
        Set-TrackingServerHostsEntries Add
        Set-OneDrive Disable
    }
    "DisableTrackingAndDeleteServices" {
        Set-Telemetry Disable
        Set-Services Delete
        Clear-DiagTrackLog
        Set-TrackingServerHostsEntries Add
        Set-OneDrive Disable
    }
}