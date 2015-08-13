# Summary

These PowerShell scripts enable or disable various tracking components in Windows 10. They can be used from the PowerShell command line or in an automated environment; they do not require user input. These scripts are **not intended** to remove all tracking in Windows 10; they only manipulate certain tracking components.

This project was inspired by https://github.com/10se1ucgo/DisableWinTracking.

# Warnings

**Use this script at your own risk!**

When choosing to delete Windows services, note that the services are **permanently deleted**.

We have not personally tested every `HOSTS` entry. Some of them may cause applications and services to stop working. Feel free to modify the file containing the entries.

# What the scripts do

* Sets the `HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection\AllowTelemetry` value
* Manipulates the `DiagTrack` and `dmwappushservice` Windows services
* Clears the `DiagTrack` service's log stored at `$env:SystemDrive\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl`
* Manages `HOSTS` file entries for numerous Microsoft tracking servers
* Manages OneDrive

# How to use the scripts

The `windows-10-tracking.ps1` script dot-sources and calls individual cmdlet scripts, each of which perform a distinct duty with regards to Windows 10 tracking. All scripts support the `-Verbose` flag.

* Enable tracking: `.\windows-10-tracking.ps1 EnableTracking`
* Disable tracking: `.\windows-10-tracking.ps1 DisableTracking`
* Disable tracking and deletes offending Windows services: `.\windows-10-tracking.ps1 DisableTrackingAndDeleteServices`

The list of blocked hosts is managed in a file separate from the scripts.

# Disclaimer

THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.