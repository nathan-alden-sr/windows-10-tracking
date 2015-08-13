function Set-TrackingServerHostsEntries {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Add","Remove")]
        [string] $Action,
        [string[]] $Hosts)

    if (!$Hosts) {
        $Hosts = Get-Content (Join-Path $PSScriptRoot hosts)
    }

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