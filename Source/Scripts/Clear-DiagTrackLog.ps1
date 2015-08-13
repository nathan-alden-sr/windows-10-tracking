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