Add-Type @'
using System;
using System.Text;
using System.Runtime.InteropServices;
public class UI {
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EnumProc cb, IntPtr l);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr h, uint msg, IntPtr w, IntPtr l);
  public static IntPtr Find(IntPtr parent, string text) {
    IntPtr found = IntPtr.Zero;
    EnumChildWindows(parent, (h,l) => {
      var t = new StringBuilder(256); GetWindowText(h, t, 256);
      if (t.ToString() == text) { found = h; return false; }
      return true;
    }, IntPtr.Zero);
    return found;
  }
}
'@
$p = $null
for ($i = 0; $i -lt 40; $i++) {
  $p = Get-Process -Name 'th07_multi' -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($p -and $p.MainWindowHandle -ne 0) { break }
  Start-Sleep -Milliseconds 500
}
if (-not $p) { Write-Host 'th07_multi did not start'; exit 1 }
$h = $p.MainWindowHandle
$local = [UI]::Find($h, 'Start Game (local)')
if ($local -ne [IntPtr]::Zero) {
  [UI]::PostMessage($local, 0xF5, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null
  Write-Host 'Started local 2P: P1 = you, P2 = bot'
} else {
  Write-Host 'Start button not found; click it manually'
}
