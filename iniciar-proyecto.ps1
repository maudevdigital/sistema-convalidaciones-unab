# Script para iniciar n8n y el formulario HTML
# Autor: Sistema de Convalidaciones UNAB
# Fecha: 20/10/2025

Write-Host "🚀 Iniciando proyecto n8n..." -ForegroundColor Cyan
Write-Host ""

# 1. Verificar si Docker está corriendo
Write-Host "🐳 Verificando Docker..." -ForegroundColor Yellow
$dockerRunning = docker ps 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Docker no está corriendo. Iniciando Docker Desktop..." -ForegroundColor Yellow
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    Write-Host "⏳ Esperando 25 segundos a que Docker inicie..." -ForegroundColor Yellow
    Start-Sleep -Seconds 25
} else {
    Write-Host "✅ Docker ya está corriendo" -ForegroundColor Green
}

# 2. Iniciar n8n con docker-compose
Write-Host ""
Write-Host "🔧 Iniciando n8n..." -ForegroundColor Yellow
docker-compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ n8n iniciado correctamente" -ForegroundColor Green
} else {
    Write-Host "❌ Error al iniciar n8n" -ForegroundColor Red
    exit 1
}

# 3. Esperar a que n8n esté listo
Write-Host ""
Write-Host "⏳ Esperando a que n8n esté listo..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# 4. Abrir n8n en el navegador
Write-Host ""
Write-Host "🌐 Abriendo n8n en el navegador..." -ForegroundColor Yellow
Start-Process "http://localhost:5678"

# 5. Abrir el formulario HTML
Write-Host "📝 Abriendo formulario HTML..." -ForegroundColor Yellow
Start-Process "$PSScriptRoot\developers\lucas\hu001\formulario-convalidacion-unab.html"

Write-Host ""
Write-Host "✅ ¡Todo listo!" -ForegroundColor Green
Write-Host ""
Write-Host "📌 URLs importantes:" -ForegroundColor Cyan
Write-Host "   - n8n: http://localhost:5678" -ForegroundColor White
Write-Host "   - Webhook: http://localhost:5678/webhook/solicitud-convalidacion" -ForegroundColor White
Write-Host ""
Write-Host "💡 Para detener n8n, ejecuta: docker-compose down" -ForegroundColor Yellow
