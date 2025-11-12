################################################################################
#
#  🧪 SUITE DE PRUEBAS COMPLETA - HU-005
#  Sistema de Convalidaciones Académicas UNAB
#  
#  Propósito: Validar sistema de notificaciones de corrección de documentos
#  Sprint: Sprint 2 (03-23 nov 2025)
#  Fecha: 12 noviembre 2025
#
################################################################################

#Requires -Version 5.1

<#
.SYNOPSIS
    Suite completa de pruebas para HU-005: Notificación de Corrección de Documentos

.DESCRIPTION
    Este script ejecuta una batería completa de pruebas para validar:
    - 4 Templates de email (formato, tamaño, corrupto, campos)
    - Validaciones de entrada (casos inválidos)
    - Integración con HU-001
    - Manejo de errores
    - Tiempos de respuesta

.PARAMETER Email
    Email donde se recibirán las notificaciones de prueba

.PARAMETER WebhookUrl
    URL del webhook HU-005 (por defecto: http://localhost:5678/webhook/hu005-notificacion-correccion)

.PARAMETER SkipIntegrationTests
    Omite las pruebas de integración con HU-001

.EXAMPLE
    .\test-hu005.ps1 -Email "tu-email@gmail.com"
    
.EXAMPLE
    .\test-hu005.ps1 -Email "test@test.com" -SkipIntegrationTests

.NOTES
    Autor: Equipo QA
    Última actualización: 12 nov 2025
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$Email = "maudevchile@gmail.com",
    
    [Parameter(Mandatory=$false)]
    [string]$WebhookUrl = "http://localhost:5678/webhook/hu005-notificacion-correccion",
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipIntegrationTests
)

# Variables globales
$script:TestsPassed = 0
$script:TestsFailed = 0
$script:TestsTotal = 0
$script:StartTime = Get-Date

################################################################################
# FUNCIONES AUXILIARES
################################################################################

function Write-TestHeader {
    param([string]$Message)
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  $Message" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

function Write-TestCase {
    param([string]$TestId, [string]$Description)
    Write-Host ""
    Write-Host "┌─────────────────────────────────────────────────────────────┐" -ForegroundColor DarkGray
    Write-Host "│ Test $TestId : $Description" -ForegroundColor White
    Write-Host "└─────────────────────────────────────────────────────────────┘" -ForegroundColor DarkGray
}

function Invoke-Test {
    param(
        [string]$TestId,
        [string]$Description,
        [hashtable]$RequestBody,
        [int]$ExpectedStatusCode = 200,
        [string]$ExpectedResult = "success"
    )
    
    $script:TestsTotal++
    Write-TestCase -TestId $TestId -Description $Description
    
    $testStartTime = Get-Date
    
    try {
        $json = $RequestBody | ConvertTo-Json -Depth 10
        
        Write-Host "   📤 Enviando request..." -ForegroundColor Gray
        Write-Host "   📍 URL: $WebhookUrl" -ForegroundColor DarkGray
        
        $response = Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $json -ContentType "application/json" -ErrorAction Stop
        
        $duration = ((Get-Date) - $testStartTime).TotalSeconds
        
        # Validar respuesta
        if ($response.success -eq $true -and $ExpectedResult -eq "success") {
            Write-Host "   ✅ PASS" -ForegroundColor Green
            Write-Host "   ⏱️  Tiempo: $([math]::Round($duration, 2))s" -ForegroundColor Gray
            Write-Host "   📧 Email enviado a: $($response.destinatario)" -ForegroundColor Gray
            $script:TestsPassed++
            return $true
        } elseif ($response.success -eq $false -and $ExpectedResult -eq "error") {
            Write-Host "   ✅ PASS (error esperado)" -ForegroundColor Green
            Write-Host "   ⚠️  Error: $($response.error)" -ForegroundColor Yellow
            $script:TestsPassed++
            return $true
        } else {
            Write-Host "   ❌ FAIL - Respuesta inesperada" -ForegroundColor Red
            Write-Host "   📋 Response: $($response | ConvertTo-Json -Compress)" -ForegroundColor Red
            $script:TestsFailed++
            return $false
        }
        
    } catch {
        $duration = ((Get-Date) - $testStartTime).TotalSeconds
        
        if ($ExpectedResult -eq "error") {
            Write-Host "   ✅ PASS (error esperado capturado)" -ForegroundColor Green
            Write-Host "   ⚠️  Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Yellow
            $script:TestsPassed++
            return $true
        } else {
            Write-Host "   ❌ FAIL" -ForegroundColor Red
            Write-Host "   ⚠️  Error: $($_.Exception.Message)" -ForegroundColor Red
            $script:TestsFailed++
            return $false
        }
    }
    
    Start-Sleep -Milliseconds 500
}

################################################################################
# VERIFICACIÓN PREVIA
################################################################################

Write-TestHeader "🔍 VERIFICACIÓN PREVIA"

Write-Host "   📍 Webhook URL: $WebhookUrl" -ForegroundColor White
Write-Host "   📧 Email destino: $Email" -ForegroundColor White
Write-Host "   📅 Fecha: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')" -ForegroundColor White

# Verificar si n8n está corriendo
Write-Host ""
Write-Host "   🔍 Verificando disponibilidad del webhook..." -ForegroundColor Yellow

try {
    $testConnection = Invoke-WebRequest -Uri $WebhookUrl -Method Get -TimeoutSec 3 -ErrorAction Stop
    Write-Host "   ✅ Webhook disponible" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 405) {
        Write-Host "   ✅ Webhook disponible (405 Method Not Allowed esperado)" -ForegroundColor Green
    } else {
        Write-Host "   ❌ ERROR: Webhook no disponible" -ForegroundColor Red
        Write-Host "   ⚠️  Asegúrate de que n8n esté corriendo y el workflow HU-005 activo" -ForegroundColor Yellow
        Write-Host ""
        exit 1
    }
}

Read-Host "`n   ⏸️  Presiona ENTER para continuar con las pruebas"

################################################################################
# CASOS DE PRUEBA - CA1: DETECCIÓN DE ERRORES
################################################################################

Write-TestHeader "📋 CA1: DETECCIÓN AUTOMÁTICA DE ERRORES"

# TC1.1: Formato Incorrecto
Invoke-Test -TestId "TC1.1" -Description "Formato de Archivo Incorrecto (.docx)" -RequestBody @{
    idSolicitud = "SOL-TEST-001"
    estudiante = @{
        nombre = "Juan Pérez González"
        rut = "12.345.678-5"
        email = $Email
    }
    error = @{
        tipo = "formato_incorrecto"
        mensaje = "El archivo no es un PDF válido"
        detalles = @{
            archivoNombre = "certificado.docx"
            archivoTipo = "application/msword"
            tamanoMB = "2.5"
            motivoRechazo = "Solo se aceptan archivos en formato PDF"
        }
    }
}

Start-Sleep -Seconds 2

# TC1.2: Tamaño Excedido
Invoke-Test -TestId "TC1.2" -Description "Archivo Supera Tamaño Máximo (15.8 MB)" -RequestBody @{
    idSolicitud = "SOL-TEST-002"
    estudiante = @{
        nombre = "María González Silva"
        rut = "98.765.432-1"
        email = $Email
    }
    error = @{
        tipo = "tamano_excedido"
        mensaje = "Archivo supera los 10 MB permitidos"
        detalles = @{
            archivoNombre = "programa_asignatura.pdf"
            archivoTipo = "application/pdf"
            tamanoMB = "15.8"
            motivoRechazo = "El archivo supera el tamaño máximo de 10 MB"
        }
    }
}

Start-Sleep -Seconds 2

# TC1.3: Archivo Corrupto
Invoke-Test -TestId "TC1.3" -Description "Archivo PDF Corrupto o Dañado" -RequestBody @{
    idSolicitud = "SOL-TEST-003"
    estudiante = @{
        nombre = "Pedro Silva Ramírez"
        rut = "11.223.344-5"
        email = $Email
    }
    error = @{
        tipo = "archivo_corrupto"
        mensaje = "El archivo PDF está dañado y no puede ser leído"
        detalles = @{
            archivoNombre = "notas.pdf"
            archivoTipo = "application/pdf"
            tamanoMB = "3.2"
            motivoRechazo = "El archivo está corrupto o dañado"
        }
    }
}

Start-Sleep -Seconds 2

# TC1.4: Campos Faltantes
Invoke-Test -TestId "TC1.4" -Description "Formulario con Campos Incompletos" -RequestBody @{
    idSolicitud = "SOL-TEST-004"
    estudiante = @{
        nombre = "Ana Torres López"
        rut = "55.667.788-9"
        email = $Email
    }
    error = @{
        tipo = "campos_faltantes"
        mensaje = "Información incompleta en la solicitud"
        detalles = @{
            archivoNombre = ""
            archivoTipo = ""
            camposFaltantes = @("Nombre completo", "RUT", "Carrera")
            motivoRechazo = "Faltan campos obligatorios en el formulario"
        }
    }
}

################################################################################
# CASOS DE PRUEBA - CA2: TEMPLATES PERSONALIZADOS
################################################################################

Write-TestHeader "📧 CA2: TEMPLATES DE EMAIL PERSONALIZADOS"

# TC2.5: Caracteres Especiales en Nombres
Invoke-Test -TestId "TC2.5" -Description "Nombre con Caracteres Especiales y Tildes" -RequestBody @{
    idSolicitud = "SOL-TEST-005"
    estudiante = @{
        nombre = "José María Fernández-O'Connor"
        rut = "16.789.012-3"
        email = $Email
    }
    error = @{
        tipo = "formato_incorrecto"
        mensaje = "Archivo en formato incorrecto"
        detalles = @{
            archivoNombre = "certificado_josé_maría.docx"
            archivoTipo = "application/msword"
            tamanoMB = "1.5"
            motivoRechazo = "Solo se aceptan archivos PDF"
        }
    }
}

################################################################################
# CASOS DE PRUEBA - CA3: ENVÍO Y RESPUESTAS
################################################################################

Write-TestHeader "📨 CA3: ENVÍO DE EMAILS Y RESPUESTAS HTTP"

Write-Host "   ℹ️  Los tests anteriores ya validaron el envío exitoso" -ForegroundColor Cyan
Write-Host "   ℹ️  Ahora se validan respuestas de error" -ForegroundColor Cyan

Start-Sleep -Seconds 1

################################################################################
# CASOS DE ERROR - VALIDACIONES
################################################################################

Write-TestHeader "❌ CASOS DE ERROR: VALIDACIÓN DE ENTRADAS"

# TC4.1: Datos Inválidos - Sin Email
Invoke-Test -TestId "TC4.1" -Description "Datos Inválidos: Falta Email Estudiante" -ExpectedResult "error" -RequestBody @{
    idSolicitud = "SOL-TEST-ERROR-001"
    estudiante = @{
        nombre = "Test Sin Email"
        rut = "12.345.678-9"
    }
    error = @{
        tipo = "formato_incorrecto"
        mensaje = "Test"
    }
}

Start-Sleep -Seconds 1

# TC4.2: Tipo de Error No Válido
Invoke-Test -TestId "TC4.2" -Description "Tipo de Error No Reconocido" -ExpectedResult "error" -RequestBody @{
    idSolicitud = "SOL-TEST-ERROR-002"
    estudiante = @{
        nombre = "Test Error Tipo"
        rut = "12.345.678-9"
        email = $Email
    }
    error = @{
        tipo = "tipo_invalido_xyz"
        mensaje = "Test tipo inválido"
    }
}

Start-Sleep -Seconds 1

# TC4.3: Email Mal Formado
Invoke-Test -TestId "TC4.3" -Description "Email con Formato Inválido" -ExpectedResult "error" -RequestBody @{
    idSolicitud = "SOL-TEST-ERROR-003"
    estudiante = @{
        nombre = "Test Email Inválido"
        rut = "12.345.678-9"
        email = "email-sin-arroba.com"
    }
    error = @{
        tipo = "formato_incorrecto"
        mensaje = "Test"
    }
}

Start-Sleep -Seconds 1

# TC4.5: Sin ID de Solicitud
Invoke-Test -TestId "TC4.5" -Description "Datos Inválidos: Falta ID Solicitud" -ExpectedResult "error" -RequestBody @{
    estudiante = @{
        nombre = "Test Sin ID"
        rut = "12.345.678-9"
        email = $Email
    }
    error = @{
        tipo = "formato_incorrecto"
        mensaje = "Test sin ID"
    }
}

################################################################################
# PRUEBAS DE INTEGRACIÓN (OPCIONAL)
################################################################################

if (-not $SkipIntegrationTests) {
    Write-TestHeader "🔗 PRUEBAS DE INTEGRACIÓN HU-001 ↔ HU-005"
    
    Write-Host "   ℹ️  Las pruebas de integración E2E requieren el workflow integrado activo" -ForegroundColor Cyan
    Write-Host "   ℹ️  Archivo: sistema-final/workflows/workflow.json" -ForegroundColor Cyan
    Write-Host ""
    
    $runIntegration = Read-Host "   ❓ ¿Ejecutar pruebas de integración? (s/N)"
    
    if ($runIntegration -eq 's' -or $runIntegration -eq 'S') {
        $huUrl = "http://localhost:5678/webhook/solicitud-convalidacion"
        
        Write-Host ""
        Write-Host "   📤 Enviando solicitud con PDF inválido a HU-001..." -ForegroundColor Yellow
        
        try {
            # Crear un "archivo" base64 inválido (no PDF)
            $fakeDocx = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("Fake DOCX content"))
            
            $integrationBody = @{
                nombre = "Test Integración E2E"
                rut = "19876543-2"
                email = $Email
                carrera = "Ingeniería en Informática"
                asignatura = "Programación Web"
                institucionOrigen = "Universidad de Chile"
                file = @{
                    filename = "certificado.docx"
                    data = $fakeDocx
                    mimeType = "application/msword"
                }
            } | ConvertTo-Json -Depth 10
            
            $integrationResponse = Invoke-RestMethod -Uri $huUrl -Method Post -Body $integrationBody -ContentType "application/json" -ErrorAction Stop
            
            Write-Host "   ✅ Solicitud procesada por HU-001" -ForegroundColor Green
            Write-Host "   🔗 HU-005 debería haberse activado automáticamente" -ForegroundColor Yellow
            Write-Host "   📧 Revisa tu email para confirmar" -ForegroundColor Yellow
            
            $script:TestsTotal++
            $script:TestsPassed++
            
        } catch {
            Write-Host "   ⚠️  Error en integración: $($_.Exception.Message)" -ForegroundColor Yellow
            Write-Host "   ℹ️  Esto puede ser normal si HU-001 no está activo" -ForegroundColor Cyan
            $script:TestsTotal++
            $script:TestsFailed++
        }
    } else {
        Write-Host "   ⏭️  Pruebas de integración omitidas" -ForegroundColor Gray
    }
}

################################################################################
# RESUMEN FINAL
################################################################################

$endTime = Get-Date
$totalDuration = ($endTime - $script:StartTime).TotalSeconds

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  📊 RESUMEN DE EJECUCIÓN" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Calcular tasa de éxito
$successRate = if ($script:TestsTotal -gt 0) { 
    [math]::Round(($script:TestsPassed / $script:TestsTotal) * 100, 1) 
} else { 
    0 
}

# Mostrar estadísticas
Write-Host "   📈 Total Tests Ejecutados: $script:TestsTotal" -ForegroundColor White
Write-Host "   ✅ Tests Exitosos: $script:TestsPassed" -ForegroundColor Green
Write-Host "   ❌ Tests Fallidos: $script:TestsFailed" -ForegroundColor $(if ($script:TestsFailed -gt 0) { "Red" } else { "Gray" })
Write-Host "   📊 Tasa de Éxito: $successRate%" -ForegroundColor $(if ($successRate -ge 90) { "Green" } elseif ($successRate -ge 70) { "Yellow" } else { "Red" })
Write-Host "   ⏱️  Tiempo Total: $([math]::Round($totalDuration, 2))s" -ForegroundColor White
Write-Host ""

# Validar emails recibidos
Write-Host "   📧 EMAILS ESPERADOS EN: $Email" -ForegroundColor Yellow
Write-Host ""
Write-Host "      1. Corrección Requerida - Formato de Archivo (TC1.1)" -ForegroundColor White
Write-Host "      2. Corrección Requerida - Tamaño Excedido (TC1.2)" -ForegroundColor White
Write-Host "      3. Corrección Requerida - Archivo Corrupto (TC1.3)" -ForegroundColor White
Write-Host "      4. Corrección Requerida - Campos Faltantes (TC1.4)" -ForegroundColor White
Write-Host "      5. Corrección Requerida - Caracteres Especiales (TC2.5)" -ForegroundColor White
Write-Host ""

# Verificación manual
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✋ VERIFICACIÓN MANUAL REQUERIDA" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$emailsReceived = Read-Host "   ❓ ¿Cuántos emails recibiste? (0-5)"

if ([int]$emailsReceived -ge 5) {
    Write-Host ""
    Write-Host "   🎉 ¡EXCELENTE! Todos los emails fueron recibidos" -ForegroundColor Green
    Write-Host "   ✅ HU-005 está funcionando correctamente" -ForegroundColor Green
} elseif ([int]$emailsReceived -ge 3) {
    Write-Host ""
    Write-Host "   ⚠️  Algunos emails no llegaron" -ForegroundColor Yellow
    Write-Host "   🔍 Revisa logs de n8n para más detalles" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "   ❌ Pocos emails recibidos" -ForegroundColor Red
    Write-Host "   🔍 Verifica configuración SMTP en n8n" -ForegroundColor Red
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  🔍 PRÓXIMOS PASOS" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

if ($script:TestsFailed -eq 0) {
    Write-Host "   ✅ Todos los tests pasaron exitosamente" -ForegroundColor Green
    Write-Host "   📋 HU-005 lista para Sprint Review" -ForegroundColor Green
    Write-Host ""
    Write-Host "   Acciones sugeridas:" -ForegroundColor White
    Write-Host "   1. Actualizar tareas en Taiga a 'Closed'" -ForegroundColor Gray
    Write-Host "   2. Capturar evidencias para documentación" -ForegroundColor Gray
    Write-Host "   3. Preparar demo para Sprint Review" -ForegroundColor Gray
} else {
    Write-Host "   ⚠️  Algunos tests fallaron" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   Acciones requeridas:" -ForegroundColor White
    Write-Host "   1. Revisar logs de n8n (Executions)" -ForegroundColor Gray
    Write-Host "   2. Verificar workflow HU-005 activo" -ForegroundColor Gray
    Write-Host "   3. Validar credenciales SMTP" -ForegroundColor Gray
    Write-Host "   4. Re-ejecutar tests después de correcciones" -ForegroundColor Gray
}

Write-Host ""
Write-Host "   📁 Logs de n8n: http://localhost:5678/executions" -ForegroundColor Cyan
Write-Host "   📧 Verifica tu bandeja de entrada: $Email" -ForegroundColor Cyan
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Código de salida
if ($script:TestsFailed -eq 0) {
    exit 0
} else {
    exit 1
}
