````markdown
# HU-001: Recepción de Solicitud de Convalidación (MEJORADO)

**Desarrollador:** Lucas Maulén Riquelme  
**Estado:** ✅ Completado y Mejorado  
**Sprint:** 1  
**Versión:** 3.0  
**Fecha:** Octubre 2025

## 📋 Descripción

Sistema automatizado **COMPLETO** para recibir, validar y procesar solicitudes de convalidación de asignaturas mediante formulario web, con validaciones avanzadas (RUT chileno, email, tamaño), almacenamiento en Google Sheets, **subida de archivos a Google Drive**, logs completos y notificación por email.

## 🎯 Objetivos Cumplidos

- ✅ Crear formulario web con validación client-side
- ✅ **NUEVO:** Envío de archivos PDF reales (base64)
- ✅ Implementar webhook en n8n para recepción de datos
- ✅ **NUEVO:** Validar RUT chileno con dígito verificador
- ✅ **NUEVO:** Validar formato de email
- ✅ Validar campos obligatorios, formato PDF y tamaño
- ✅ **NUEVO:** Subir PDFs a Google Drive automáticamente
- ✅ Almacenar solicitudes en Google Sheets con links de Drive
- ✅ **NUEVO:** Registrar logs completos (éxitos y errores)
- ✅ Enviar email de confirmación con link al PDF
- ✅ **NUEVO:** Emails de error detallados
- ✅ Retornar respuestas JSON estructuradas

## 📁 Estructura de Archivos

```
hu001/
├── README.md                               # Este archivo (actualizado)
├── CONFIG.md                               # Configuración completa
├── CONFIG-GMAIL-SMTP.md                    # Guía Gmail SMTP
├── PASOS-GMAIL-SMTP.md                     # Pasos rápidos Gmail
├── formulario-convalidacion-unab.html      # Formulario mejorado
├── certificado-prueba.pdf                  # PDF para pruebas
│
├── workflows/                               # Workflows de n8n
│   ├── HU-001.json                         # Workflow original
│   └── HU-001-MEJORADO.json                # ⭐ Workflow mejorado v3
│
├── docs/                                    # Documentación
│   ├── HU-01_FICHA_TECNICA.md
│   ├── HU-01_CASOS_PRUEBA.md
│   ├── HU-01_RESULTADOS_PRUEBAS.md
│   └── HU-01_RESUMEN_FINAL.md
│
└── tests/                                   # Pruebas
    └── test_hu01.sh                        # Script de tests
```

## 🚀 Guía de Uso Rápida

### 1. Importar Workflow MEJORADO en n8n

```bash
# El workflow mejorado está en:
workflows/HU-001-MEJORADO.json

# En n8n:
# 1. Abrir http://localhost:5678
# 2. Workflows → Import from File
# 3. Seleccionar: workflows/HU-001-MEJORADO.json
# 4. Configurar credenciales (ver paso 2)
# 5. Seleccionar carpeta de Google Drive
# 6. Activar workflow
```

### 2. Configurar Credenciales (IMPORTANTE)

#### A) Google Sheets OAuth2
1. Google Cloud Console → API y servicios
2. Habilitar: Google Sheets API + Google Drive API
3. Crear credenciales OAuth2
4. En n8n: Settings → Credentials → Add Google Sheets OAuth2
5. Pegar Client ID y Secret
6. Autorizar

#### B) Google Drive OAuth2
1. Usa las mismas credenciales de Google Sheets
2. En n8n: Settings → Credentials → Add Google Drive OAuth2
3. Autorizar acceso

#### C) Gmail SMTP
Ver guía completa en: `CONFIG-GMAIL-SMTP.md`

**Resumen:**
1. Activar verificación en 2 pasos en Gmail
2. Crear contraseña de aplicación
3. En n8n nodo Email:
   - Host: smtp.gmail.com
   - Port: 465
   - User: tu-email@gmail.com
   - Password: [contraseña de 16 caracteres]

### 3. Configurar Google Drive en el Workflow

1. Abre el workflow en n8n
2. Busca el nodo **"Drive - Subir PDF"**
3. Click en "Select Folder"
4. Elige tu carpeta: "Convalidaciones UNAB/2025/Octubre"
5. Guarda el workflow

### 4. Actualizar Google Sheets

Agrega estas columnas a tu hoja "Solicitudes":
```
| linkDrive | driveFileId | tamanoMB |
```

### 5. Abrir Formulario

```bash
# Abrir directamente el archivo HTML
# No requiere servidor
```

## 🔬 NUEVAS VALIDACIONES IMPLEMENTADAS

### 1. Validación de RUT Chileno ⭐
```javascript
// Formato aceptado: 12.345.678-9 o 12345678-9
// Valida dígito verificador con algoritmo chileno
// Rango: 7-8 dígitos + verificador (0-9 o K)
```

### 2. Validación de Email ⭐
```javascript
// Formato: usuario@dominio.com
// Longitud máxima: 254 caracteres
// Regex estándar RFC 5322
```

### 3. Validación de Tamaño de Archivo ⭐
```javascript
// Cliente (HTML): Validación antes de enviar
// Servidor (n8n): Validación del base64
// Tamaño máximo: 10 MB
```

### 4. Validación de PDF Mejorada ⭐
```javascript
// Extensión: .pdf
// Tipo MIME: application/pdf
// Doble validación (cliente + servidor)
```

## ⚙️ Configuración del Webhook

**URL:** `http://localhost:5678/webhook/solicitud-convalidacion`  
**Método:** POST  
**Content-Type:** application/json

**Campos esperados (ACTUALIZADO):**
```json
{
  "nombre": "string (requerido)",
  "rut": "string (requerido, formato: 12.345.678-9)",
  "email": "string (opcional, formato válido)",
  "carrera": "string (requerido)",
  "asignatura": "string (requerido)",
  "institucionOrigen": "string (requerido)",
  "documentos": "string (nombre archivo)",
  "file": {
    "filename": "string (requerido)",
    "data": "string (base64, requerido)",
    "mimeType": "string (application/pdf)",
    "size": "number (bytes)"
  }
}
```

## 📊 Google Sheets - Estructura ACTUALIZADA

### Hoja "Solicitudes"
| Columna | Tipo | Descripción | ¿Nuevo? |
|---------|------|-------------|---------|
| id | String | ID único (SOL-{RUT}-{TIMESTAMP}) | |
| fecha | DateTime | Fecha/hora solicitud | |
| estudiante | String | Nombre completo | |
| rut | String | RUT validado | |
| carrera | String | Carrera actual | |
| asignatura | String | Asignatura a convalidar | |
| institucionOrigen | String | Institución origen | |
| documentos | String | Nombre archivo | |
| **linkDrive** | **URL** | **Link al PDF en Drive** | **⭐ NUEVO** |
| **driveFileId** | **String** | **ID del archivo en Drive** | **⭐ NUEVO** |
| **tamanoMB** | **Number** | **Tamaño del archivo en MB** | **⭐ NUEVO** |
| email | Email | Email estudiante | |
| estado | String | Estado: "Recibida" | |

### Hoja "Logs" (MEJORADA)
Ahora registra:
- ✅ Solicitudes exitosas
- ❌ **Errores de validación** (NUEVO)
- ❌ **Errores de PDF** (NUEVO)
- ❌ **Errores de RUT** (NUEVO)

## 🔧 Flujo del Workflow MEJORADO

```
1. [Webhook] Recibe POST con datos + archivo base64
        ↓
2. [Function] Valida campos obligatorios
        ↓
3. [Function] Valida RUT chileno ⭐ NUEVO
        ↓
4. [Function] Valida email ⭐ NUEVO
        ↓
5. [IF] ¿Validación OK?
        ↓ SÍ                           ↓ NO
6. [Function] Valida PDF          →  [Function] Log Error ⭐
        ↓                               ↓
7. [Function] Valida Tamaño ⭐      [DB-Log] Registrar
        ↓                               ↓
8. [IF] ¿PDF OK?                    [Respond] Error 400
        ↓ SÍ              ↓ NO
9. [Drive] Subir PDF ⭐  →  [Email] Error PDF ⭐
        ↓                    ↓
10. [Function] Prep Link  [Function] Log Error PDF ⭐
        ↓                    ↓
11. [Function] Prep Data  [DB-Log] Registrar
        ↓                    ↓
12. [DB-Registro] Guardar [Respond] Error 400 ⭐
        ↓
13. [DB-Log] Registrar éxito
        ↓
14. [Email] Confirmación (con link) ⭐
        ↓
15. [Respond] Success 200 (con link) ⭐
```

## 📧 Emails Mejorados

### Email de Confirmación
```
✅ Incluye:
- Datos de la solicitud
- Nombre del archivo
- Link al documento en Drive ⭐
- Tamaño del archivo ⭐
- Próximos pasos
```

### Email de Error (NUEVO)
```
❌ Incluye:
- Problemas detectados
- Requisitos específicos
- Tamaño máximo
- Instrucciones para reenvío
```

## 🐛 Problemas Comunes y Soluciones

### Error: "RUT inválido"
**Causa:** Formato incorrecto o dígito verificador mal  
**Solución:** Usar formato 12.345.678-9 con dígito correcto

### Error: "Archivo muy grande"
**Causa:** PDF > 10MB  
**Solución:** Comprimir PDF o usar archivo más pequeño

### Error: "Drive - Subir PDF" falla
**Causa:** Carpeta no seleccionada o credenciales  
**Solución:** Configurar carpeta de Drive en el nodo

### No sube a Drive
**Causa:** Credenciales de Google Drive no configuradas  
**Solución:** Agregar credencial Google Drive OAuth2

## 📈 Métricas de Éxito ACTUALIZADAS

- ✅ 100% solicitudes válidas procesadas
- ✅ **100% RUTs validados correctamente** ⭐
- ✅ **100% archivos subidos a Drive** ⭐
- ✅ Tiempo de respuesta < 12 segundos
- ✅ 0% pérdida de datos
- ✅ **Email con link funcional** ⭐
- ✅ **Logs completos de errores** ⭐
- ✅ Todos los criterios de aceptación cumplidos

## 🎯 Mejoras Implementadas (v3.0)

### 🔴 Prioridad ALTA (Completadas)
- ✅ Integración con Google Drive
- ✅ Links de Drive en Google Sheets
- ✅ Respuestas de error para PDF inválido
- ✅ Logs de errores completos

### 🟡 Prioridad MEDIA (Completadas)
- ✅ Validación de RUT chileno
- ✅ Validación de tamaño de archivo
- ✅ Validación de email

### 🟢 Prioridad BAJA (Pendientes)
- ⏳ Verificación de duplicados por RUT
- ⏳ Dashboard de estadísticas
- ⏳ Notificaciones a admin

## 📞 Contacto

**Desarrollador:** Lucas Maulén Riquelme  
**Email:** l.maulnriquelme@uandresbello.edu  
**Proyecto:** Sistema de Convalidaciones UNAB

---
**Última actualización:** 23 de octubre de 2025  
**Versión:** 3.0 - COMPLETO CON GOOGLE DRIVE

````

## 🎯 Objetivos

- ✅ Crear formulario web con validación client-side
- ✅ Implementar webhook en n8n para recepción de datos
- ✅ Validar campos obligatorios y formato PDF
- ✅ Almacenar solicitudes en Google Sheets
- ✅ Registrar logs de operaciones
- ✅ Enviar email de confirmación automático
- ✅ Retornar respuesta JSON al cliente

## 📁 Estructura de Archivos

```
hu001/
├── README.md                               # Este archivo
├── formulario-convalidacion-unab.html     # Formulario web
│
├── workflows/                              # Workflows de n8n
│   └── flow_HU01.json                     # Workflow principal
│
├── docs/                                   # Documentación
│   ├── HU-01_FICHA_TECNICA.md
│   ├── HU-01_CASOS_PRUEBA.md
│   ├── HU-01_RESULTADOS_PRUEBAS.md
│   └── HU-01_RESUMEN_FINAL.md
│
└── tests/                                  # Pruebas
    └── test_hu01.sh                       # Script de tests automatizados
```

## 🚀 Guía de Uso Rápida

### 1. Importar Workflow en n8n

```bash
# El workflow está en:
workflows/flow_HU01.json

# En n8n:
# 1. Abrir http://localhost:5678
# 2. Menú → Import from File
# 3. Seleccionar: workflows/flow_HU01.json
# 4. Configurar credenciales (ver sección Configuración)
# 5. Activar workflow
```

### 2. Configurar Credenciales

#### Google Sheets OAuth2
Ver guía completa: `/n8n/CONFIGURACION_APIS.md`

**Pasos rápidos:**
1. Google Cloud Console → Nuevo Proyecto
2. Habilitar APIs: Google Sheets + Google Drive
3. Crear OAuth2 Client ID
4. Agregar usuario de prueba en OAuth Consent Screen
5. Configurar en n8n con Client ID y Secret
6. Autorizar acceso

#### SMTP Email
**Opción 1 - Ethereal (Testing):**
- URL: https://ethereal.email/create
- Copiar credenciales generadas
- Host: smtp.ethereal.email, Port: 587

**Opción 2 - Gmail (Producción):**
- Habilitar verificación en 2 pasos
- Generar App Password
- Host: smtp.gmail.com, Port: 587

### 3. Levantar Formulario

```bash
# Desde la carpeta hu001
python3 -m http.server 8080

# Acceder a:
# http://localhost:8080/formulario-convalidacion-unab.html
```

### 4. Ejecutar Tests

```bash
# Desde la carpeta hu001
cd tests
chmod +x test_hu01.sh
./test_hu01.sh
```

## 🧪 Casos de Prueba

El script de tests ejecuta:

- **TC1.1:** Solicitud válida completa → HTTP 200
- **TC1.2:** Campo obligatorio faltante → Error validación
- **TC1.3:** Múltiples campos faltantes → Lista de errores
- **TC5.1:** Caracteres especiales → Procesamiento correcto
- **TC2.1:** Email de confirmación → Email enviado

## ⚙️ Configuración del Webhook

**URL:** `http://localhost:5678/webhook/solicitud-convalidacion`  
**Método:** POST  
**Content-Type:** application/json

**Campos esperados:**
```json
{
  "nombre": "string (requerido)",
  "rut": "string (requerido)",
  "email": "string (requerido)",
  "carrera": "string (requerido)",
  "asignatura": "string (requerido)",
  "institucionOrigen": "string (requerido)",
  "documentos": "string (requerido, .pdf)"
}
```

## 📊 Google Sheets - Estructura

### Hoja "Solicitudes" (Sheet ID: 0)
| Columna | Tipo | Descripción |
|---------|------|-------------|
| ID | String | Identificador único (SOL-YYYYMMDD-XXX) |
| Fecha | DateTime | Fecha y hora de solicitud |
| Estudiante | String | Nombre completo |
| RUT | String | RUT del estudiante |
| Carrera | String | Carrera actual |
| Asignatura | String | Asignatura a convalidar |
| InstitucionOrigen | String | Institución de origen |
| Estado | String | Estado inicial: "Pendiente" |

### Hoja "Logs" (Sheet ID: 1)
| Columna | Tipo | Descripción |
|---------|------|-------------|
| Timestamp | DateTime | Fecha/hora del evento |
| ID | String | ID de la solicitud |
| Status | String | success / error |
| Details | String | Detalles del evento |

## 🔧 Flujo del Workflow

```
1. [Webhook] Recibe POST con datos
        ↓
2. [Function] Valida campos obligatorios y PDF
        ↓
3. [IF] ¿Validación OK?
        ↓ SÍ                    ↓ NO
4. [Function] Genera ID    →  [Respond] Error 400
        ↓
5. [Google Sheets] → Solicitudes
        ↓
6. [Google Sheets] → Logs
        ↓
7. [Email] Confirmación
        ↓
8. [Respond] Success 200
```

## 🐛 Problemas Comunes y Soluciones

### Error: "Webhook not registered"
**Causa:** Workflow no está activo  
**Solución:** Activar workflow con el toggle en n8n

### Error: "Unable to sign without access token"
**Causa:** Credencial OAuth2 no autorizada  
**Solución:** Reconectar credencial en n8n

### Error: "Sheet with ID not found"
**Causa:** ID de hoja incorrecto  
**Solución:** Usar ID numérico (0 para primera hoja, 1 para segunda)

### Emails no se ven con formato
**Causa:** Modo texto plano en lugar de Expression  
**Solución:** Activar modo "Expression" en nodo Email

## 📈 Métricas de Éxito

- ✅ 100% solicitudes válidas procesadas
- ✅ Tiempo de respuesta < 8 segundos
- ✅ 0% pérdida de datos
- ✅ Email enviado en < 10 segundos
- ✅ Validación de PDF funcional
- ✅ Todos los criterios de aceptación cumplidos

## 🔄 Próximos Pasos / Mejoras Futuras

- [ ] Implementar upload de archivos PDF binarios a Google Drive
- [ ] Agregar autenticación de estudiantes
- [ ] Dashboard de visualización de solicitudes
- [ ] Notificaciones push en tiempo real
- [ ] Sistema de seguimiento de estados

## 📞 Contacto

**Desarrollador:** Lucas Maulén Riquelme  
**Email:** l.maulnriquelme@uandresbello.edu  
**Proyecto:** Sistema de Convalidaciones UNAB

## 📝 Notas de Desarrollo

- Formulario validado con JavaScript antes de envío
- Backend valida nuevamente por seguridad
- Sistema resiliente a errores (manejo de excepciones)
- Logs detallados para debugging
- Respuestas JSON estandarizadas

---
**Última actualización:** 19 de octubre de 2025
