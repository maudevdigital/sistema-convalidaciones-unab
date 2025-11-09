#!/bin/bash

# 🚀 Script de Setup Rápido para Nuevos Desarrolladores
# Sistema de Convalidaciones UNAB

set -e  # Exit on error

echo "🎓 Sistema de Convalidaciones UNAB - Setup Inicial"
echo "=================================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Función para preguntas
ask() {
    read -p "$1 " response
    echo "$response"
}

# Función para éxito
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Función para info
info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Función para warning
warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Función para error
error() {
    echo -e "${RED}❌ $1${NC}"
}

echo "Este script te ayudará a configurar tu entorno de desarrollo."
echo ""

# 1. Verificar Docker
echo "1️⃣  Verificando Docker..."
if command -v docker &> /dev/null; then
    success "Docker instalado: $(docker --version)"
else
    error "Docker no encontrado. Instala Docker Desktop: https://www.docker.com/products/docker-desktop"
    exit 1
fi

if command -v docker-compose &> /dev/null; then
    success "Docker Compose instalado: $(docker-compose --version)"
else
    error "Docker Compose no encontrado"
    exit 1
fi

# 2. Verificar Python
echo ""
echo "2️⃣  Verificando Python..."
if command -v python3 &> /dev/null; then
    success "Python instalado: $(python3 --version)"
else
    warning "Python3 no encontrado. Se necesita para servidor de formularios."
fi

# 3. Iniciar n8n
echo ""
echo "3️⃣  Iniciando n8n..."
docker-compose up -d

sleep 5

# Verificar que n8n esté corriendo
if curl -s http://localhost:5678/healthz | grep -q "ok"; then
    success "n8n está corriendo en http://localhost:5678"
else
    warning "n8n puede estar iniciando todavía. Espera 30 segundos más."
fi

# 4. Setup del desarrollador
echo ""
echo "4️⃣  Configuración de tu espacio de trabajo"
DEV_NAME=$(ask "¿Cuál es tu nombre (sin espacios, ej: 'lucas', 'maria')?")

if [ -z "$DEV_NAME" ]; then
    error "Nombre no puede estar vacío"
    exit 1
fi

DEV_PATH="developers/${DEV_NAME}"

if [ -d "$DEV_PATH" ]; then
    warning "La carpeta $DEV_PATH ya existe"
else
    mkdir -p "$DEV_PATH"
    success "Carpeta creada: $DEV_PATH"
fi

# 5. Crear primera HU
echo ""
CREATE_HU=$(ask "¿Quieres crear tu primera Historia de Usuario? (s/n)")

if [[ "$CREATE_HU" =~ ^[Ss]$ ]]; then
    HU_NUMBER=$(ask "Número de HU (ej: 001, 002):")
    
    if [ -z "$HU_NUMBER" ]; then
        error "Número de HU no puede estar vacío"
        exit 1
    fi
    
    HU_PATH="${DEV_PATH}/hu${HU_NUMBER}"
    
    # Crear estructura
    mkdir -p "${HU_PATH}"/{workflows,docs,tests}
    
    # Copiar templates
    cp developers/lucas/hu001/README.md "${HU_PATH}/"
    cp developers/lucas/hu001/CONFIG.md "${HU_PATH}/"
    
    # Personalizar README
    sed -i "s/Lucas Maulén Riquelme/${DEV_NAME}/g" "${HU_PATH}/README.md"
    sed -i "s/hu001/hu${HU_NUMBER}/g" "${HU_PATH}/README.md"
    sed -i "s/HU-001/HU-${HU_NUMBER}/g" "${HU_PATH}/README.md"
    
    success "Estructura creada en: ${HU_PATH}"
    
    echo ""
    info "Estructura creada:"
    tree -L 2 "${HU_PATH}" 2>/dev/null || ls -R "${HU_PATH}"
fi

# 6. Resumen final
echo ""
echo "=================================================="
echo "✅ Setup completado!"
echo "=================================================="
echo ""
echo "📚 Próximos pasos:"
echo ""
echo "1. Accede a n8n: http://localhost:5678"
echo "   - Crea tu cuenta en el wizard inicial"
echo "   - Guarda tus credenciales"
echo ""
echo "2. Lee la documentación:"
echo "   - README.md (visión general)"
echo "   - DEVELOPERS.md (guía técnica)"
echo "   - CONTRIBUTING.md (cómo contribuir)"
echo ""
echo "3. Revisa el ejemplo completo:"
echo "   cd developers/lucas/hu001"
echo "   cat README.md"
echo ""
echo "4. Trabaja en tu HU:"
if [ ! -z "$HU_NUMBER" ]; then
    echo "   cd ${HU_PATH}"
    echo "   code README.md  # Actualiza tu documentación"
fi
echo ""
echo "5. Comandos útiles:"
echo "   docker-compose logs -f n8n    # Ver logs de n8n"
echo "   docker-compose restart         # Reiniciar n8n"
echo "   docker-compose down            # Detener n8n"
echo ""
echo "6. Para importar workflows:"
echo "   - En n8n: Menú → Import from File"
echo "   - Selecciona tu archivo .json"
echo ""
echo "=================================================="
echo ""
echo "🆘 ¿Necesitas ayuda?"
echo "   - Lee: DEVELOPERS.md"
echo "   - Contacto: l.maulnriquelme@uandresbello.edu"
echo ""
echo "🚀 ¡Feliz desarrollo!"
echo ""
