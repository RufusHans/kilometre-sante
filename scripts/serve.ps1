$port = 8080
$root = Split-Path $PSScriptRoot -Parent

function Start-KilometreSanteServer {
  $listener = New-Object System.Net.HttpListener
  $listener.Prefixes.Add("http://localhost:$port/")
  $listener.Prefixes.Add("http://127.0.0.1:$port/")

  try {
    $listener.Start()
  } catch {
    Write-Host ""
    Write-Host "ERREUR: impossible de demarrer le serveur sur le port $port" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Essayez en administrateur, ou fermez l'autre programme qui utilise le port 8080."
    Read-Host "Appuyez sur Entree pour fermer"
    exit 1
  }

  Write-Host ""
  Write-Host "  Kilometre-Sante est pret !" -ForegroundColor Green
  Write-Host "  Ouvrez dans le navigateur :" -ForegroundColor Cyan
  Write-Host "  http://localhost:$port/" -ForegroundColor White
  Write-Host ""
  Write-Host "  Ne fermez pas cette fenetre tant que vous utilisez l'app."
  Write-Host ""

  try {
    while ($listener.IsListening) {
      $context = $listener.GetContext()
      $path = $context.Request.Url.LocalPath
      if ($path -eq "/") { $path = "/index.html" }
      $relative = $path.TrimStart("/").Replace("/", [IO.Path]::DirectorySeparatorChar)
      $file = [IO.Path]::GetFullPath((Join-Path $root $relative))

      if (-not $file.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) {
        $context.Response.StatusCode = 403
        $context.Response.Close()
        continue
      }

      if (-not (Test-Path $file -PathType Leaf)) {
        $context.Response.StatusCode = 404
        $bytes = [Text.Encoding]::UTF8.GetBytes("404 - Fichier introuvable: $path")
        $context.Response.ContentType = "text/plain; charset=utf-8"
        $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
      } else {
        $ext = [IO.Path]::GetExtension($file).ToLower()
        $mime = @{
          ".html" = "text/html; charset=utf-8"
          ".css"  = "text/css; charset=utf-8"
          ".js"   = "application/javascript; charset=utf-8"
          ".json" = "application/json; charset=utf-8"
          ".png"  = "image/png"
          ".svg"  = "image/svg+xml"
          ".ico"  = "image/x-icon"
          ".bat"  = "text/plain"
        }
        if ($mime.ContainsKey($ext)) {
          $context.Response.ContentType = $mime[$ext]
        }
        $bytes = [IO.File]::ReadAllBytes($file)
        $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
      }
      $context.Response.Close()
    }
  } finally {
    $listener.Stop()
  }
}

Start-KilometreSanteServer
