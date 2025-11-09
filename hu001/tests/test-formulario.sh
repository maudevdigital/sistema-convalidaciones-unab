#!/bin/bash

# Script para probar el formulario HTML con el flujo de n8n

echo "🧪 PRUEBA DEL FORMULARIO HTML - HU-01"
echo "======================================"
echo ""

# Verificar que n8n esté corriendo
if ! docker ps | grep -q "n8n"; then
    echo "❌ Error: n8n no está corriendo"
    echo "   Ejecuta: docker-compose up -d"
    exit 1
fi

echo "✅ n8n está corriendo"
echo ""

# Verificar que el webhook esté activo
echo "🔍 Verificando webhook..."
WEBHOOK_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5678/webhook/solicitud-convalidacion -X POST -H "Content-Type: application/json" -d '{}')

if [ "$WEBHOOK_RESPONSE" = "200" ]; then
    echo "✅ Webhook activo y respondiendo"
else
    echo "⚠️  Webhook responde con código: $WEBHOOK_RESPONSE"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 INSTRUCCIONES DE PRUEBA:"
echo ""
echo "1️⃣  Abriendo formulario en el navegador..."
echo ""

# Iniciar servidor web simple en el puerto 8080
cd /workspaces/Proyecto-n8n/developers/lucas/hu001

echo "🌐 Servidor web iniciado en:"
echo "   👉 http://localhost:8080/formulario-convalidacion-unab.html"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "2️⃣  CASOS DE PRUEBA:"
echo ""
echo "   📌 CP1: Solicitud Válida con PDF"
echo "   ────────────────────────────────"
echo "   - Completa todos los campos"
echo "   - Sube un archivo PDF real"
echo "   - Debe mostrar: ✅ Solicitud recibida correctamente"
echo ""
echo "   📌 CP2: Intento con archivo NO-PDF"
echo "   ─────────────────────────────────"
echo "   - Intenta subir un .jpg o .txt"
echo "   - Debe mostrar: ❌ Solo se aceptan archivos PDF"
echo ""
echo "   📌 CP3: Campos Vacíos"
echo "   ──────────────────────"
echo "   - Deja campos obligatorios vacíos"
echo "   - El formulario debe prevenir el envío"
echo ""
echo "   📌 CP4: Sin Documento"
echo "   ──────────────────────"
echo "   - Completa campos pero no subas archivo"
echo "   - Debe mostrar: ❌ Debe adjuntar un documento PDF"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "3️⃣  Ver logs de n8n en tiempo real:"
echo "   docker-compose logs -f n8n"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "⏹️  Para detener el servidor: Presiona Ctrl+C"
echo ""
echo "🚀 Iniciando servidor..."
echo ""

# Iniciar servidor web con Python
python3 -m http.server 8080
