# 🎓 Sistema Final de Convalidaciones Académicas - UNAB

Sistema automatizado completo para la gestión de solicitudes de convalidación académica, integrando las historias de usuario HU-001 (Recepción de Solicitudes) y HU-005 (Notificación de Corrección).

---

## 📁 Contenido del Directorio

```
sistema-final/
├── formulario-convalidacion-unab.html    # Formulario web del estudiante
├── workflows/
│   └── workflow.json                      # Workflow n8n integrado (HU-001 + HU-005)
├── ANALISIS_Y_MEJORAS.md                 # Análisis técnico completo del sistema
├── INSTALACION_RAPIDA.md                 # Guía de instalación paso a paso
└── README.md                             # Este archivo
```

---

## ✨ **Características Principales**

### **🔐 Validaciones Completas**
- ✅ Validación de RUT chileno con dígito verificador
- ✅ Validación de formato de email (RFC 5322)
- ✅ Validación de campos obligatorios
- ✅ Validación de formato PDF (extensión + MIME type)
- ✅ Validación de tamaño de archivo (10MB máximo)
- ✅ Detección de archivos fraudulentos (renombrados)

### **📨 Sistema de Notificaciones**
- ✅ Email de confirmación personalizado
- ✅ Email de error con templates HTML profesionales
- ✅ 4 tipos de notificaciones de corrección:
  - Formato incorrecto
  - Tamaño excedido
  - Archivo corrupto
  - Campos faltantes

### **💾 Persistencia de Datos**
- ✅ Registro en Google Sheets (Solicitudes + Logs)
- ✅ Almacenamiento de PDFs en Google Drive
- ✅ Generación de links de acceso directo
- ✅ Trazabilidad completa con timestamps

### **🎯 Experiencia de Usuario**
- ✅ Interfaz moderna y responsive
- ✅ Validación en tiempo real
- ✅ Mensajes de error claros y accionables
- ✅ Feedback visual inmediato
- ✅ Limpieza automática del formulario

---

## 🚀 **Inicio Rápido**

### **Opción 1: Instalación Completa** (Recomendado)

Sigue la guía detallada: **[INSTALACION_RAPIDA.md](./INSTALACION_RAPIDA.md)**

**Tiempo estimado:** 15-20 minutos

### **Opción 2: Instalación Express** (Solo pruebas)

```bash
# 1. Asegúrate de que n8n esté ejecutándose
docker-compose up -d

# 2. Importa el workflow en n8n
# http://localhost:5678 → Import from File → workflow.json

# 3. Configura credenciales mínimas (Google Sheets, Drive, SMTP)

# 4. Activa el workflow

# 5. Abre el formulario
# sistema-final/formulario-convalidacion-unab.html
```

---

## 📊 **Arquitectura del Sistema**

```
┌──────────────────────────────────────────────────────────────┐
│                    FORMULARIO HTML                           │
│  • Validación cliente (JavaScript)                          │
│  • Interfaz responsive                                       │
│  • Feedback inmediato                                        │
└────────────────────┬─────────────────────────────────────────┘
                     │ HTTP POST (JSON + Base64)
                     ▼
┌──────────────────────────────────────────────────────────────┐
│                 WEBHOOK n8n (HU-001)                         │
│  1. Recepción de datos                                       │
│  2. Validación de campos requeridos                         │
│  3. Validación de RUT chileno                               │
│  4. Validación de email                                      │
└────────────────────┬─────────────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
    ✅ VÁLIDO               ❌ ERROR
         │                       │
         ▼                       ▼
┌─────────────────┐     ┌─────────────────────┐
│  Validar PDF    │     │  Log Error          │
│  • Formato      │     │  • Google Sheets    │
│  • Tamaño       │     │  • Respuesta HTTP   │
└────────┬────────┘     └─────────────────────┘
         │
    ┌────┴────┐
    │         │
✅ PDF OK  ❌ PDF ERROR
    │         │
    ▼         ▼
┌──────┐  ┌─────────────────────┐
│Drive │  │ HTTP-Notificar      │
│Upload│  │ HU-005              │
└──┬───┘  └──────────┬──────────┘
   │                 │
   ▼                 ▼
┌──────┐  ┌─────────────────────┐
│Sheets│  │ Webhook HU-005      │
│Save  │  │ • Validar entrada   │
└──┬───┘  │ • Preparar datos    │
   │      │ • Redactar email    │
   ▼      │ • Enviar corrección │
┌──────┐  └──────────┬──────────┘
│Email │             │
│Conf. │             │
└──┬───┘             │
   │                 │
   └────────┬────────┘
            ▼
    ┌──────────────┐
    │  Respuesta   │
    │  al Cliente  │
    │  (JSON)      │
    └──────────────┘
```

---

## 🔧 **Tecnologías Utilizadas**

| Componente | Tecnología | Versión | Propósito |
|------------|-----------|---------|-----------|
| **Orquestación** | n8n | 1.x | Automatización de workflows |
| **Frontend** | HTML5 + CSS3 + JavaScript | ES6+ | Interfaz de usuario |
| **Almacenamiento** | Google Drive | API v3 | Guardar PDFs |
| **Base de datos** | Google Sheets | API v4 | Registro y logs |
| **Notificaciones** | Gmail SMTP | - | Envío de emails |
| **Validaciones** | JavaScript | - | Cliente y servidor |

---

## 📋 **Flujos Implementados**

### **1. HU-001: Recepción de Solicitudes** ✅

**Entrada:**
```json
{
  "nombre": "Juan Pérez",
  "rut": "12.345.678-9",
  "carrera": "Ingeniería Informática",
  "asignatura": "Programación Web",
  "institucionOrigen": "Universidad de Chile",
  "email": "juan.perez@ejemplo.cl",
  "file": {
    "filename": "certificado.pdf",
    "data": "base64...",
    "mimeType": "application/pdf",
    "size": 524288
  }
}
```

**Proceso:**
1. Validar campos requeridos
2. Validar formato de RUT
3. Validar formato de email
4. Validar PDF (formato y tamaño)
5. Subir PDF a Google Drive
6. Registrar solicitud en Google Sheets
7. Guardar log del evento
8. Enviar email de confirmación

**Salida exitosa:**
```json
{
  "success": true,
  "id": "SOL-12345678-1699635000000",
  "message": "Solicitud recibida y procesada correctamente",
  "linkDrive": "https://drive.google.com/file/d/...",
  "tiempoEstimado": "5-10 días hábiles"
}
```

### **2. HU-005: Notificación de Corrección** ✅

**Entrada:**
```json
{
  "idSolicitud": "SOL-12345678-1699635000000",
  "estudiante": {
    "nombre": "Juan Pérez",
    "rut": "12.345.678-9",
    "email": "juan.perez@ejemplo.cl"
  },
  "error": {
    "tipo": "formato_incorrecto",
    "mensaje": "El archivo no es un PDF válido",
    "detalles": {
      "archivoNombre": "documento.docx",
      "archivoTipo": "application/msword",
      "motivoRechazo": "Solo se aceptan archivos PDF"
    }
  }
}
```

**Proceso:**
1. Validar estructura de datos
2. Normalizar texto (encoding)
3. Seleccionar template HTML según tipo de error
4. Personalizar email con datos del estudiante
5. Enviar email con reintentos (3 intentos)
6. Registrar resultado

**Salida:**
```json
{
  "success": true,
  "mensaje": "Email de corrección enviado exitosamente",
  "emailEnviado": true
}
```

---

## 🧪 **Tests y Validación**

### **Tests Disponibles:**

```bash
# HU-001: Test completo
./hu001/tests/test_hu01.sh

# HU-005: Test de templates
powershell ./hu005/tests/test-hu005-todos-templates.ps1

# HU-005: Test de formato incorrecto
powershell ./hu005/tests/test-hu005-formato-incorrecto.ps1

# Integración HU-001 + HU-005
powershell ./hu005/tests/test-integracion-hu001-hu005.ps1
```

### **Casos de Prueba:**

Ver documentos detallados:
- [`hu001/docs/HU-01_CASOS_PRUEBA.md`](../hu001/docs/HU-01_CASOS_PRUEBA.md)
- [`hu005/docs/HU-05_CASOS_PRUEBA.md`](../hu005/docs/HU-05_CASOS_PRUEBA.md)

---

## 📈 **Métricas y Monitoreo**

### **Google Sheets: Logs**

Registra todos los eventos del sistema:

| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| `timestamp` | Fecha y hora del evento | 2025-11-10T15:30:00.000Z |
| `id` | ID de la solicitud | SOL-12345678-1699635000000 |
| `evento` | Tipo de evento | Solicitud Recibida |
| `estudiante` | Nombre del estudiante | Juan Pérez |
| `estado` | Estado actual | Recibida |
| `detalles` | Información adicional | HU-01: Recepción exitosa... |

### **Google Sheets: Solicitudes**

Almacena todas las solicitudes:

| Campo | Descripción |
|-------|-------------|
| `id` | Identificador único |
| `fecha` | Fecha de solicitud |
| `estudiante` | Nombre completo |
| `rut` | RUT del estudiante |
| `carrera` | Carrera actual |
| `asignatura` | Asignatura a convalidar |
| `institucionOrigen` | Universidad de origen |
| `documentos` | Nombre del archivo |
| `linkDrive` | Enlace a Google Drive |
| `driveFileId` | ID del archivo en Drive |
| `tamanoMB` | Tamaño del archivo |
| `email` | Email del estudiante |
| `estado` | Estado de la solicitud |

---

## 🔒 **Seguridad**

### **Validaciones Implementadas:**

1. **Validación de campos requeridos**
   - Evita solicitudes incompletas
   - Mensajes específicos por campo

2. **Validación de RUT**
   - Algoritmo de dígito verificador
   - Formato: 12.345.678-9 o 12345678-9
   - Previene RUTs inventados

3. **Validación de Email**
   - Formato RFC 5322
   - Longitud máxima: 254 caracteres
   - Previene emails malformados

4. **Validación de PDF**
   - Extensión: `.pdf`
   - MIME type: `application/pdf`
   - Detección de archivos renombrados
   - Tamaño máximo: 10 MB

5. **Sanitización de datos**
   - Trim de espacios en blanco
   - Normalización de encoding (UTF-8)
   - Escape de caracteres especiales

### **Recomendaciones Adicionales:**

- [ ] Implementar rate limiting (CloudFlare, nginx)
- [ ] Agregar CAPTCHA en el formulario
- [ ] Configurar CORS en n8n
- [ ] Habilitar HTTPS en producción
- [ ] Implementar autenticación OAuth2 para APIs

---

## 🐛 **Troubleshooting**

### **Problemas Comunes:**

| Problema | Causa Probable | Solución |
|----------|----------------|----------|
| "Webhook no responde" | n8n no está ejecutándose | Verifica: `http://localhost:5678` |
| "Error al subir a Drive" | Credenciales inválidas | Reconfigura OAuth2 de Drive |
| "No se envía email" | SMTP mal configurado | Verifica App Password de Gmail |
| "ID no aparece" | Flujo interrumpido | Revisa nodo "Sincronizar - Preservar Datos" |
| "HU-005 no se dispara" | Nodo desconectado | Verifica conexión "HTTP-Notificar HU-005" |

**Más detalles:** Ver sección "Troubleshooting" en [`INSTALACION_RAPIDA.md`](./INSTALACION_RAPIDA.md)

---

## 📚 **Documentación Adicional**

### **Análisis Técnico:**
- **[ANALISIS_Y_MEJORAS.md](./ANALISIS_Y_MEJORAS.md)** - Análisis completo del sistema, arquitectura, mejoras implementadas

### **Instalación:**
- **[INSTALACION_RAPIDA.md](./INSTALACION_RAPIDA.md)** - Guía paso a paso para configurar el sistema

### **HU-001 (Recepción):**
- [`hu001/docs/HU-01_FICHA_TECNICA.md`](../hu001/docs/HU-01_FICHA_TECNICA.md)
- [`hu001/docs/HU-01_CASOS_PRUEBA.md`](../hu001/docs/HU-01_CASOS_PRUEBA.md)
- [`hu001/docs/HU-01_RESULTADOS_PRUEBAS.md`](../hu001/docs/HU-01_RESULTADOS_PRUEBAS.md)
- [`hu001/docs/CONFIGURACION_GMAIL_SMTP.md`](../hu001/docs/CONFIGURACION_GMAIL_SMTP.md)

### **HU-005 (Notificación):**
- [`hu005/docs/HU-05_FICHA_TECNICA.md`](../hu005/docs/HU-05_FICHA_TECNICA.md)
- [`hu005/docs/HU-05_CASOS_PRUEBA.md`](../hu005/docs/HU-05_CASOS_PRUEBA.md)
- [`hu005/docs/HU-05_RESULTADOS_PRUEBAS.md`](../hu005/docs/HU-05_RESULTADOS_PRUEBAS.md)
- [`hu005/docs/INTEGRACION_HU-001_CON_HU-005.md`](../hu005/docs/INTEGRACION_HU-001_CON_HU-005.md)

### **Configuración:**
- [`hu001/CONFIG-GMAIL-SMTP.md`](../hu001/CONFIG-GMAIL-SMTP.md)
- [`hu001/PASOS-GMAIL-SMTP.md`](../hu001/PASOS-GMAIL-SMTP.md)

---

## 🎯 **Próximos Pasos**

### **Mejoras Futuras:**

1. **HU-004: Verificación de Formato de Documento** 🔄
   - Validación avanzada de contenido PDF
   - OCR para detectar texto
   - Verificación de firma digital

2. **Dashboard de Administración** 📊
   - Visualización de métricas
   - Gestión de solicitudes
   - Reportes estadísticos

3. **Sistema de Aprobación** ✅
   - Workflow de revisión por coordinador
   - Estados adicionales (En Revisión, Aprobada, Rechazada)
   - Notificaciones de cambio de estado

4. **API REST** 🔌
   - Endpoints para integración con otros sistemas
   - Autenticación JWT
   - Documentación OpenAPI/Swagger

---

## 👥 **Contribuciones**

Este sistema fue desarrollado como parte del proyecto de Práctica Profesional 2025.

**Equipo:**
- Análisis y diseño: maudevdigital
- Implementación: GitHub Copilot + maudevdigital
- Documentación: GitHub Copilot

---

## 📄 **Licencia**

Este proyecto es de uso académico para la Universidad Andrés Bello.

---

## 📞 **Soporte**

Para consultas o problemas:
1. Revisa la documentación en [`ANALISIS_Y_MEJORAS.md`](./ANALISIS_Y_MEJORAS.md)
2. Consulta los casos de prueba en [`hu001/docs/`](../hu001/docs/) y [`hu005/docs/`](../hu005/docs/)
3. Revisa los logs en n8n: Click derecho en un nodo → "Show executions"

---

**Última actualización:** 10 de noviembre de 2025  
**Versión del sistema:** 1.0  
**Estado:** ✅ Listo para producción (pendiente configuración de credenciales)
