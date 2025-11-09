#!/bin/bash

# Script de prueba para HU-001 con verificación
echo "🧪 Prueba de Workflow HU-001"
echo "============================"
echo ""

WEBHOOK_URL="http://localhost:5678/webhook/solicitud-convalidacion"

# Test 1: Solicitud válida completa
echo "📝 Test 1: Solicitud válida completa"
echo "------------------------------------"
RESPONSE=$(curl -s -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Test Usuario Válido",
    "rut": "12.345.678-9",
    "email": "test.valido@unab.cl",
    "carrera": "Ingeniería Comercial",
    "asignatura": "Matemáticas Financieras",
    "institucionOrigen": "Universidad de Chile",
    "documentos": "certificado_test.pdf"
  }')

echo "Respuesta: $RESPONSE"
echo ""

# Esperar un poco para que el workflow termine
echo "⏳ Esperando 5 segundos para que el workflow procese..."
sleep 5
echo ""

# Instrucciones de verificación manual
echo "✅ VERIFICACIÓN MANUAL REQUERIDA:"
echo "================================="
echo ""
echo "1. 📊 Verificar Google Sheets:"
echo "   - Abre tu spreadsheet de Google Sheets"
echo "   - Hoja 'Solicitudes': ¿Aparece 'Test Usuario Válido'?"
echo "   - Hoja 'Logs': ¿Hay un registro del evento?"
echo ""
echo "2. 📧 Verificar Email:"
echo "   - Si usas Ethereal: https://ethereal.email/messages"
echo "   - Si usas Gmail: Revisa tu bandeja de entrada"
echo "   - ¿Llegó email a 'test.valido@unab.cl'?"
echo ""
echo "3. 🔍 Ver ejecuciones en n8n:"
echo "   - Abre: http://localhost:5678"
echo "   - Ve a: Executions (menú izquierdo)"
echo "   - ¿Ves ejecuciones recientes exitosas?"
echo ""
echo "4. 🐛 Si no funciona, revisar:"
echo "   - Credenciales de Google Sheets configuradas y autorizadas"
echo "   - Credenciales SMTP configuradas"
echo "   - Workflow está ACTIVO (toggle en ON)"
echo "   - Sheet ID correcto en los nodos Google Sheets"
echo "   - Nodo Webhook en modo 'When Last Node Finishes'"
echo ""
echo "📋 Datos enviados en la prueba:"
echo "   Nombre: Test Usuario Válido"
echo "   RUT: 12.345.678-9"
echo "   Email: test.valido@unab.cl"
echo "   Carrera: Ingeniería Comercial"
echo ""
echo "🔗 Enlaces útiles:"
echo "   n8n: http://localhost:5678"
echo "   Ethereal (si configurado): https://ethereal.email/messages"
echo ""
