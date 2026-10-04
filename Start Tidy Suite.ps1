# Tidy Suite local server
# Serves this folder at http://localhost:8765 so every app runs from one web address.
# No install needed: it uses PowerShell, which comes with Windows.
# Close this window (or press Ctrl+C) to stop it.

param(
  [int]$Port = 8765,
  [switch]$NoBrowser
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Base = "http://localhost:$Port/"
$Host.UI.RawUI.WindowTitle = "Tidy Suite - $Base"

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

function Open-Browser { if (-not $NoBrowser) { Start-Process $Base } }

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($Base)
try {
  $listener.Start()
} catch {
  # Port already in use. If it's already the suite, just open it.
  try {
    $r = Invoke-WebRequest -Uri $Base -UseBasicParsing -TimeoutSec 3
    if ($r.Content -match 'Tidy Suite') {
      Write-Host "Tidy Suite is already running at $Base" -ForegroundColor Green
      Open-Browser
      Start-Sleep -Seconds 2
      exit
    }
  } catch {}
  Write-Host "Port $Port is being used by another program." -ForegroundColor Yellow
  Write-Host "Close that program, or run:  .\Start Tidy Suite.ps1 -Port 8766" -ForegroundColor Yellow
  Write-Host "(Using a different port means the apps start with fresh saved data, so stick with one port.)"
  Read-Host "Press Enter to close"
  exit 1
}

Write-Host ""
Write-Host "  Tidy Suite is running" -ForegroundColor Green
Write-Host "  Open $Base in your browser"
Write-Host "  Leave this window open while you use the apps. Close it to stop."
Write-Host ""
Open-Browser

$sep = [System.IO.Path]::DirectorySeparatorChar
$rootFull = [System.IO.Path]::GetFullPath($Root).TrimEnd($sep) + $sep
try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $req = $ctx.Request; $res = $ctx.Response
    try {
      $rel = [System.Uri]::UnescapeDataString($req.Url.AbsolutePath).TrimStart('/')
      if ($rel -eq '') { $rel = $HomePage }
      $path = [System.IO.Path]::GetFullPath((Join-Path $Root ($rel -replace '/', $sep)))
      if ((Test-Path $path -PathType Container)) {
        $idx = @('index.html', ((Split-Path $path -Leaf).ToLower() + '.html')) | ForEach-Object { Join-Path $path $_ } | Where-Object { Test-Path $_ } | Select-Object -First 1
        if ($idx) { $path = $idx }
      }
      if (-not $path.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path $path -PathType Leaf)) {
        $res.StatusCode = 404
        $msg = [System.Text.Encoding]::UTF8.GetBytes("<!doctype html><meta charset=utf-8><title>Not found</title><body style='font-family:system-ui;padding:40px'><h1>Not found</h1><p>There's no <b>$([System.Net.WebUtility]::HtmlEncode($rel))</b> in the Tidy Suite folder.</p><p><a href='/'>Go to the Tidy Suite home page</a></p>")
        $res.ContentType = 'text/html; charset=utf-8'
        $res.OutputStream.Write($msg, 0, $msg.Length)
      } else {
        $ext = [System.IO.Path]::GetExtension($path).ToLower()
        $res.ContentType = if ($Types.ContainsKey($ext)) { $Types[$ext] } else { 'application/octet-stream' }
        $res.Headers['Cache-Control'] = 'no-cache'
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $res.ContentLength64 = $bytes.Length
        if ($req.HttpMethod -ne 'HEAD') { $res.OutputStream.Write($bytes, 0, $bytes.Length) }
      }
      Write-Host ("  {0:HH:mm:ss}  {1}  {2}" -f (Get-Date), $res.StatusCode, $rel) -ForegroundColor DarkGray
    } catch {
      try { $res.StatusCode = 500 } catch {}
    } finally {
      try { $res.OutputStream.Close() } catch {}
    }
  }
} finally {
  $listener.Stop()
}
