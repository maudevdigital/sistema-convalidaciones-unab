# HU-05: Diseño de Workflow n8n - Notificación de Corrección

## 📊 Diagrama de Flujo

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    HU-004: Validación Documentos                        │
│                     (Punto de Integración)                              │
└────────────────────────────────┬────────────────────────────────────────┘
                                 │
                                 │ (Si error detectado)
                                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  [1] WEBHOOK / IF-ValidacionDoc (desde HU-004)                          │
│  ─────────────────────────────────────────────────────────────────────  │
│  Recibe: { idSolicitud, estudiante, error, timestamp }                  │
│  Valida: Todos los campos requeridos presentes                          │
└────────────────────────────────┬────────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  [2] Function-ValidarEntrada                                            │
│  ─────────────────────────────────────────────────────────────────────  │
│  • Verifica estructura JSON                                             │
│  • Valida email estudiante no vacío                                     │
│  • Confirma tipo error válido                                           │
│  • Extrae datos necesarios                                              │
└────────────────────────────────┬────────────────────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
              (válido)                  (inválido)
                    │                         │
                    ▼                         ▼
┌─────────────────────────────┐   ┌──────────────────────────┐
│ [3] Function-PrepararDatos  │   │ [ERROR] Respond-Error    │
│ ───────────────────────────│   │ ────────────────────────│
│ Estructura datos para:      │   │ HTTP 400 - Bad Request   │
│ • Selección template        │   │ Motivo: datos inválidos  │
│ • Reemplazo variables       │   └──────────────────────────┘
│ • Logging                   │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  [4] Function-SeleccionarTemplate                                       │
│  ─────────────────────────────────────────────────────────────────────  │
│  Switch (error.tipo):                                                   │
│    case "formato_incorrecto"  → template_1                              │
│    case "tamano_excedido"     → template_2                              │
│    case "archivo_corrupto"    → template_3                              │
│    case "campos_faltantes"    → template_4                              │
│    default                    → template_generico                       │
└────────────────────────────────┬────────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  [5] Function-RedactarEmail                                             │
│  ─────────────────────────────────────────────────────────────────────  │
│  Reemplaza variables:                                                   │
│    [NOMBRE_ESTUDIANTE]  → estudiante.nombre                             │
│    [ID_SOLICITUD]       → idSolicitud                                   │
│    [NOMBRE_ARCHIVO]     → error.detalles.archivoNombre                  │
│    [TIPO_ARCHIVO]       → error.detalles.archivoTipo                    │
│    [TAMANO_MB]          → error.detalles.tamanoMB                       │
│    [MOTIVO_RECHAZO]     → error.detalles.motivoRechazo                  │
│    [LINK_REENVIO]       → URL formulario + idSolicitud                  │
└────────────────────────────────┬────────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  [6] Email-Correccion (SMTP)                                            │
│  ─────────────────────────────────────────────────────────────────────  │
│  Config:                                                                │
│    To: estudiante.email                                                 │
│    From: convalidaciones@unab.cl                                        │
│    Subject: [asunto desde template]                                     │
│    Body: [cuerpo generado en paso 5]                                    │
│    Timeout: 30 segundos                                                 │
│    Reintentos: 3 (intervalo 30s)                                        │
└────────────────────────────────┬────────────────────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
              (éxito)                   (falla SMTP)
                    │                         │
                    ▼                         ▼
┌─────────────────────────────┐   ┌──────────────────────────┐
│ [7] Function-PrepararLog    │   │ [ERROR] Function-LogFallo│
│ ───────────────────────────│   │ ────────────────────────│
│ Genera objeto log:          │   │ Registra error SMTP      │
│ • timestamp                 │   │ Marca: pendiente_reenvio │
│ • idSolicitud               │   │ Intenta reintentos       │
│ • tipo_notificacion         │   └────────┬─────────────────┘
│ • email_enviado: "si"       │            │
│ • template_utilizado        │            │
│ • destinatario              │            │
│ • estado_envio: "exitoso"   │            │
└──────────────┬──────────────┘            │
               │                            │
               └────────────┬───────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  [8] GoogleSheets-InsertRow (Hoja "Logs")                               │
│  ─────────────────────────────────────────────────────────────────────  │
│  Inserta fila con datos del log                                         │
│  Columnas: timestamp, idSolicitud, tipo_notificacion, tipo_error,       │
│           email_enviado, destinatario, template, estado, intentos       │
└────────────────────────────────┬────────────────────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
            (log exitoso)            (log falla - no crítico)
                    │                         │
                    ▼                         ▼
┌─────────────────────────────┐   ┌──────────────────────────┐
│ [9] Respond-Success         │   │ [WARN] Respond-Partial   │
│ ───────────────────────────│   │ ────────────────────────│
│ HTTP 200 OK                 │   │ HTTP 206 Partial Success │
│ JSON:                       │   │ Email enviado pero log   │
│ {                           │   │ falló (advertencia)      │
│   "success": true,          │   └──────────────────────────┘
│   "emailEnviado": true,     │
│   "logRegistrado": true,    │
│   "timestamp": "...",       │
│   ...                       │
│ }                           │
└─────────────────────────────┘
```

---

## 🔧 Configuración de Nodos n8n

### **[1] IF-ValidacionDoc (Punto de Conexión HU-004)**

**Tipo:** Switch / IF Node  
**Propósito:** Recibir datos desde HU-004 cuando se detecta error

**Configuración:**
```javascript
// Condición: Si HU-004 detectó error
if ($node["HU-004-ValidacionDoc"].json.hasError === true) {
  return [0]; // Ruta error → HU-005
} else {
  return [1]; // Ruta éxito → continuar HU-004
}
```

**Outputs:**
- Output 0: Error detectado → activar HU-005
- Output 1: Sin error → flujo normal HU-004

---

### **[2] Function-ValidarEntrada**

**Tipo:** Function Node  
**Lenguaje:** JavaScript

**Código:**
```javascript
// Validar estructura de datos recibidos
const data = $input.all()[0].json;

// Validaciones
const validations = {
  idSolicitud: !!data.idSolicitud,
  estudianteNombre: !!data.estudiante?.nombre,
  estudianteEmail: !!data.estudiante?.email && data.estudiante.email.includes('@'),
  errorTipo: !!data.error?.tipo,
  errorMensaje: !!data.error?.mensaje
};

// Verificar todas las validaciones
const allValid = Object.values(validations).every(v => v === true);

if (!allValid) {
  // Retornar error de validación
  return {
    json: {
      error: true,
      validations: validations,
      message: "Datos de entrada inválidos",
      received: data
    }
  };
}

// Datos válidos, continuar
return {
  json: {
    valid: true,
    data: data
  }
};
```

---

### **[3] Function-PrepararDatos**

**Tipo:** Function Node

**Código:**
```javascript
const input = $input.all()[0].json.data;

// Preparar datos estructurados para siguientes nodos
return {
  json: {
    // Datos estudiante
    estudiante: {
      nombre: input.estudiante.nombre,
      rut: input.estudiante.rut,
      email: input.estudiante.email
    },
    
    // Datos solicitud
    solicitud: {
      id: input.idSolicitud,
      timestamp: input.timestamp || new Date().toISOString()
    },
    
    // Datos error
    error: {
      tipo: input.error.tipo,
      mensaje: input.error.mensaje,
      detalles: input.error.detalles || {}
    },
    
    // Metadatos
    metadata: {
      workflow: "HU-005",
      version: "1.0",
      processed_at: new Date().toISOString()
    }
  }
};
```

---

### **[4] Function-SeleccionarTemplate**

**Tipo:** Switch Node

**Configuración:**
```javascript
const tipoError = $json.error.tipo;

// Mapeo de tipos de error a templates
const templateMap = {
  "formato_incorrecto": 0,
  "tamano_excedido": 1,
  "archivo_corrupto": 2,
  "campos_faltantes": 3
};

// Retornar índice del template (output)
return templateMap[tipoError] ?? 4; // 4 = template genérico
```

**Outputs:**
- Output 0: Template formato incorrecto
- Output 1: Template tamaño excedido
- Output 2: Template archivo corrupto
- Output 3: Template campos faltantes
- Output 4: Template genérico (fallback)

---

### **[5] Function-RedactarEmail**

**Tipo:** Function Node

**Código:**
```javascript
const data = $input.all()[0].json;

// Templates de email (según tipo de error)
const templates = {
  formato_incorrecto: {
    subject: "Corrección Requerida - Formato de Documento Incorrecto",
    body: `Estimado/a [NOMBRE_ESTUDIANTE],

Hemos recibido tu solicitud de convalidación (ID: [ID_SOLICITUD]), sin embargo, 
no podemos procesarla debido a que el documento adjunto no está en el formato correcto.

📌 PROBLEMA DETECTADO:
- Archivo recibido: [NOMBRE_ARCHIVO]
- Formato detectado: [TIPO_ARCHIVO]
- Motivo rechazo: [MOTIVO_RECHAZO]

✅ CÓMO CORREGIR:
1. Convierte tu documento a formato PDF
2. Verifica que el archivo no supere 10 MB
3. Reenvía tu solicitud haciendo clic aquí: [LINK_REENVIO]

📧 ¿NECESITAS AYUDA?
Contacta a nuestro equipo: convalidaciones@unab.cl

Saludos cordiales,
Sistema de Convalidaciones Académicas
Universidad Andrés Bello`
  },
  
  tamano_excedido: {
    subject: "Corrección Requerida - Archivo Demasiado Grande",
    body: `Estimado/a [NOMBRE_ESTUDIANTE],

Hemos recibido tu solicitud de convalidación (ID: [ID_SOLICITUD]), sin embargo, 
no podemos procesarla debido a que el archivo adjunto supera el tamaño máximo permitido.

📌 PROBLEMA DETECTADO:
- Archivo recibido: [NOMBRE_ARCHIVO]
- Tamaño actual: [TAMANO_MB] MB
- Tamaño máximo: 10 MB

✅ CÓMO CORREGIR:
1. Comprime tu archivo PDF
2. Verifica que el tamaño final sea menor a 10 MB
3. Reenvía tu solicitud: [LINK_REENVIO]

📧 ¿NECESITAS AYUDA?
Contacta: convalidaciones@unab.cl

Saludos cordiales,
Sistema de Convalidaciones Académicas
Universidad Andrés Bello`
  },
  
  archivo_corrupto: {
    subject: "Corrección Requerida - Archivo No Puede Ser Leído",
    body: `Estimado/a [NOMBRE_ESTUDIANTE],

Hemos recibido tu solicitud de convalidación (ID: [ID_SOLICITUD]), sin embargo, 
no podemos procesarla debido a que el archivo adjunto no puede ser leído correctamente.

📌 PROBLEMA DETECTADO:
- Archivo recibido: [NOMBRE_ARCHIVO]
- Error: El archivo está corrupto o dañado

✅ CÓMO CORREGIR:
1. Verifica que el archivo PDF se abra correctamente
2. Genera un nuevo PDF desde el documento original
3. Reenvía tu solicitud: [LINK_REENVIO]

📧 ¿NECESITAS AYUDA?
Contacta: convalidaciones@unab.cl

Saludos cordiales,
Sistema de Convalidaciones Académicas
Universidad Andrés Bello`
  },
  
  campos_faltantes: {
    subject: "Corrección Requerida - Información Incompleta",
    body: `Estimado/a [NOMBRE_ESTUDIANTE],

Hemos recibido tu solicitud de convalidación (ID: [ID_SOLICITUD]), sin embargo, 
no podemos procesarla debido a que falta información requerida.

📌 CAMPOS FALTANTES:
[CAMPOS_FALTANTES]

✅ CÓMO CORREGIR:
1. Completa todos los campos obligatorios
2. Verifica información adjunta
3. Reenvía tu solicitud: [LINK_REENVIO]

📧 ¿NECESITAS AYUDA?
Contacta: convalidaciones@unab.cl

Saludos cordiales,
Sistema de Convalidaciones Académicas
Universidad Andrés Bello`
  }
};

// Seleccionar template según tipo error
const template = templates[data.error.tipo] || templates.formato_incorrecto;

// Reemplazar variables
let subject = template.subject;
let body = template.body;

const replacements = {
  '[NOMBRE_ESTUDIANTE]': data.estudiante.nombre,
  '[ID_SOLICITUD]': data.solicitud.id,
  '[NOMBRE_ARCHIVO]': data.error.detalles.archivoNombre || 'N/A',
  '[TIPO_ARCHIVO]': data.error.detalles.archivoTipo || 'N/A',
  '[TAMANO_MB]': data.error.detalles.tamanoMB || 'N/A',
  '[MOTIVO_RECHAZO]': data.error.detalles.motivoRechazo || data.error.mensaje,
  '[LINK_REENVIO]': `https://formulario-convalidacion.unab.cl?retry=${data.solicitud.id}`,
  '[CAMPOS_FALTANTES]': (data.error.detalles.camposFaltantes || []).map(c => `- ${c}`).join('\n')
};

// Aplicar reemplazos
Object.keys(replacements).forEach(key => {
  subject = subject.replace(key, replacements[key]);
  body = body.replace(new RegExp(key, 'g'), replacements[key]);
});

// Retornar email preparado
return {
  json: {
    to: data.estudiante.email,
    from: 'convalidaciones@unab.cl',
    subject: subject,
    body: body,
    metadata: {
      idSolicitud: data.solicitud.id,
      tipoError: data.error.tipo,
      templateUsado: data.error.tipo
    }
  }
};
```

---

### **[6] Email-Correccion (SMTP)**

**Tipo:** Email Node (SMTP)

**Configuración:**
```
Host: smtp.ethereal.email (testing) / smtp.gmail.com (producción)
Port: 587
Secure: STARTTLS
Auth:
  User: {{ $credentials.smtp.user }}
  Pass: {{ $credentials.smtp.password }}
  
To: {{ $json.to }}
From: {{ $json.from }}
Subject: {{ $json.subject }}
Body: {{ $json.body }}

Timeout: 30000 ms
Reintentos: 3
Intervalo Reintentos: 30000 ms
```

---

### **[7] Function-PrepararLog**

**Tipo:** Function Node

**Código:**
```javascript
const emailData = $input.all()[0].json;
const previousData = $node["Function-PrepararDatos"].json;

// Preparar registro para Google Sheets
return {
  json: {
    timestamp: new Date().toISOString(),
    idSolicitud: emailData.metadata.idSolicitud,
    tipo_notificacion: "error_documentacion",
    tipo_error: emailData.metadata.tipoError,
    email_enviado: "si",
    destinatario: emailData.to,
    template_utilizado: emailData.metadata.templateUsado,
    estado_envio: "exitoso",
    intentos_envio: 1,
    detalles_error: previousData.error.mensaje
  }
};
```

---

### **[8] GoogleSheets-InsertRow**

**Tipo:** Google Sheets Node

**Configuración:**
```
Operation: Append Row
Spreadsheet: [ID de tu Google Sheet]
Sheet Name: Logs

Columns Mapping:
  timestamp         → {{ $json.timestamp }}
  idSolicitud       → {{ $json.idSolicitud }}
  tipo_notificacion → {{ $json.tipo_notificacion }}
  tipo_error        → {{ $json.tipo_error }}
  email_enviado     → {{ $json.email_enviado }}
  destinatario      → {{ $json.destinatario }}
  template_utilizado→ {{ $json.template_utilizado }}
  estado_envio      → {{ $json.estado_envio }}
  intentos_envio    → {{ $json.intentos_envio }}
  detalles_error    → {{ $json.detalles_error }}
```

---

### **[9] Respond-Success**

**Tipo:** Respond to Webhook Node

**Configuración:**
```javascript
{
  "success": true,
  "idSolicitud": "{{ $json.idSolicitud }}",
  "emailEnviado": true,
  "destinatario": "{{ $json.destinatario }}",
  "tipoError": "{{ $json.tipo_error }}",
  "templateUtilizado": "{{ $json.template_utilizado }}",
  "timestamp": "{{ $json.timestamp }}",
  "logRegistrado": true,
  "mensaje": "Email de corrección enviado exitosamente"
}
```

---

## ⚙️ Configuración de Credenciales

### **SMTP (Ethereal - Testing)**
```
Nombre: SMTP-Ethereal-HU005
Tipo: SMTP
Host: smtp.ethereal.email
Port: 587
User: [generar en ethereal.email]
Pass: [generar en ethereal.email]
Secure: STARTTLS
```

### **Google Sheets API**
```
Nombre: GoogleSheets-Convalidaciones
Tipo: Google Sheets OAuth2
Scopes: 
  - https://www.googleapis.com/auth/spreadsheets
Spreadsheet ID: [tu spreadsheet ID]
```

---

## 🔄 Manejo de Errores

### **Error Handler 1: SMTP Falló**
**Trigger:** Nodo Email-Correccion falla  
**Action:**
1. Capturar error con nodo `Error Trigger`
2. Reintentar 3 veces (intervalo 30s)
3. Si persiste: registrar en Logs como "pendiente_reenvio"
4. Notificar admin

### **Error Handler 2: Google Sheets No Disponible**
**Trigger:** Nodo GoogleSheets-InsertRow falla  
**Action:**
1. No bloquear workflow
2. Continuar con respuesta
3. Advertencia en response: `logRegistrado: false`
4. Guardar datos localmente en n8n para reintento manual

---

## 📊 Variables de Entorno

```env
# SMTP Configuration
SMTP_HOST=smtp.ethereal.email
SMTP_PORT=587
SMTP_USER=
SMTP_PASS=

# Google Sheets
GOOGLE_SHEET_ID=
GOOGLE_SHEET_NAME=Logs

# URLs
URL_FORMULARIO=https://formulario-convalidacion.unab.cl
```

---

## ✅ Checklist de Implementación

- ⬜ Todos los 9 nodos creados en n8n
- ⬜ Conexiones entre nodos establecidas
- ⬜ Credenciales SMTP configuradas
- ⬜ Credenciales Google Sheets configuradas
- ⬜ 4 templates de email implementados
- ⬜ Error handlers configurados
- ⬜ Validaciones de entrada activas
- ⬜ Integración con HU-004 probada
- ⬜ Workflow exportado como JSON

---

**Versión:** 1.0  
**Última Actualización:** 9 noviembre 2025  
**Estado:** ✅ Diseño completado - Listo para implementación
