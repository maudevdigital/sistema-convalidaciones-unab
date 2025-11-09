# 🧪 Test de Integración HU-001 + HU-005
# Este test envía datos inválidos a HU-001, que debería llamar a HU-005 para enviar email

Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  🧪 TEST INTEGRACIÓN: HU-001 → HU-005" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$webhookHU001 = "http://localhost:5678/webhook/solicitud-convalidacion"
$emailEstudiante = "lucasmaulenr@gmail.com"

Write-Host "📋 Escenarios de prueba:" -ForegroundColor White
Write-Host "  1. Campos faltantes" -ForegroundColor Gray
Write-Host "  2. RUT inválido" -ForegroundColor Gray
Write-Host "  3. Email inválido" -ForegroundColor Gray
Write-Host ""

# ═══════════════════════════════════════════════════════════
# TEST 1: Campos Faltantes
# ═══════════════════════════════════════════════════════════
Write-Host "─────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "📤 TEST 1: Campos Faltantes" -ForegroundColor Cyan
Write-Host "─────────────────────────────────────────────────────" -ForegroundColor DarkGray

$body1 = @{
    nombre = "Juan Pérez"
    email = $emailEstudiante
    # Faltan: rut, carrera, asignatura, institucionOrigen, documentos
} | ConvertTo-Json

Write-Host "Enviando solicitud incompleta a HU-001..." -ForegroundColor Yellow

try {
    $response1 = Invoke-RestMethod -Uri $webhookHU001 -Method Post -Body $body1 -ContentType "application/json"
    
    Write-Host "✅ Respuesta de HU-001:" -ForegroundColor Green
    $response1 | ConvertTo-Json -Depth 3
    
    if ($response1.success -eq $false) {
        Write-Host ""
        Write-Host "❌ Solicitud rechazada (esperado)" -ForegroundColor Yellow
        Write-Host "   Errores: $($response1.errors -join ', ')" -ForegroundColor Gray
        Write-Host ""
        Write-Host "📧 HU-005 debería enviar email a: $emailEstudiante" -ForegroundColor Cyan
        Write-Host "   Tipo: campos_faltantes" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ ERROR en HU-001: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Start-Sleep -Seconds 2

# ═══════════════════════════════════════════════════════════
# TEST 2: RUT Inválido
# ═══════════════════════════════════════════════════════════
Write-Host "─────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "📤 TEST 2: RUT Inválido" -ForegroundColor Cyan
Write-Host "─────────────────────────────────────────────────────" -ForegroundColor DarkGray

$body2 = @{
    nombre = "María González"
    rut = "12345678-0"  # RUT inválido
    carrera = "Ingeniería Civil"
    asignatura = "Cálculo I"
    institucionOrigen = "Universidad de Chile"
    email = $emailEstudiante
    documentos = "certificado.pdf"
} | ConvertTo-Json

Write-Host "Enviando solicitud con RUT inválido a HU-001..." -ForegroundColor Yellow

try {
    $response2 = Invoke-RestMethod -Uri $webhookHU001 -Method Post -Body $body2 -ContentType "application/json"
    
    Write-Host "✅ Respuesta de HU-001:" -ForegroundColor Green
    $response2 | ConvertTo-Json -Depth 3
    
    if ($response2.success -eq $false) {
        Write-Host ""
        Write-Host "❌ Solicitud rechazada (esperado)" -ForegroundColor Yellow
        Write-Host "   Errores: $($response2.errors -join ', ')" -ForegroundColor Gray
        Write-Host ""
        Write-Host "📧 HU-005 debería enviar email a: $emailEstudiante" -ForegroundColor Cyan
        Write-Host "   Tipo: formato_incorrecto (RUT)" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ ERROR en HU-001: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Start-Sleep -Seconds 2

# ═══════════════════════════════════════════════════════════
# TEST 3: Email Inválido
# ═══════════════════════════════════════════════════════════
Write-Host "─────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "📤 TEST 3: Email Inválido" -ForegroundColor Cyan
Write-Host "─────────────────────────────────────────────────────" -ForegroundColor DarkGray

$body3 = @{
    nombre = "Pedro Sánchez"
    rut = "19876543-2"  # RUT válido
    carrera = "Ingeniería Informática"
    asignatura = "Programación"
    institucionOrigen = "Universidad Técnica"
    email = "email-invalido"  # Email sin @ ni dominio
    documentos = "notas.pdf"
} | ConvertTo-Json

Write-Host "Enviando solicitud con email inválido a HU-001..." -ForegroundColor Yellow

try {
    $response3 = Invoke-RestMethod -Uri $webhookHU001 -Method Post -Body $body3 -ContentType "application/json"
    
    Write-Host "✅ Respuesta de HU-001:" -ForegroundColor Green
    $response3 | ConvertTo-Json -Depth 3
    
    if ($response3.success -eq $false) {
        Write-Host ""
        Write-Host "❌ Solicitud rechazada (esperado)" -ForegroundColor Yellow
        Write-Host "   Errores: $($response3.errors -join ', ')" -ForegroundColor Gray
        Write-Host ""
        Write-Host "📧 HU-005 debería enviar email a admin (email estudiante inválido)" -ForegroundColor Cyan
        Write-Host "   Tipo: formato_incorrecto (email)" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ ERROR en HU-001: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✅ TESTS COMPLETADOS" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "📧 Revisa tu email: $emailEstudiante" -ForegroundColor Yellow
Write-Host "📊 Verifica ejecuciones en n8n:" -ForegroundColor Yellow
Write-Host "   - HU-001-MEJORADO (tab Executions)" -ForegroundColor Gray
Write-Host "   - HU-005 (tab Executions)" -ForegroundColor Gray
Write-Host ""
Write-Host "💡 NOTA:" -ForegroundColor Cyan
Write-Host "   Para que estos tests funcionen completamente, necesitas" -ForegroundColor White
Write-Host "   agregar nodos HTTP Request en HU-001-MEJORADO que llamen" -ForegroundColor White
Write-Host "   al webhook de HU-005 cuando hay errores de validación." -ForegroundColor White
Write-Host ""
Write-Host "   Ver: hu005/docs/INTEGRACION_HU-001_CON_HU-005.md" -ForegroundColor Gray
Write-Host ""
