# Script HU-05_test.ps1
param([string]$Email)
Write-Host "SUITE DE PRUEBAS HU-005" -ForegroundColor Cyan
Write-Host "Email: $Email" -ForegroundColor White
$url = "http://localhost:5678/webhook/hu005-notificacion-correccion"
$tests = 0; $passed = 0
# TC1.1
$tests++
try {
    Invoke-RestMethod -Method Post -Uri $url -Body (@{idSolicitud="T01";estudiante=@{nombre="Juan";rut="12345678-5";email=$Email};error=@{tipo="formato_incorrecto";mensaje="Test";detalles=@{archivoNombre="cert.docx"}}} | ConvertTo-Json -Depth 10) -ContentType "application/json" | Out-Null
    $passed++; Write-Host "[TC1.1] PASS - Formato Incorrecto" -ForegroundColor Green
} catch { Write-Host "[TC1.1] FAIL" -ForegroundColor Red }
# TC1.2
$tests++
try {
    Invoke-RestMethod -Method Post -Uri $url -Body (@{idSolicitud="T02";estudiante=@{nombre="Maria";rut="98765432-1";email=$Email};error=@{tipo="tamano_excedido";mensaje="Test";detalles=@{archivoNombre="programa.pdf";tamanoMB="15.8"}}} | ConvertTo-Json -Depth 10) -ContentType "application/json" | Out-Null
    $passed++; Write-Host "[TC1.2] PASS - Tamano Excedido" -ForegroundColor Green
} catch { Write-Host "[TC1.2] FAIL" -ForegroundColor Red }
# TC1.3
$tests++
try {
    Invoke-RestMethod -Method Post -Uri $url -Body (@{idSolicitud="T03";estudiante=@{nombre="Pedro";rut="11223344-5";email=$Email};error=@{tipo="archivo_corrupto";mensaje="Test";detalles=@{archivoNombre="notas.pdf"}}} | ConvertTo-Json -Depth 10) -ContentType "application/json" | Out-Null
    $passed++; Write-Host "[TC1.3] PASS - Archivo Corrupto" -ForegroundColor Green
} catch { Write-Host "[TC1.3] FAIL" -ForegroundColor Red }
# TC1.4
$tests++
try {
    Invoke-RestMethod -Method Post -Uri $url -Body (@{idSolicitud="T04";estudiante=@{nombre="Ana";rut="55667788-9";email=$Email};error=@{tipo="campos_faltantes";mensaje="Test";detalles=@{camposFaltantes=@("RUT","Nombre")}}} | ConvertTo-Json -Depth 10) -ContentType "application/json" | Out-Null
    $passed++; Write-Host "[TC1.4] PASS - Campos Faltantes" -ForegroundColor Green
} catch { Write-Host "[TC1.4] FAIL" -ForegroundColor Red }
# TC2.5
$tests++
try {
    Invoke-RestMethod -Method Post -Uri $url -Body (@{idSolicitud="T05";estudiante=@{nombre="Jose Maria";rut="12345678-K";email=$Email};error=@{tipo="formato_incorrecto";mensaje="Test";detalles=@{archivoNombre="cert.docx"}}} | ConvertTo-Json -Depth 10) -ContentType "application/json" | Out-Null
    $passed++; Write-Host "[TC2.5] PASS - Caracteres Especiales" -ForegroundColor Green
} catch { Write-Host "[TC2.5] FAIL" -ForegroundColor Red }
Write-Host "`nRESUMEN: $passed/$tests tests pasaron" -ForegroundColor Cyan
Write-Host "Revisa tu email: $Email" -ForegroundColor White
