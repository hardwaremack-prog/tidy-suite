# Tidy Suite local server
# Serves this folder so every app runs from one web address:
#   on this computer:      http://localhost:8780
#   on your home network:  http://<this computer's address>:8780  (shown when it starts)
# No install needed: it uses PowerShell, which comes with Windows.
# Close this window (or press Ctrl+C) to stop it.
# Server mode: each person's work is saved in the "Saved work" folder next to this file,
# so they can pick up on any device. Opening an app file directly still works on its own.
#
#   -LocalOnly   only this computer can open the suite
#   -Port 8781   use a different port (each port keeps its own saved work)
#   -NoBrowser   don't open the browser when it starts

param(
  [int]$Port = 8780,
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
  Write-Host "Close that program, or start the suite with:  -Port 8781" -ForegroundColor Yellow
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
Write-Host "  Server mode: everyone's work is saved in the 'Saved work' folder here."
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
function SendText($stream, [int]$code, [string]$text, [string]$type = 'application/json; charset=utf-8') {
  $status = @{200='OK';204='No Content';400='Bad Request';404='Not Found';405='Method Not Allowed';413='Too Large';500='Error'}[$code]
  Send $stream $code $status $type $utf8.GetBytes($text) $false
}
function NotFound($stream, [string]$rel, [bool]$head) {
  $msg = $utf8.GetBytes("<!doctype html><meta charset=utf-8><meta name=viewport content='width=device-width'><title>Not found</title><body style='font-family:system-ui;padding:40px'><h1>Not found</h1><p>There's no <b>$([System.Net.WebUtility]::HtmlEncode($rel))</b> in the Tidy Suite folder.</p><p><a href='/'>Go to the Tidy Suite home page</a></p>")
  Send $stream 404 'Not Found' 'text/html; charset=utf-8' $msg $head
}

# ---------- server mode: everyone's saved work lives in the "Saved work" folder ----------
$Store = Join-Path $Root 'Saved work'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
function Hex([string]$s) { ([System.BitConverter]::ToString($utf8.GetBytes($s))) -replace '-', '' }
function Unhex([string]$h) { $b = New-Object byte[] ($h.Length / 2); for ($i = 0; $i -lt $b.Length; $i++) { $b[$i] = [System.Convert]::ToByte($h.Substring($i * 2, 2), 16) }; $utf8.GetString($b) }
function JStr([string]$s) {
  $s = $s.Replace('\', '\\').Replace('"', '\"').Replace("`n", '\n').Replace("`r", '\r').Replace("`t", '\t')
  if ($s -match '[\x00-\x1f]') { $s = [regex]::Replace($s, '[\x00-\x1f]', { param($m) '\u{0:x4}' -f [int][char]$m.Value }) }
  '"' + $s + '"'
}
function WriteFileSafe([string]$path, [string]$text) {
  $dir = Split-Path $path -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
  $tmp = "$path.tmp"
  [System.IO.File]::WriteAllText($tmp, $text, $utf8NoBom)
  if (Test-Path $path) { [System.IO.File]::Replace($tmp, $path, [NullString]::Value) } else { [System.IO.File]::Move($tmp, $path) }
}
function Query([string]$target) {
  $q = @{}
  $i = $target.IndexOf('?'); if ($i -lt 0) { return $q }
  foreach ($pair in $target.Substring($i + 1).Split('&')) {
    if (-not $pair) { continue }
    $kv = $pair.Split('=', 2)
    $q[[System.Uri]::UnescapeDataString($kv[0])] = if ($kv.Length -gt 1) { [System.Uri]::UnescapeDataString($kv[1].Replace('+', ' ')) } else { '' }
  }
  $q
}
function Api($stream, [string]$method, [string]$route, $q, [string]$body) {
  $uid = [string]$q['user']
  if ($uid -and $uid -notmatch '^[A-Za-z0-9_-]{1,40}$') { SendText $stream 400 '{"error":"bad person"}'; return }
  $udir = if ($uid) { Join-Path $Store $uid } else { $null }
  switch ($route) {
    'hello' { SendText $stream 200 ('{"suite":"tidy","version":1,"computer":' + (JStr $env:COMPUTERNAME) + '}'); return }
    'users' {
      $f = Join-Path $Store 'people.json'
      if ($method -eq 'GET') { if (Test-Path $f) { SendText $stream 200 ([System.IO.File]::ReadAllText($f, $utf8)) } else { SendText $stream 404 'null' }; return }
      if ($method -eq 'PUT') { WriteFileSafe $f $body; SendText $stream 200 '{"ok":true}'; return }
    }
    'data' {
      if (-not $uid) { break }
      if ($method -eq 'GET') {
        if (-not (Test-Path $udir)) { SendText $stream 404 '{}'; return }
        $parts = New-Object System.Collections.Generic.List[string]
        foreach ($file in Get-ChildItem -Path $udir -Filter '*.txt' -File) {
          $key = Unhex $file.BaseName
          $parts.Add((JStr $key) + ':' + (JStr ([System.IO.File]::ReadAllText($file.FullName, $utf8))))
        }
        SendText $stream 200 ('{' + ($parts -join ',') + '}'); return
      }
      if ($method -eq 'DELETE') { if (Test-Path $udir) { Remove-Item -Path $udir -Recurse -Force }; SendText $stream 200 '{"ok":true}'; return }
    }
    'item' {
      $key = [string]$q['key']
      if (-not $uid -or -not $key -or $key.Length -gt 200) { break }
      if (-not (Test-Path $udir)) { New-Item -ItemType Directory -Path $udir -Force | Out-Null }
      $f = Join-Path $udir ((Hex $key) + '.txt')
      if ($method -eq 'PUT') { WriteFileSafe $f $body; SendText $stream 200 '{"ok":true}'; return }
      if ($method -eq 'DELETE') { if (Test-Path $f) { Remove-Item $f -Force }; SendText $stream 200 '{"ok":true}'; return }
    }
  }
  SendText $stream 400 '{"error":"unknown request"}'
}

try {
  while ($true) {
    $client = $listener.AcceptTcpClient()
    try {
      $client.ReceiveTimeout = 10000; $client.SendTimeout = 15000
      $stream = $client.GetStream()
      # Read the request headers (up to 64 KB).
      $buf = New-Object byte[] 65536; $got = 0; $text = ''; $end = -1
      while ($got -lt $buf.Length) {
        $n = $stream.Read($buf, $got, $buf.Length - $got)
        if ($n -le 0) { break }
        $got += $n
        $text = [System.Text.Encoding]::ASCII.GetString($buf, 0, $got)
        $end = $text.IndexOf("`r`n`r`n")
        if ($end -ge 0) { break }
      }
      if ($end -lt 0) { continue }
      $head = $text.Substring(0, $end)
      $parts = (($head -split "`r`n")[0]) -split ' '
      if ($parts.Length -lt 2) { continue }
      $method = $parts[0].ToUpper(); $target = $parts[1]
      $isHead = $method -eq 'HEAD'
      $pathPart = ($target -split '[?#]')[0]
      $who = ''; try { $who = $client.Client.RemoteEndPoint.Address.ToString() } catch {}

      if ($pathPart.StartsWith('/api/')) {
        # Read the body for saves.
        $len = 0; if ($head -match '(?im)^Content-Length:\s*(\d+)') { $len = [int64]$matches[1] }
        if ($len -gt 60MB) { SendText $stream 413 '{"error":"too large"}'; continue }
        $bodyBytes = New-Object byte[] $len
        $have = [Math]::Min($len, $got - ($end + 4))
        if ($have -gt 0) { [Array]::Copy($buf, $end + 4, $bodyBytes, 0, $have) }
        while ($have -lt $len) { $n = $stream.Read($bodyBytes, $have, $len - $have); if ($n -le 0) { break }; $have += $n }
        $route = $pathPart.Substring(5).Trim('/')
        Api $stream $method $route (Query $target) ($utf8.GetString($bodyBytes, 0, $have))
        if ($method -ne 'GET') { Write-Host ("  {0:HH:mm:ss}  saved  {1,-15}  {2} {3}" -f (Get-Date), $who, $method, $route) -ForegroundColor DarkCyan }
        continue
      }

      if ($method -ne 'GET' -and -not $isHead) { SendText $stream 405 'Only GET is supported' 'text/plain'; continue }
      $rel = [System.Uri]::UnescapeDataString($pathPart).TrimStart('/')
      if ($rel -eq '') { $rel = $HomePage }
      $path = [System.IO.Path]::GetFullPath((Join-Path $Root ($rel -replace '[\\/]', $sep)))
      if (Test-Path $path -PathType Container) {
        $leaf = (Split-Path $path -Leaf).ToLower()
        $idx = @('index.html', "$leaf.html") | ForEach-Object { Join-Path $path $_ } | Where-Object { Test-Path $_ } | Select-Object -First 1
        if ($idx) { $path = $idx }
      }
      $ext = [System.IO.Path]::GetExtension($path).ToLower()
      $storeFull = [System.IO.Path]::GetFullPath($Store).TrimEnd($sep) + $sep
      $code = 200
      if (-not $path.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase) -or $path.StartsWith($storeFull, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path $path -PathType Leaf) -or $Blocked -contains $ext) {
        NotFound $stream $rel $isHead; $code = 404
      } else {
        $type = if ($Types.ContainsKey($ext)) { $Types[$ext] } else { 'application/octet-stream' }
        Send $stream 200 'OK' $type ([System.IO.File]::ReadAllBytes($path)) $isHead
      }
      Write-Host ("  {0:HH:mm:ss}  {1}  {2,-15}  {3}" -f (Get-Date), $code, $who, $rel) -ForegroundColor DarkGray
    } catch {
      # A visitor closed the page mid-download, or sent something odd. Keep serving.
      try { Write-Host ("  {0:HH:mm:ss}  problem: {1}" -f (Get-Date), $_.Exception.Message) -ForegroundColor DarkYellow } catch {}
    } finally {
      try { $client.Close() } catch {}
    }
  }
} finally {
  $listener.Stop()
}
