#!/bin/bash

# Script de prueba para HU-01: Recepción de Solicitud
# Ejecuta los casos de prueba principales del webhook

echo "🧪 INICIANDO PRUEBAS HU-01: Recepción de Solicitud"
echo "=================================================="

# Configuración
WEBHOOK_URL="http://localhost:5678/webhook/solicitud-convalidacion"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "📡 URL del Webhook: $WEBHOOK_URL"
echo "⏰ Timestamp: $TIMESTAMP"
echo ""

# TC1.1 - Caso Válido Completo
echo "🔬 TC1.1 - Caso Válido Completo"
echo "--------------------------------"
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Ana García López",
    "rut": "15.234.567-8", 
    "carrera": "Ingeniería Civil Industrial",
    "asignatura": "Investigación de Operaciones",
    "institucionOrigen": "Pontificia Universidad Católica",
    "documentos": "transcript_ana.pdf",
    "email": "ana.garcia@estudiante.unab.cl"
  }' \
  -w "\n⏱️  Tiempo respuesta: %{time_total}s\n📊 Código HTTP: %{http_code}\n\n"

sleep 2

# TC1.2 - Campo Obligatorio Faltante (sin rut)
echo "🔬 TC1.2 - Campo Obligatorio Faltante (sin rut)"
echo "------------------------------------------------"
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Carlos Mendoza",
    "carrera": "Derecho", 
    "asignatura": "Derecho Civil",
    "institucionOrigen": "Universidad de Valparaíso",
    "documentos": "notas_carlos.pdf"
  }' \
  -w "\n⏱️  Tiempo respuesta: %{time_total}s\n📊 Código HTTP: %{http_code}\n\n"

sleep 2

# TC1.3 - Múltiples Campos Faltantes
echo "🔬 TC1.3 - Múltiples Campos Faltantes"
echo "--------------------------------------"
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Luis Torres",
    "carrera": "Medicina"
  }' \
  -w "\n⏱️  Tiempo respuesta: %{time_total}s\n📊 Código HTTP: %{http_code}\n\n"

sleep 2

# TC5.1 - Caracteres Especiales
echo "🔬 TC5.1 - Caracteres Especiales en Nombres"
echo "--------------------------------------------"
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "José María Fernández-O'\''Connor Ñuñez",
    "rut": "18.765.432-1",
    "carrera": "Administración de Empresas", 
    "asignatura": "Gestión & Liderazgo (Nivel I)",
    "institucionOrigen": "UNAM - México",
    "documentos": "transcript_josé_maría.pdf",
    "email": "jose.maria@estudiante.unab.cl"
  }' \
  -w "\n⏱️  Tiempo respuesta: %{time_total}s\n📊 Código HTTP: %{http_code}\n\n"

sleep 2

# TC2.1 - Caso con email válido para verificar confirmación
echo "🔬 TC2.1 - Caso para Verificar Email de Confirmación"
echo "-----------------------------------------------------"
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "María Elena Rodríguez",
    "rut": "20.111.222-3",
    "carrera": "Psicología",
    "asignatura": "Estadística Aplicada", 
    "institucionOrigen": "Universidad de Santiago",
    "documentos": "certificado_maria.pdf",
    "email": "test.webhook@gmail.com"
  }' \
  -w "\n⏱️  Tiempo respuesta: %{time_total}s\n📊 Código HTTP: %{http_code}\n\n"

echo "✅ PRUEBAS COMPLETADAS"
echo "======================"
echo "🔍 Revisar:"
echo "   • Logs de n8n en terminal"
echo "   • Google Sheets (si configurado)"
echo "   • Emails enviados (si SMTP configurado)"
echo ""
echo "📝 Documentar resultados en HU-01_CASOS_PRUEBA.md"