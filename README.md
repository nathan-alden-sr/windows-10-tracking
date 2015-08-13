# Summary

This PowerShell script enables or disables various tracking components in Windows 10. It can be used in a fully-automated environment to enable or disable Windows 10 tracking.

This script was originally based on https://github.com/10se1ucgo/DisableWinTracking.

# Warnings

**Use this script at your own risk!**

When choosing to delete Windows services, note that the services are **permanently deleted**.

# What the script does

* Sets the `HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection\AllowTelemetry` value
* Manipulates the `DiagTrack` and `dmwappushservice` Windows services
* Clears the `DiagTrack` service's log stored at `$env:SystemDrive\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl`
* Manages `HOSTS` file entries for numerous Microsoft tracking servers
* Manages OneDrive

# How to use the script

The script consists of several cmdlets, each of which performs a distinct duty with regards to Windows 10 tracking. The script itself is also a cmdlet. The script supports the `-Verbose` flag.

* Enable tracking: `.\windows-10-tracking.ps1 Enable`
* Disable tracking: `.\windows-10-tracking.ps1 Disable`
* Disable tracking and deletes offending Windows services: `.\windows-10-tracking.ps1 DeleteAndDisable`

Feel free to modify the script if you'd like to control what and how the individual cmdlets are called.

# Disclaimer

THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.