# build.ps1
# Script to build IntiHub v1.7.0 Noble Deluxe

Write-Host "Iniciando build de IntiHub v1.7.0..." -ForegroundColor Cyan

# 1. Procesar con DarkLua
Write-Host "Ejecutando DarkLua..."
& darklua process src/Init.lua dist/temp.lua --config build/darklua.config.json

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error en DarkLua!" -ForegroundColor Red
    exit $LASTEXITCODE
}

# 2. Leer archivos
$header = Get-Content -Path "build/header.lua" -Raw
$bundle = Get-Content -Path "dist/temp.lua" -Raw

# 3. Reemplazar placeholders en el header
$version = "1.7.0"
$date = Get-Date -Format "yyyy-MM-dd"
$description = "Roblox UI Library - Noble Deluxe v2.0"
$repository = "https://github.com/Sam123mir/IntiHub-LibraryUI"
$discord = "https://discord.gg/intihub"
$license = "MIT"

$header = $header -replace '\{\{VERSION\}\}', $version
$header = $header -replace '\{\{BUILD_DATE\}\}', $date
$header = $header -replace '\{\{DESCRIPTION\}\}', $description
$header = $header -replace '\{\{REPOSITORY\}\}', $repository
$header = $header -replace '\{\{DISCORD\}\}', $discord
$header = $header -replace '\{\{LICENSE\}\}', $license

# 4. Combinar y Guardar
Write-Host "Combinando header y bundle..."
$final = $header + "`n`n" + $bundle
[System.IO.File]::WriteAllText("$PSScriptRoot/dist/main.lua", $final)

# Copy to root for deployment/loader
[System.IO.File]::WriteAllText("$PSScriptRoot/main.client.lua", $final)
[System.IO.File]::WriteAllText("$PSScriptRoot/main.lua", $final)

# 5. Limpiar
Remove-Item -Path "dist/temp.lua" -ErrorAction SilentlyContinue

Write-Host "Build completado con éxito: dist/main.lua y root scripts." -ForegroundColor Green
