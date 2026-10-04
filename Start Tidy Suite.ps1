# Tidy Suite local server
# Serves this folder so every app runs from one web address:
#   on this computer:      http://localhost:8765
#   on your home network:  http://<this computer's address>:8765  (shown when it starts)
# No install needed: it uses PowerShell, which comes with Windows.
# Close this window (or press Ctrl+C) to stop it.
#
#   -LocalOnly   only this computer can open the suite
#   -Port 8766   use a different port (each port keeps its own saved work)
#   -NoBrowser   don't open the browser when it starts

param(
  [int]$Port = 8765,
  [switch]$LocalOnly,
  [switch]$NoBrowser
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Local = "http://localhost:$Port/"
$Host.UI.RawUI.WindowTitle = "Tidy Suite - $Local"

# The home page: index.html in the GitHub copy, "Open Tidy Suite.html" in the My Apps copy.
$HomePage = @('index.html', 'Open Tidy Suite.html') | Where-Object { Test-Path (Join-Path $Root $_) } | Select-Object -First 1
if (-not $HomePage) { $HomePage = 'index.html' }

$Types = @{
  '.html'='text/html; charset=utf-8'; '.htm'='text/html; charset=utf-8'; '.css'='text/css; charset=utf-8'
  '.js'='text/javascript; charset=utf-8'; '.mjs'='text/javascript; charset=utf-8'; '.json'='application/json; charset=utf-8'
  '.png'='image/png'; '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'; '.gif'='image/gif'; '.svg'='image/svg+xml'
  '.webp'='image/webp'; '.ico'='image/x-icon'; '.pdf'='application/pdf'; '.txt'='text/plain; charset=utf-8'
  '.md'='text/plain; charset=utf-8'; '.csv'='text/csv; charset=utf-8'; '.woff'='font/woff'; '.woff2'='font/woff2'
  '.mp3'='audio/mpeg'; '.wav'='audio/wav'; '.mp4'='video/mp4'
}
# Never hand out the launcher itself or other non-app files.
$Blocked = @('.ps1', '.bat', '.cmd', '.exe', '.lnk')

function Open-Browser { if (-not $NoBrowser) { Start-Process $Local } }

$bindTo = if ($LocalOnly) { [System.Net.IPAddress]::Loopback } else { [System.Net.IPAddress]::Any }
$listener = New-Object System.Net.Sockets.TcpListener($bindTo, $Port)
try {
  $listener.Start()
} catch {
  try {
    $r = Invoke-WebRequest -Uri $Local -UseBasicParsing -TimeoutSec 3
    if ($r.Content -match 'Tidy Suite') {
      Write-Host "Tidy Suite is already running at $Local" -ForegroundColor Green
      Open-Browser
      Start-Sleep -Seconds 2
      exit
    }
  } catch {}
  Write-Host "Port $Port is being used by another program." -ForegroundColor Yellow
  Write-Host "Close that program, or start the suite with:  -Port 8766" -ForegroundColor Yellow
  Write-Host "(A different port starts with fresh saved work, so stick with one port.)"
  Read-Host "Press Enter to close"
  exit 1
}

Write-Host ""
Write-Host "  Tidy Suite is running" -ForegroundColor Green
Write-Host "  On this computer:  $Local"
if (-not $LocalOnly) {
  $ips = @()
  try {
    $ips = [System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName()) |
      Where-Object { $_.AddressFamily -eq 'InterNetwork' -and -not $_.ToString().StartsWith('127.') -and -not $_.ToString().StartsWith('169.254.') } |
      ForEach-Object { $_.ToString() } | Select-Object -Unique
  } catch {}
  if ($ips) {
    foreach ($ip in $ips) { Write-Host "  On your network:   http://${ip}:$Port/" -ForegroundColor Cyan }
    Write-Host "  Phones and computers on the same Wi-Fi can open that address."
    Write-Host "  If Windows asks, allow access on Private networks."
  }
}
Write-Host "  Leave this window open while you use the apps. Close it to stop."
Write-Host ""
Open-Browser

$sep = [System.IO.Path]::DirectorySeparatorChar
$rootFull = [System.IO.Path]::GetFullPath($Root).TrimEnd($sep) + $sep
$utf8 = [System.Text.Encoding]::UTF8

function Send($stream, [int]$code, [string]$status, [string]$type, [byte[]]$body, [bool]$head) {
  $hdr = "HTTP/1.1 $code $status`r`nContent-Type: $type`r`nContent-Length: $($body.Length)`r`nCache-Control: no-cache`r`nX-Content-Type-Options: nosniff`r`nConnection: close`r`n`r`n"
  $hb = [System.Text.Encoding]::ASCII.GetBytes($hdr)
  $stream.Write($hb, 0, $hb.Length)
  if (-not $head -and $body.Length) { $stream.Write($body, 0, $body.Length) }
}
function NotFound($stream, [string]$rel, [bool]$head) {
  $msg = $utf8.GetBytes("<!doctype html><meta charset=utf-8><meta name=viewport content='width=device-width'><title>Not found</title><body style='font-family:system-ui;padding:40px'><h1>Not found</h1><p>There's no <b>$([System.Net.WebUtility]::HtmlEncode($rel))</b> in the Tidy Suite folder.</p><p><a href='/'>Go to the Tidy Suite home page</a></p>")
  Send $stream 404 'Not Found' 'text/html; charset=utf-8' $msg $head
}

try {
  while ($true) {
    $client = $listener.AcceptTcpClient()
    try {
      $client.ReceiveTimeout = 5000; $client.SendTimeout = 15000
      $stream = $client.GetStream()
      # Read the request headers (up to 16 KB).
      $buf = New-Object byte[] 16384; $got = 0; $text = ''
      while ($got -lt $buf.Length) {
        $n = $stream.Read($buf, $got, $buf.Length - $got)
        if ($n -le 0) { break }
        $got += $n
        $text = [System.Text.Encoding]::ASCII.GetString($buf, 0, $got)
        if ($text.Contains("`r`n`r`n")) { break }
      }
      $first = ($text -split "`r`n")[0]
      $parts = $first -split ' '
      if ($parts.Length -lt 2) { continue }
      $method = $parts[0]; $target = $parts[1]
      $isHead = $method -eq 'HEAD'
      if ($method -ne 'GET' -and -not $isHead) { Send $stream 405 'Method Not Allowed' 'text/plain' $utf8.GetBytes('Only GET is supported') $false; continue }
      $pathPart = ($target -split '[?#]')[0]
      $rel = [System.Uri]::UnescapeDataString($pathPart).TrimStart('/')
      if ($rel -eq '') { $rel = $HomePage }
      $path = [System.IO.Path]::GetFullPath((Join-Path $Root ($rel -replace '[\\/]', $sep)))
      if (Test-Path $path -PathType Container) {
        $leaf = (Split-Path $path -Leaf).ToLower()
        $idx = @('index.html', "$leaf.html") | ForEach-Object { Join-Path $path $_ } | Where-Object { Test-Path $_ } | Select-Object -First 1
        if ($idx) { $path = $idx }
      }
      $ext = [System.IO.Path]::GetExtension($path).ToLower()
      $code = 200
      if (-not $path.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path $path -PathType Leaf) -or $Blocked -contains $ext) {
        NotFound $stream $rel $isHead; $code = 404
      } else {
        $type = if ($Types.ContainsKey($ext)) { $Types[$ext] } else { 'application/octet-stream' }
        Send $stream 200 'OK' $type ([System.IO.File]::ReadAllBytes($path)) $isHead
      }
      $who = ''; try { $who = $client.Client.RemoteEndPoint.Address.ToString() } catch {}
      Write-Host ("  {0:HH:mm:ss}  {1}  {2,-15}  {3}" -f (Get-Date), $code, $who, $rel) -ForegroundColor DarkGray
    } catch {
      # A visitor closed the page mid-download, or sent something odd. Keep serving.
    } finally {
      try { $client.Close() } catch {}
    }
  }
} finally {
  $listener.Stop()
}
