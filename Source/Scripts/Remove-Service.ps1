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