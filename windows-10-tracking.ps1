#Require Version 4

<#
Author: Nathan Alden, Sr.
https://github.com/nathan-alden/windows-10-tracking

This script enables or disables various tracking components in Windows 10.
It can be used in a fully-automated environment to enable or disable Windows 10 tracking.

This script was originally based on https://github.com/10se1ucgo/DisableWinTracking/blob/master/run.py.

DELETING WINDOWS SERVICES IS AN IRREVERSIBLE ACTION!

USE THIS SCRIPT AT YOUR OWN RISK!

THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Enable","Disable","DeleteAndDisable")]
    [string] $Action)

Set-StrictMode -Version Latest

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

function Set-Services {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Enable","Disable","Delete")]
        [string] $Action)

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

            Write-Verbose "Removing DiagTrack service"
            
            Remove-Service DiagTrack

            Write-Verbose "Stopping dmwappushservice service"

            Stop-Service dmwappushservice -Force

            Write-Verbose "Removing dmwappushservice service"
            
            Remove-Service dmwappushservice
        }
    }

}

function Remove-Service {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string] $Name)

    $Service = Get-WmiObject -Class Win32_Service -Filter "Name='$Name'"
    if ($Service) {
    $Service
        $Service.Delete()
    }
}

function Clear-DiagTrackLog {
    [CmdletBinding()]
    param()

    $IsStarted = (Get-Service DiagTrack).Status -eq "Started"

    Write-Verbose "Stopping DiagTrack service"

    Stop-Service DiagTrack -Force

    $Path = "$env:SystemDrive\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"

    if (Test-Path $Path -PathType Leaf) {
        Write-Verbose "Clearing DiagTrack log"

        [IO.File]::WriteAllText($Path, "")
    }

    if ($IsStarted) {
        Write-Verbose "Starting DiagTrack service"

        Start-Service DiagTrack
    }
}

function Set-TrackingServerHostsEntries {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Add","Remove")]
        [string] $Action)

    $Hosts = @("adnxs.com", "c.msn.com", "g.msn.com", "h1.msn.com", "msedge.net", "rad.msn.com", `
               "ads.msn.com", "adnexus.net", "ac3.msn.com", "c.atdmt.com", "m.adnxs.com", "rad.msn.com", `
               "sO.2mdn.net", "ads1.msn.com", "ec.atdmt.com", "flex.msn.com", "rad.live.com", `
               "ui.skype.com", "msftncsi.com", "a-msedge.net", "a.rad.msn.com", "b.rad.msn.com", `
               "cdn.atdmt.com", "m.hotmail.com", "ads1.msads.net", "a.ads1.msn.com", "a.ads2.msn.com", `
               "apps.skype.com", "b.ads1.msn.com", "view.atdmt.com", "watson.live.com", "preview.msn.com", `
               "aidps.atdmt.com", "preview.msn.com", "static.2mdn.net", "a.ads2.msads.net", `
               "b.ads2.msads.net", "db3aqu.atdmt.com", "secure.adnxs.com", "www.msftncsi.com", `
               "cs1.wpc.v0cdn.net", "live.rads.msn.com", "ad.doubleclick.net", "bs.serving-sys.com", `
               "a-0001.a-msedge.net", "pricelist.skype.com", "a-0001.a-msedge.net", "a-0002.a-msedge.net", `
               "a-0003.a-msedge.net", "a-0004.a-msedge.net", "a-0005.a-msedge.net", "a-0006.a-msedge.net", `
               "a-0007.a-msedge.net", "a-0008.a-msedge.net", "a-0009.a-msedge.net", "choice.microsoft.com", `
               "watson.microsoft.com", "feedback.windows.com", "aka-cdn-ns.adtech.de", `
               "cds26.ams9.msecn.net", "lb1.www.ms.akadns.net", "corp.sts.microsoft.com", `
               "az361816.vo.msecnd.net", "az512334.vo.msecnd.net", "telemetry.microsoft.com", `
               "msntest.serving-sys.com", "secure.flashtalking.com", "telemetry.appex.bing.net", `
               "pre.footprintpredict.com", "pre.footprintpredict.com", "vortex.data.microsoft.com", `
               "statsfe2.ws.microsoft.com", "statsfe1.ws.microsoft.com", "df.telemetry.microsoft.com", `
               "oca.telemetry.microsoft.com", "sqm.telemetry.microsoft.com", "telemetry.urs.microsoft.com", `
               "survey.watson.microsoft.com", "compatexchange.cloudapp.net", "feedback.microsoft-hohm.com", `
               "s.gateway.messenger.live.com", "vortex-win.data.microsoft.com", `
               "feedback.search.microsoft.com", "schemas.microsoft.akadns.net ", `
               "watson.telemetry.microsoft.com", "choice.microsoft.com.nsatc.net", `
               "wes.df.telemetry.microsoft.com", "sqm.df.telemetry.microsoft.com", `
               "settings-win.data.microsoft.com", "redir.metaservices.microsoft.com", `
               "i1.services.social.microsoft.com", "vortex-sandbox.data.microsoft.com", `
               "diagnostics.support.microsoft.com", "watson.ppe.telemetry.microsoft.com", `
               "msnbot-65-55-108-23.search.msn.com", "telecommand.telemetry.microsoft.com", `
               "settings-sandbox.data.microsoft.com", "sls.update.microsoft.com.akadns.net", `
               "fe2.update.microsoft.com.akadns.net", "vortex-bn2.metron.live.com.nsatc.net", `
               "vortex-cy2.metron.live.com.nsatc.net", "oca.telemetry.microsoft.com.nsatc.net", `
               "sqm.telemetry.microsoft.com.nsatc.net", "reports.wes.df.telemetry.microsoft.com", `
               "corpext.msitadfs.glbdns2.microsoft.com", "services.wes.df.telemetry.microsoft.com", `
               "watson.telemetry.microsoft.com.nsatc.net", "statsfe2.update.microsoft.com.akadns.net", `
               "i1.services.social.microsoft.com.nsatc.net", `
               "telecommand.telemetry.microsoft.com.nsatc.net")
    $Path = [IO.Path]::Combine([Environment]::SystemDirectory, "drivers", "etc", "HOSTS")
    $BeginLine = Select-String -Path $Path -Pattern "^# BEGIN windows-10-tracking\.ps1$"
    $EndLine = Select-String -Path $Path -Pattern "^# END windows-10-tracking\.ps1$"

    switch ($Action) {
        "Add" {
            if (!$BeginLine -and !$EndLine) {
                Write-Verbose "Adding tracking server HOSTS file entries"

                $StringBuilder = New-Object Text.StringBuilder
                [void]$StringBuilder.AppendLine()
                [void]$StringBuilder.AppendLine()
                [void]$StringBuilder.AppendLine("# BEGIN windows-10-tracking.ps1")
                foreach ($HostEntry in $Hosts) {
                    [void]$StringBuilder.AppendLine("0.0.0.0 $HostEntry")
                }
                [void]$StringBuilder.Append("# END windows-10-tracking.ps1")

                Add-Content $Path $StringBuilder.ToString() -NoNewline -Force
            }
        }
        "Remove" {
            if ($BeginLine -and $EndLine) {
                Write-Verbose "Removing tracking server HOSTS file entries"

                $Contents = Get-Content $Path
                ($Contents | Select-Object -First ($BeginLine.LineNumber - 1)) + ($Contents | Select-Object -Skip $EndLine.LineNumber) | Set-Content $Path -Force
            }
        }
    }
}

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

switch ($Action) {
    "Enable" {
        Set-Telemetry Enable
        Set-Services Enable
        Set-TrackingServerHostsEntries Remove
        Set-OneDrive Enable
    }
    "Disable" {
        Set-Telemetry Disable
        Set-Services Disable
        Clear-DiagTrackLog
        Set-TrackingServerHostsEntries Add
        Set-OneDrive Disable
    }
    "DeleteAndDisable" {
        Set-Telemetry Disable
        Set-Services Delete
        Clear-DiagTrackLog
        Set-TrackingServerHostsEntries Add
        Set-OneDrive Disable
    }
}