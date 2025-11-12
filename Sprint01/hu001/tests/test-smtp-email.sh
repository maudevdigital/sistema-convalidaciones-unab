#!/bin/bash

# Script para probar el envío de email después de configurar SMTP
# Envía una solicitud de prueba y verifica el email

echo "📧 Prueba de Envío de Email con Ethereal"
echo "=========================================="
echo ""

# Cargar credenciales
if [ -f "ethereal-credentials.json" ]; then
    ETHEREAL_USER=$(grep -o '"user": "[^"]*"' ethereal-credentials.json | cut -d'"' -f4)
    ETHEREAL_PASS=$(grep -o '"password": "[^"]*"' ethereal-credentials.json | cut -d'"' -f4)
else
    echo "❌ Error: No se encuentra ethereal-credentials.json"
    exit 1
fi

WEBHOOK_URL="http://localhost:5678/webhook/solicitud-convalidacion"

echo "🚀 Enviando solicitud de prueba..."
echo ""

RESPONSE=$(curl -s -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Estudiante de Prueba - Email Test",
    "rut": "11.111.111-1",
    "carrera": "Ingeniería de Pruebas",
    "asignatura": "Testing Automatizado 101",
    "institucionOrigen": "Universidad de Testing",
    "documentos": "prueba_email.pdf",
    "email": "test.estudiante@ejemplo.com"
  }' \
  -w "\nHTTP_CODE:%{http_code}")

HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE" | cut -d':' -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE")

echo "📊 Respuesta del Webhook:"
echo "   HTTP Code: $HTTP_CODE"
echo "   Body: $BODY"
echo ""

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Solicitud enviada exitosamente!"
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "📬 VERIFICA EL EMAIL EN ETHEREAL:"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "1. Abre en tu navegador:"
    echo "   👉 https://ethereal.email/login"
    echo ""
    echo "2. Ingresa estas credenciales:"
    echo "   Email:    $ETHEREAL_USER"
    echo "   Password: $ETHEREAL_PASS"
    echo ""
    echo "3. Busca el email enviado a:"
    echo "   📧 test.estudiante@ejemplo.com"
    echo ""
    echo "4. Deberías ver un email con:"
    echo "   Asunto: Confirmación de Recepción - Solicitud [ID]"
    echo "   De:     sistema@universidad.edu"
    echo "   Para:   test.estudiante@ejemplo.com"
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo ""
    
    # Esperar un momento para que se procese
    echo "⏳ Esperando 3 segundos para que se procese el email..."
    sleep 3
    
    echo ""
    echo "🔍 Revisa también los logs de n8n:"
    echo "   docker-compose logs --tail=50 n8n"
    echo ""
else
    echo "❌ Error: HTTP $HTTP_CODE"
    echo ""
    echo "Verifica que:"
    echo "• n8n esté corriendo (docker ps)"
    echo "• El workflow esté activo en n8n"
    echo "• Las credenciales SMTP estén configuradas"
    echo ""
fi

echo "✅ Prueba completada"
echo ""
