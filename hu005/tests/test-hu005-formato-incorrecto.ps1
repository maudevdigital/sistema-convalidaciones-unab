# 🧪 Test HU-005: Notificación de Corrección
# Ejecutar después de activar el webhook en n8n

# ⚠️ IMPORTANTE: Reemplaza estos valores antes de ejecutar:
# 1. $webhookUrl: Copia la URL del webhook desde n8n (nodo Webhook-HU004 → Production URL)
# 2. $tuEmail: Usa tu email real de Gmail para recibir el email de prueba

$webhookUrl = "http://localhost:5678/webhook-test/hu005-notificacion-correccion"
$tuEmail = "lucasmaulenr@gmail.com"

Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  🧪 TEST 1: Formato Incorrecto (.docx en vez de PDF)" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$body = @{
    idSolicitud = "SOL-TEST-001"
    estudiante = @{
        nombre = "Juan Pérez González"
        rut = "19.876.543-2"
        email = $tuEmail
    }
    error = @{
        tipo = "formato_incorrecto"
        mensaje = "Formato de archivo no válido"
        detalles = @{
            archivoNombre = "certificado.docx"
            archivoTipo = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            motivoRechazo = "Solo se aceptan archivos PDF"
        }
    }
    timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
} | ConvertTo-Json -Depth 5

Write-Host "📤 Enviando petición al webhook..." -ForegroundColor Cyan
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $body -ContentType "application/json"
    
    Write-Host "✅ ÉXITO - Respuesta del servidor:" -ForegroundColor Green
    Write-Host "════════════════════════════════════════════════════" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 5
    Write-Host ""
    Write-Host "📧 Revisa tu bandeja de entrada en: $tuEmail" -ForegroundColor Yellow
    Write-Host "   Asunto: 'Corrección Requerida - Formato de Documento Incorrecto'" -ForegroundColor Yellow
    Write-Host ""
    
} catch {
    Write-Host "❌ ERROR:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Verifica:" -ForegroundColor Yellow
    Write-Host "   1. Que el webhook esté activado (Listen for Test Event)" -ForegroundColor Yellow
    Write-Host "   2. Que la URL del webhook sea correcta" -ForegroundColor Yellow
    Write-Host "   3. Que n8n esté corriendo en localhost:5678" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
