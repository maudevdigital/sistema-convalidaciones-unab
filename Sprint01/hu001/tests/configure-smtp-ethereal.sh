#!/bin/bash

# Script para configurar SMTP con Ethereal en n8n
# Este script proporciona las instrucciones paso a paso

clear
echo "═══════════════════════════════════════════════════════════"
echo "  📧 Configuración de Ethereal SMTP para n8n"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Leer credenciales del archivo JSON
if [ -f "ethereal-credentials.json" ]; then
    USER=$(grep -o '"user": "[^"]*"' ethereal-credentials.json | cut -d'"' -f4)
    PASS=$(grep -o '"password": "[^"]*"' ethereal-credentials.json | cut -d'"' -f4)
    HOST=$(grep -o '"host": "[^"]*"' ethereal-credentials.json | head -1 | cut -d'"' -f4)
    PORT=$(grep -o '"port": [0-9]*' ethereal-credentials.json | head -1 | cut -d' ' -f2)
else
    echo "❌ Error: No se encuentra ethereal-credentials.json"
    exit 1
fi

echo "✅ Credenciales de Ethereal cargadas:"
echo ""
echo "   Usuario:    $USER"
echo "   Contraseña: $PASS"
echo "   Host SMTP:  $HOST"
echo "   Puerto:     $PORT"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "📋 PASOS PARA CONFIGURAR EN N8N:"
echo ""
echo "1️⃣  Accede a n8n:"
echo "   👉 http://localhost:5678"
echo ""
echo "2️⃣  Ve a Credentials:"
echo "   • Click en tu avatar (esquina superior derecha)"
echo "   • Selecciona 'Credentials'"
echo "   • Click en 'Add Credential'"
echo ""
echo "3️⃣  Selecciona tipo SMTP:"
echo "   • Busca 'SMTP'"
echo "   • Click en 'SMTP'"
echo ""
echo "4️⃣  Ingresa estos datos:"
echo ""
echo "   ┌─────────────────────────────────────────────────────┐"
echo "   │ Credential Name:  Ethereal SMTP Testing            │"
echo "   │ User:             $USER"
echo "   │ Password:         $PASS"
echo "   │ Host:             $HOST"
echo "   │ Port:             $PORT"
echo "   │ SSL/TLS:          ☐ (DESMARCAR - NO activar)       │"
echo "   └─────────────────────────────────────────────────────┘"
echo ""
echo "5️⃣  Guarda y prueba la conexión"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "🧪 PROBAR EL ENVÍO DE EMAILS:"
echo ""
echo "Una vez configurado, ejecuta:"
echo ""
echo "   ./test_hu01.sh"
echo ""
echo "Luego verifica los emails en:"
echo "   👉 https://ethereal.email/login"
echo ""
echo "   Credenciales de login:"
echo "   Email:    $USER"
echo "   Password: $PASS"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "📚 Para más detalles, consulta: CONFIGURACION_ETHEREAL.md"
echo ""

# Preguntar si quiere abrir n8n
read -p "¿Deseas abrir n8n en el navegador ahora? (s/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[SsYy]$ ]]; then
    echo "🚀 Abriendo n8n..."
    if command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:5678" 2>/dev/null
    elif [ -n "$BROWSER" ]; then
        "$BROWSER" "http://localhost:5678" 2>/dev/null
    else
        echo "Por favor, abre manualmente: http://localhost:5678"
    fi
fi

echo ""
echo "✅ Configuración lista para usar!"
echo ""
