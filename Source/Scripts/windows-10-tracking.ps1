#Require Version 4

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("EnableTracking","DisableTracking","DisableTrackingAndDeleteServices")]
    [string] $Action)

Set-StrictMode -Version Latest

. $PSScriptRoot\Clear-DiagTrackLog.ps1
. $PSScriptRoot\Set-OneDrive.ps1
. $PSScriptRoot\Set-Services.ps1
. $PSScriptRoot\Set-Telemetry.ps1
. $PSScriptRoot\Set-TrackingServerHostsEntries.ps1
. $PSScriptRoot\Set-TrackingServerIpAddressEntries.ps1

switch ($Action) {
    "EnableTracking" {
        Set-Telemetry Enable
        Set-Services Enable
        Set-TrackingServerHostsEntries Remove
        Set-TrackingServerIpAddressEntries Remove
        Set-OneDrive Enable
    }
    "DisableTracking" {
        Set-Telemetry Disable
        Set-Services Disable
        Clear-DiagTrackLog
        Set-TrackingServerHostsEntries Add
        Set-TrackingServerIpAddressEntries Add
        Set-OneDrive Disable
    }
    "DisableTrackingAndDeleteServices" {
        Set-Telemetry Disable
        Set-Services Delete
        Clear-DiagTrackLog
        Set-TrackingServerHostsEntries Add
        Set-TrackingServerIpAddressEntries Add
        Set-OneDrive Disable
    }
}