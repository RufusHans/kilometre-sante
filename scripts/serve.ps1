$port = 8080
$root = Split-Path $PSScriptRoot -Parent
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "OK: http://localhost:$port/" -ForegroundColor Green
try {
  while ($listener.IsListening) {
    $context = $listener.GetContext()
    $path = $context.Request.Url.LocalPath
    if ($path -eq "/") { $path = "/index.html" }
    $file = Join-Path $root ($path.TrimStart("/").Replace("/", "\"))
    if (-not (Test-Path $file -PathType Leaf)) {
      $context.Response.StatusCode = 404
      $bytes = [Text.Encoding]::UTF8.GetBytes("404 Not Found")
      $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
      $ext = [IO.Path]::GetExtension($file).ToLower()
      $mime = @{
        ".html" = "text/html; charset=utf-8"
        ".css"  = "text/css"
        ".js"   = "application/javascript"
        ".json" = "application/json"
        ".png"  = "image/png"
        ".svg"  = "image/svg+xml"
        ".ico"  = "image/x-icon"
      }
      $context.Response.ContentType = $mime[$ext]
      if (-not $context.Response.ContentType) { $context.Response.ContentType = "application/octet-stream" }
      $bytes = [IO.File]::ReadAllBytes($file)
      $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    }
    $context.Response.Close()
  }
} finally {
  $listener.Stop()
}
