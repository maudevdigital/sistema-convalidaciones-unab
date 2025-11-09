# 🧪 Tests Completos HU-005: Todos los Templates
# Ejecutar después de que funcione el Test 1

$webhookUrl = "http://localhost:5678/webhook-test/REEMPLAZA-CON-TU-WEBHOOK-ID"
$tuEmail = "TU_EMAIL@gmail.com"

Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  🧪 SUITE DE TESTS HU-005: 4 Templates de Email" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# ==================== TEST 1: Formato Incorrecto ====================
Write-Host "📋 Test 1/4: Formato Incorrecto" -ForegroundColor Cyan
$test1 = @{
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

try {
    $response1 = Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $test1 -ContentType "application/json"
    Write-Host "✅ Test 1 PASADO" -ForegroundColor Green
} catch {
    Write-Host "❌ Test 1 FALLIDO: $($_.Exception.Message)" -ForegroundColor Red
}
Start-Sleep -Seconds 2

# ==================== TEST 2: Tamaño Excedido ====================
Write-Host "📋 Test 2/4: Tamaño Excedido" -ForegroundColor Cyan
$test2 = @{
    idSolicitud = "SOL-TEST-002"
    estudiante = @{
        nombre = "María Silva Torres"
        rut = "18.234.567-8"
        email = $tuEmail
    }
    error = @{
        tipo = "tamano_excedido"
        mensaje = "Archivo supera tamaño máximo"
        detalles = @{
            archivoNombre = "certificado_notas.pdf"
            tamanoMB = 15.5
            tamanoMaximoMB = 10
            motivoRechazo = "El archivo supera el tamaño máximo de 10 MB"
        }
    }
    timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
} | ConvertTo-Json -Depth 5

try {
    $response2 = Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $test2 -ContentType "application/json"
    Write-Host "✅ Test 2 PASADO" -ForegroundColor Green
} catch {
    Write-Host "❌ Test 2 FALLIDO: $($_.Exception.Message)" -ForegroundColor Red
}
Start-Sleep -Seconds 2

# ==================== TEST 3: Archivo Corrupto ====================
Write-Host "📋 Test 3/4: Archivo Corrupto" -ForegroundColor Cyan
$test3 = @{
    idSolicitud = "SOL-TEST-003"
    estudiante = @{
        nombre = "Pedro Ramírez Castro"
        rut = "20.111.222-3"
        email = $tuEmail
    }
    error = @{
        tipo = "archivo_corrupto"
        mensaje = "El archivo no puede ser leído"
        detalles = @{
            archivoNombre = "certificado_corrupto.pdf"
            motivoRechazo = "El archivo está corrupto o dañado"
        }
    }
    timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
} | ConvertTo-Json -Depth 5

try {
    $response3 = Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $test3 -ContentType "application/json"
    Write-Host "✅ Test 3 PASADO" -ForegroundColor Green
} catch {
    Write-Host "❌ Test 3 FALLIDO: $($_.Exception.Message)" -ForegroundColor Red
}
Start-Sleep -Seconds 2

# ==================== TEST 4: Campos Faltantes ====================
Write-Host "📋 Test 4/4: Campos Faltantes" -ForegroundColor Cyan
$test4 = @{
    idSolicitud = "SOL-TEST-004"
    estudiante = @{
        nombre = "Ana López Martínez"
        rut = "19.555.666-7"
        email = $tuEmail
    }
    error = @{
        tipo = "campos_faltantes"
        mensaje = "Faltan campos obligatorios"
        detalles = @{
            camposFaltantes = @("asignaturaConvalidar", "institucionOrigen")
            motivoRechazo = "Debe completar todos los campos obligatorios"
        }
    }
    timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
} | ConvertTo-Json -Depth 5

try {
    $response4 = Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $test4 -ContentType "application/json"
    Write-Host "✅ Test 4 PASADO" -ForegroundColor Green
} catch {
    Write-Host "❌ Test 4 FALLIDO: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  📊 RESUMEN DE TESTS" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "📧 Deberías haber recibido 4 emails en: $tuEmail" -ForegroundColor Yellow
Write-Host ""
Write-Host "   1. Corrección Requerida - Formato de Documento Incorrecto" -ForegroundColor White
Write-Host "   2. Corrección Requerida - Archivo Demasiado Grande" -ForegroundColor White
Write-Host "   3. Corrección Requerida - Archivo No Puede Ser Leído" -ForegroundColor White
Write-Host "   4. Corrección Requerida - Información Incompleta" -ForegroundColor White
Write-Host ""
Write-Host "✅ Si recibiste los 4 emails, ¡HU-005 funciona perfectamente!" -ForegroundColor Green
Write-Host ""
