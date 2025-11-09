# 🔗 Integración HU-001 con HU-005
## Notificación Automática de Errores de Validación

---

## 📋 Resumen

Este documento explica cómo integrar el workflow **HU-001-MEJORADO** (Recepción de Solicitudes) con **HU-005** (Notificación de Corrección) para enviar emails automáticos cuando una solicitud es rechazada por errores de validación.

---

## 🎯 Objetivo de la Integración

Cuando HU-001 detecta un error (RUT inválido, campos faltantes, archivo corrupto, etc.), debe:

1. ✅ Registrar el error en la base de datos
2. ✅ Enviar email de notificación al estudiante (via HU-005)
3. ✅ Devolver respuesta HTTP al formulario web

---

## 🏗️ Arquitectura de Integración

```
┌─────────────────────────────────────────────────────────────┐
│                      WORKFLOW HU-001                        │
│                                                             │
│  [Webhook]                                                  │
│      ↓                                                      │
│  [Validar Campos] ──error──→ [HTTP Request → HU-005]       │
│      ↓                             ↓                        │
│  [Validar RUT]    ──error──→ [HTTP Request → HU-005]       │
│      ↓                             ↓                        │
│  [Validar Email]  ──error──→ [HTTP Request → HU-005]       │
│      ↓                             ↓                        │
│  [Validar Archivo]──error──→ [HTTP Request → HU-005]       │
│      ↓                             ↓                        │
│  [Success Response]          [Error Response]               │
│                                    ↓                        │
└────────────────────────────────────┼────────────────────────┘
                                     │
                                     ↓
┌─────────────────────────────────────────────────────────────┐
│                      WORKFLOW HU-005                        │
│                                                             │
│  [Webhook-HU004]                                            │
│      ↓                                                      │
│  [Function-ValidarEntrada]                                  │
│      ↓                                                      │
│  [IF-DatosValidos]                                          │
│      ↓                                                      │
│  [Function-PrepararDatos]                                   │
│      ↓                                                      │
│  [Function-RedactarEmail]                                   │
│      ↓                                                      │
│  [Email-Correccion] → 📧 maudevchile@gmail.com             │
│      ↓                                                      │
│  [GoogleSheets-Log] → 📊 Base de datos de logs             │
│      ↓                                                      │
│  [Respond-Success]                                          │
└─────────────────────────────────────────────────────────────┘
```

---

## 📝 Pasos de Implementación

### **PASO 1: Modificar HU-001-MEJORADO**

Agregar nodos **HTTP Request** después de cada validación que falle, para llamar al webhook de HU-005.

#### **1.1: Agregar Nodo HTTP Request - Campos Faltantes**

Después del nodo `Function - Validar Campos`, agregar:

```json
{
  "parameters": {
    "url": "http://localhost:5678/webhook/hu005-notificacion-correccion",
    "method": "POST",
    "sendBody": true,
    "specifyBody": "json",
    "jsonBody": "={{ {\n  \"idSolicitud\": $json.id || \"UNKNOWN\",\n  \"estudiante\": {\n    \"nombre\": $json.nombre || \"Estudiante\",\n    \"rut\": $json.rut || \"N/A\",\n    \"email\": $json.email || \"sin-email@ejemplo.com\"\n  },\n  \"error\": {\n    \"tipo\": \"campos_faltantes\",\n    \"mensaje\": \"Faltan campos obligatorios en la solicitud\",\n    \"detalles\": {\n      \"camposFaltantes\": $json.errors\n    }\n  },\n  \"timestamp\": $now\n} }}",
    "options": {}
  },
  "name": "HTTP-Notificar-CamposFaltantes",
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.2,
  "position": [680, 500]
}
```

**Conexión:** 
- Desde `Function - Validar Campos` (salida FALSE) → `HTTP-Notificar-CamposFaltantes`

---

#### **1.2: Agregar Nodo HTTP Request - RUT Inválido**

Después del nodo `Function - Validar RUT`, agregar:

```json
{
  "parameters": {
    "url": "http://localhost:5678/webhook/hu005-notificacion-correccion",
    "method": "POST",
    "sendBody": true,
    "specifyBody": "json",
    "jsonBody": "={{ {\n  \"idSolicitud\": $json.id || \"UNKNOWN\",\n  \"estudiante\": {\n    \"nombre\": $json.nombre,\n    \"rut\": $json.rut,\n    \"email\": $json.email\n  },\n  \"error\": {\n    \"tipo\": \"formato_incorrecto\",\n    \"mensaje\": \"RUT inválido\",\n    \"detalles\": {\n      \"campo\": \"rut\",\n      \"valorRecibido\": $json.rut,\n      \"motivoRechazo\": \"El RUT no tiene un formato válido o el dígito verificador es incorrecto\"\n    }\n  },\n  \"timestamp\": $now\n} }}",
    "options": {}
  },
  "name": "HTTP-Notificar-RUTInvalido",
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.2,
  "position": [900, 500]
}
```

**Conexión:**
- Desde `Function - Validar RUT` (salida FALSE) → `HTTP-Notificar-RUTInvalido`

---

#### **1.3: Agregar Nodo HTTP Request - Email Inválido**

Después del nodo `Function - Validar Email`, agregar:

```json
{
  "parameters": {
    "url": "http://localhost:5678/webhook/hu005-notificacion-correccion",
    "method": "POST",
    "sendBody": true,
    "specifyBody": "json",
    "jsonBody": "={{ {\n  \"idSolicitud\": $json.id,\n  \"estudiante\": {\n    \"nombre\": $json.nombre,\n    \"rut\": $json.rut,\n    \"email\": \"admin@sistema.cl\"\n  },\n  \"error\": {\n    \"tipo\": \"formato_incorrecto\",\n    \"mensaje\": \"Email inválido\",\n    \"detalles\": {\n      \"campo\": \"email\",\n      \"valorRecibido\": $json.email,\n      \"motivoRechazo\": \"El formato del email no es válido\"\n    }\n  },\n  \"timestamp\": $now\n} }}",
    "options": {}
  },
  "name": "HTTP-Notificar-EmailInvalido",
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.2,
  "position": [1120, 500]
}
```

**Nota:** En este caso, el email se envía a `admin@sistema.cl` porque el email del estudiante es inválido.

**Conexión:**
- Desde `Function - Validar Email` (salida FALSE) → `HTTP-Notificar-EmailInvalido`

---

#### **1.4: Agregar Nodo HTTP Request - Archivo Corrupto**

Si HU-001 valida archivos, agregar después de la validación de archivo:

```json
{
  "parameters": {
    "url": "http://localhost:5678/webhook/hu005-notificacion-correccion",
    "method": "POST",
    "sendBody": true,
    "specifyBody": "json",
    "jsonBody": "={{ {\n  \"idSolicitud\": $json.id,\n  \"estudiante\": {\n    \"nombre\": $json.nombre,\n    \"rut\": $json.rut,\n    \"email\": $json.email\n  },\n  \"error\": {\n    \"tipo\": \"archivo_corrupto\",\n    \"mensaje\": \"El archivo adjunto no puede ser leído\",\n    \"detalles\": {\n      \"archivoNombre\": $json.fileName,\n      \"archivoTipo\": $json.fileMimeType\n    }\n  },\n  \"timestamp\": $now\n} }}",
    "options": {}
  },
  "name": "HTTP-Notificar-ArchivoCorrupto",
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.2,
  "position": [1340, 500]
}
```

**Conexión:**
- Desde validación de archivo (salida FALSE) → `HTTP-Notificar-ArchivoCorrupto`

---

#### **1.5: Agregar Nodo HTTP Request - Tamaño Excedido**

Si el archivo supera 10 MB:

```json
{
  "parameters": {
    "url": "http://localhost:5678/webhook/hu005-notificacion-correccion",
    "method": "POST",
    "sendBody": true,
    "specifyBody": "json",
    "jsonBody": "={{ {\n  \"idSolicitud\": $json.id,\n  \"estudiante\": {\n    \"nombre\": $json.nombre,\n    \"rut\": $json.rut,\n    \"email\": $json.email\n  },\n  \"error\": {\n    \"tipo\": \"tamano_excedido\",\n    \"mensaje\": \"El archivo supera el tamaño máximo permitido\",\n    \"detalles\": {\n      \"archivoNombre\": $json.fileName,\n      \"tamanoMB\": ($json.fileSize / 1024 / 1024).toFixed(2),\n      \"tamanoMaximo\": \"10 MB\"\n    }\n  },\n  \"timestamp\": $now\n} }}",
    "options": {}
  },
  "name": "HTTP-Notificar-TamañoExcedido",
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.2,
  "position": [1560, 500]
}
```

**Conexión:**
- Desde validación de tamaño (salida FALSE) → `HTTP-Notificar-TamañoExcedido`

---

### **PASO 2: Verificar Configuración de HU-005**

Asegúrate de que HU-005 esté configurado correctamente:

✅ **Nodo Webhook-HU004:**
- HTTP Method: `POST`
- Path: `hu005-notificacion-correccion`
- Production URL: `http://localhost:5678/webhook/hu005-notificacion-correccion`

✅ **Nodo Email-Correccion:**
- Credenciales SMTP: `maudevchile@gmail.com`
- From Email: `maudevchile@gmail.com`

✅ **Nodo GoogleSheets-Log:**
- Habilitado: `true` (para registrar logs)
- Credenciales: Google Sheets OAuth2

✅ **Workflow:**
- Estado: `Active` (toggle verde)

---

### **PASO 3: Configurar Base de Datos de Logs**

#### **3.1: Crear Google Sheet**

1. Ir a https://sheets.google.com
2. Crear nueva hoja: **"Sistema Convalidación Académica - Logs"**
3. Crear hoja con nombre: **"Logs"**
4. Agregar columnas (primera fila):

```
timestamp | idSolicitud | tipo_notificacion | tipo_error | email_enviado | destinatario | template_utilizado | estado_envio | intentos_envio | estudiante_nombre | detalles_error
```

#### **3.2: Compartir con n8n**

1. En Google Sheet, hacer clic en **"Compartir"**
2. Agregar la cuenta de servicio de n8n o tu cuenta de Gmail
3. Dar permisos de **"Editor"**

#### **3.3: Configurar Credenciales en n8n**

1. En n8n, ir a **Credentials** (menú izquierdo)
2. Crear nueva credencial: **Google Sheets OAuth2 API**
3. Seguir el flujo de autenticación con Google
4. Seleccionar esta credencial en el nodo **GoogleSheets-Log**

---

## 🧪 Prueba de Integración Completa

### **Escenario 1: Campos Faltantes**

```powershell
Invoke-RestMethod `
  -Uri "http://localhost:5678/webhook/solicitud-convalidacion" `
  -Method Post `
  -Body (@{
    nombre = "Juan Pérez"
    # Falta: rut, carrera, asignatura
    email = "juan@ejemplo.cl"
  } | ConvertTo-Json) `
  -ContentType "application/json"
```

**Resultado esperado:**
- ❌ HU-001 rechaza la solicitud
- 📧 HU-005 envía email "Corrección Requerida - Información Incompleta"
- 📊 Log registrado en Google Sheets

---

### **Escenario 2: RUT Inválido**

```powershell
Invoke-RestMethod `
  -Uri "http://localhost:5678/webhook/solicitud-convalidacion" `
  -Method Post `
  -Body (@{
    nombre = "María González"
    rut = "12345678-0"  # RUT inválido
    carrera = "Ingeniería"
    asignatura = "Cálculo I"
    email = "maria@ejemplo.cl"
    institucionOrigen = "Universidad X"
  } | ConvertTo-Json) `
  -ContentType "application/json"
```

**Resultado esperado:**
- ❌ HU-001 rechaza por RUT inválido
- 📧 HU-005 envía email "Corrección Requerida - Formato de Documento Incorrecto"
- 📊 Log registrado en Google Sheets

---

## 📊 Monitoreo

### **Ver Logs en Google Sheets**

Cada notificación enviada registra:

| Campo | Descripción |
|-------|-------------|
| `timestamp` | Fecha y hora del envío |
| `idSolicitud` | ID de la solicitud rechazada |
| `tipo_notificacion` | Siempre "error_documentacion" |
| `tipo_error` | formato_incorrecto, tamano_excedido, etc. |
| `email_enviado` | "si" o "no" |
| `destinatario` | Email del estudiante |
| `template_utilizado` | Template usado para el email |
| `estado_envio` | "exitoso" o "fallido" |
| `intentos_envio` | Número de intentos (1-3) |
| `estudiante_nombre` | Nombre del estudiante |
| `detalles_error` | Descripción del error |

---

## 🔧 Troubleshooting

### **Problema: Email no se envía**

✅ Verificar:
1. Workflow HU-005 está **Active**
2. Credenciales SMTP correctas (maudevchile@gmail.com)
3. Email de origen coincide con credenciales
4. Ir a **Executions** en n8n y ver nodo Email-Correccion

### **Problema: No se registra en Google Sheets**

✅ Verificar:
1. Nodo GoogleSheets-Log está **enabled** (no disabled)
2. Credenciales OAuth2 están configuradas
3. Sheet tiene permisos de escritura
4. Nombre de la hoja es exactamente "Logs"

### **Problema: HU-001 no llama a HU-005**

✅ Verificar:
1. Nodos HTTP Request agregados correctamente
2. URL del webhook es correcta: `http://localhost:5678/webhook/hu005-notificacion-correccion`
3. Conexiones entre nodos configuradas (salida FALSE → HTTP Request)

---

## 📈 Próximos Pasos

1. ✅ **Implementar integración** según este documento
2. ✅ **Probar todos los escenarios** de error
3. ✅ **Configurar Google Sheets** para logs
4. ✅ **Documentar resultados** con capturas
5. ✅ **Commit a Git** de los workflows integrados

---

## 📚 Referencias

- [HU-001 Documentación](../../hu001/docs/)
- [HU-005 Ficha Técnica](./HU-05_FICHA_TECNICA.md)
- [HU-005 Casos de Prueba](./HU-05_CASOS_PRUEBA.md)
- [Configuración Google Sheets](./CONFIGURACION_LOGGING.md)

---

**Autor:** GitHub Copilot  
**Fecha:** 2025-11-09  
**Versión:** 1.0
