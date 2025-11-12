# Integración HU-001 con HU-005 - Documentación Técnica

## 📋 **Información General**

**Objetivo:** Documentar la integración entre HU-001 (Recepción de Solicitudes) y HU-005 (Notificación de Corrección de Documentos).

**Versión:** 1.0  
**Fecha:** 12 noviembre 2025  
**Tipo de Integración:** HTTP Request (Webhook to Webhook)

---

## 🎯 **Resumen de Integración**

### **Flujo General:**
```
┌─────────────────────────────────────────────────────────────────┐
│                         HU-001: RECEPCIÓN                       │
├─────────────────────────────────────────────────────────────────┤
│ 1. Webhook recibe solicitud                                     │
│ 2. Valida campos obligatorios                                   │
│ 3. Valida RUT chileno                                           │
│ 4. Valida email                                                 │
│ 5. ┌─────────────────────────────────┐                         │
│    │ Valida formato PDF (HU-004)     │                         │
│    └────┬────────────────────┬────────┘                         │
│         │ PDF OK             │ PDF ERROR                        │
│         ▼                    ▼                                  │
│    Subir a Drive      [INTEGRACIÓN HU-005]                      │
│    Log en Sheets              │                                 │
│    Email confirmación         │                                 │
│                               ▼                                 │
│                    ┌──────────────────────────┐                 │
│                    │  HTTP Request a HU-005   │                 │
│                    │  POST /webhook/hu005-... │                 │
│                    └──────────────────────────┘                 │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                      HU-005: NOTIFICACIÓN                       │
├─────────────────────────────────────────────────────────────────┤
│ 1. Webhook recibe datos de error                                │
│ 2. Valida entrada (campos obligatorios)                         │
│ 3. Selecciona template según tipo error                         │
│ 4. Genera email HTML personalizado                              │
│ 5. Envía email vía SMTP                                         │
│ 6. Registra log en Google Sheets                                │
│ 7. Retorna confirmación HTTP 200                                │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔗 **Punto de Integración**

### **Nodo en HU-001: HTTP-Notificar HU-005**

**Ubicación en Workflow:** Después del nodo `IF - PDF Válido` (rama FALSE)

**Tipo de Nodo:** HTTP Request (n8n-nodes-base.httpRequest)

**Configuración:**

```javascript
{
  "name": "HTTP-Notificar HU-005",
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.2,
  "parameters": {
    "method": "POST",
    "url": "http://localhost:5678/webhook/hu005-notificacion-correccion",
    "authentication": "none",
    "sendBody": true,
    "specifyBody": "json",
    "jsonBody": "={
      \"idSolicitud\": \"{{$json.id}}\",
      \"estudiante\": {
        \"nombre\": \"{{$json.nombre}}\",
        \"rut\": \"{{$json.rut}}\",
        \"email\": \"{{$json.email}}\"
      },
      \"error\": {
        \"tipo\": \"{{$json.tipoError}}\",
        \"mensaje\": \"{{$json.mensajeError}}\",
        \"detalles\": {{$json.detallesError}}
      }
    }",
    "options": {
      "timeout": 30000,
      "redirect": {
        "redirect": {
          "followRedirects": true,
          "maxRedirects": 5
        }
      }
    }
  }
}
```

**⚠️ IMPORTANTE:** Usar `typeVersion: 4.2` que requiere `jsonBody` en lugar de `bodyParameters`.

---

## 📊 **Datos Transmitidos**

### **Estructura JSON Enviada:**

```json
{
  "idSolicitud": "SOL-12345678-1699888000",
  "estudiante": {
    "nombre": "Juan Pérez González",
    "rut": "12.345.678-9",
    "email": "juan.perez@estudiante.unab.cl"
  },
  "error": {
    "tipo": "formato_incorrecto",
    "mensaje": "El archivo no es un PDF válido",
    "detalles": {
      "archivoNombre": "certificado.docx",
      "archivoTipo": "application/msword",
      "tamanoMB": "2.5",
      "motivoRechazo": "Solo se aceptan archivos en formato PDF"
    }
  }
}
```

### **Mapeo de Variables:**

| Variable en HU-001 | Campo JSON | Descripción |
|-------------------|------------|-------------|
| `$json.id` | idSolicitud | ID único de la solicitud |
| `$json.nombre` | estudiante.nombre | Nombre completo del estudiante |
| `$json.rut` | estudiante.rut | RUT con formato |
| `$json.email` | estudiante.email | Email del estudiante |
| `$json.tipoError` | error.tipo | Tipo de error detectado |
| `$json.mensajeError` | error.mensaje | Mensaje descriptivo del error |
| `$json.detallesError` | error.detalles | Objeto con detalles específicos |

---

## 🔧 **Preparación de Datos en HU-001**

### **Nodo: Function - Preparar Error PDF**

**Ubicación:** Antes del nodo `HTTP-Notificar HU-005`

**Propósito:** Estructurar los datos del error en el formato esperado por HU-005

**Código JavaScript:**

```javascript
// Preparar datos de error para HU-005
const data = $input.item.json;

// Determinar tipo de error específico
let tipoError = 'formato_incorrecto';
let mensajeError = 'El archivo no es un PDF válido';
let detallesError = {};

// Verificar qué tipo de error ocurrió
if (!data.pdfsOk) {
  // Error de formato
  tipoError = 'formato_incorrecto';
  mensajeError = 'El archivo enviado no está en formato PDF';
  detallesError = {
    archivoNombre: data.fileName || 'desconocido',
    archivoTipo: data.fileMimeType || 'desconocido',
    tamanoMB: data.fileSizeMB || '0',
    motivoRechazo: 'Solo se aceptan archivos en formato PDF'
  };
} else if (!data.sizeOk) {
  // Error de tamaño
  tipoError = 'tamano_excedido';
  mensajeError = 'El archivo supera el tamaño máximo de 10 MB';
  detallesError = {
    archivoNombre: data.fileName || 'desconocido',
    archivoTipo: 'application/pdf',
    tamanoMB: data.fileSizeMB || '0',
    motivoRechazo: `El archivo supera el tamaño máximo de 10 MB (actual: ${data.fileSizeMB} MB)`
  };
}

// Preservar todos los datos originales y agregar info de error
const result = Object.assign({}, data, {
  tipoError: tipoError,
  mensajeError: mensajeError,
  detallesError: detallesError
});

return { json: result };
```

---

## 📨 **Respuesta de HU-005**

### **Respuesta Exitosa (HTTP 200):**

```json
{
  "success": true,
  "mensaje": "Notificación enviada correctamente",
  "destinatario": "juan.perez@estudiante.unab.cl",
  "tipoError": "formato_incorrecto",
  "timestamp": "2025-11-12T14:30:00Z"
}
```

### **Respuesta Error (HTTP 400/500):**

```json
{
  "success": false,
  "error": "Datos de entrada inválidos",
  "detalles": "Falta campo requerido: estudiante.email",
  "code": 400
}
```

---

## 🧪 **Casos de Uso de Integración**

### **Caso 1: Formato de Archivo Incorrecto**

**Trigger:** Usuario sube archivo .docx en lugar de PDF

**Flujo:**
1. HU-001 detecta extensión != .pdf en nodo `Function - Validar PDF`
2. `IF - PDF Válido` toma rama FALSE
3. `Function - Preparar Error PDF` estructura datos:
   ```json
   {
     "tipoError": "formato_incorrecto",
     "mensajeError": "El archivo no es un PDF válido",
     "detallesError": {
       "archivoNombre": "certificado.docx",
       "archivoTipo": "application/msword",
       "motivoRechazo": "Solo se aceptan archivos PDF"
     }
   }
   ```
4. `HTTP-Notificar HU-005` envía POST request
5. HU-005 procesa y envía email con template "Formato Incorrecto"
6. Estudiante recibe email con instrucciones

**Tiempo Total:** ~3-5 segundos

---

### **Caso 2: Archivo Muy Grande**

**Trigger:** Usuario sube PDF de 15.8 MB (límite: 10 MB)

**Flujo:**
1. `Function - Validar Tamaño` detecta fileSize > 10MB
2. Marca `sizeOk: false`
3. `IF - PDF Válido` toma rama FALSE
4. `Function - Preparar Error PDF` estructura:
   ```json
   {
     "tipoError": "tamano_excedido",
     "mensajeError": "El archivo supera el tamaño máximo de 10 MB",
     "detallesError": {
       "archivoNombre": "programa.pdf",
       "tamanoMB": "15.8",
       "motivoRechazo": "El archivo supera el tamaño máximo de 10 MB (actual: 15.8 MB)"
     }
   }
   ```
5. HTTP Request a HU-005
6. Email con template "Tamaño Excedido" enviado

---

### **Caso 3: PDF Corrupto**

**Trigger:** Archivo PDF dañado que no puede procesarse

**Nota:** Este caso requiere validación adicional no implementada aún.

**Implementación Futura:**
```javascript
// En Function - Validar PDF
try {
  // Intentar leer headers del PDF
  const pdfHeader = data.fileData.substring(0, 5);
  if (pdfHeader !== 'JVBERi') { // '%PDF-' en base64
    throw new Error('PDF corrupto');
  }
} catch (error) {
  return {
    json: Object.assign({}, data, {
      pdfsOk: false,
      tipoError: 'archivo_corrupto',
      mensajeError: 'El archivo PDF está corrupto',
      detallesError: {
        archivoNombre: data.fileName,
        motivoRechazo: 'El archivo está dañado y no puede ser procesado'
      }
    })
  };
}
```

---

## 🔍 **Validaciones en HU-005**

### **Nodo: Function-ValidarEntrada**

HU-005 valida los datos recibidos antes de procesar:

```javascript
const data = $input.item.json;
const errors = [];

// Validar campos obligatorios
if (!data.idSolicitud) {
  errors.push('Falta campo requerido: idSolicitud');
}

if (!data.estudiante || !data.estudiante.email) {
  errors.push('Falta campo requerido: estudiante.email');
}

if (!data.estudiante || !data.estudiante.nombre) {
  errors.push('Falta campo requerido: estudiante.nombre');
}

if (!data.error || !data.error.tipo) {
  errors.push('Falta campo requerido: error.tipo');
}

// Validar tipo de error permitido
const tiposPermitidos = [
  'formato_incorrecto',
  'tamano_excedido',
  'archivo_corrupto',
  'campos_faltantes'
];

if (data.error && !tiposPermitidos.includes(data.error.tipo)) {
  errors.push(`Tipo de error no válido: ${data.error.tipo}. Permitidos: ${tiposPermitidos.join(', ')}`);
}

// Si hay errores, retornar 400
if (errors.length > 0) {
  return {
    json: {
      success: false,
      error: 'Datos de entrada inválidos',
      detalles: errors.join('; '),
      code: 400
    }
  };
}

// Datos válidos, continuar
return { json: data };
```

---

## 🚨 **Manejo de Errores en Integración**

### **Error: HU-005 No Responde (Timeout)**

**Causa:** Webhook HU-005 no está activo o n8n caído

**Síntoma:** HTTP Request timeout después de 30 segundos

**Solución en HU-001:**

```javascript
// Nodo: Function - Log Error HTTP
const data = $input.item.json;
const errorHTTP = $input.item.error || 'Timeout';

return {
  json: {
    id: data.id,
    evento: 'ErrorIntegracionHU005',
    detalles: `No se pudo notificar a HU-005: ${errorHTTP}`,
    estado: 'ERROR',
    timestamp: new Date().toISOString()
  }
};
```

**Acción:**
1. Log del error en Google Sheets (Logs_Errores)
2. Continuar flujo HU-001 (no bloquear solicitud)
3. Notificar al administrador (futuro)

---

### **Error: HU-005 Retorna 400 (Datos Inválidos)**

**Causa:** Datos mal estructurados desde HU-001

**Solución:**
1. Revisar nodo `Function - Preparar Error PDF`
2. Verificar que todos los campos obligatorios estén presentes
3. Validar formato del JSON

**Debug:**
```javascript
// Agregar logging antes del HTTP Request
console.log('Datos enviados a HU-005:', JSON.stringify({
  idSolicitud: data.id,
  estudiante: {
    nombre: data.nombre,
    rut: data.rut,
    email: data.email
  },
  error: {
    tipo: data.tipoError,
    mensaje: data.mensajeError,
    detalles: data.detallesError
  }
}, null, 2));
```

---

### **Error: HU-005 Retorna 500 (Error SMTP)**

**Causa:** Falla al enviar email por SMTP

**Impacto:** Email no llega al estudiante, pero solicitud se procesa

**HU-005 Maneja Internamente:**
1. Registra error en Logs_Errores
2. Retorna HTTP 500 a HU-001
3. HU-001 loguea el fallo pero continúa

**Acción Manual Requerida:**
1. Revisar Logs_Errores en Sheets
2. Verificar credenciales SMTP
3. Reenviar notificación manualmente si es crítico

---

## 🧪 **Pruebas de Integración**

### **Test 1: Flujo Completo End-to-End**

**Objetivo:** Verificar integración completa HU-001 → HU-005

**Pasos:**
1. Enviar solicitud a HU-001 con archivo .docx:
   ```powershell
   $body = @{
       nombre = "Test Integración"
       rut = "12345678-9"
       email = "tu-email@gmail.com"
       carrera = "Ingeniería"
       asignatura = "Test"
       institucionOrigen = "UNAB"
       file = @{
           filename = "test.docx"
           data = [base64_del_archivo]
           mimeType = "application/msword"
       }
   } | ConvertTo-Json -Depth 10
   
   Invoke-RestMethod -Method Post -Uri "http://localhost:5678/webhook/solicitud-convalidacion" -Body $body -ContentType "application/json"
   ```

2. Verificar en n8n:
   - HU-001 detecta formato incorrecto
   - Nodo `HTTP-Notificar HU-005` se ejecuta (verde)
   - HU-005 se activa automáticamente

3. Verificar email:
   - Email recibido en <10 segundos
   - Template "Formato Incorrecto" correcto
   - Datos personalizados presentes

**Resultado Esperado:** ✅ PASS si todo el flujo funciona

---

### **Test 2: Validación de Datos Inválidos**

**Objetivo:** Verificar que HU-005 rechaza datos mal formados

**Pasos:**
1. Modificar temporalmente `Function - Preparar Error PDF` para enviar datos incompletos:
   ```javascript
   return {
     json: {
       idSolicitud: data.id
       // Faltan: estudiante, error
     }
   };
   ```

2. Ejecutar flujo

3. Verificar:
   - HU-005 retorna HTTP 400
   - Mensaje indica campos faltantes
   - HU-001 loguea el error

**Resultado Esperado:** ✅ PASS si validación funciona

---

### **Test 3: Simulación Falla SMTP en HU-005**

**Objetivo:** Verificar manejo de errores de envío

**Pasos:**
1. Desactivar temporalmente credenciales SMTP en HU-005
2. Ejecutar flujo completo desde HU-001
3. Observar:
   - HU-005 retorna HTTP 500
   - Error registrado en Logs_Errores
   - HU-001 continúa su flujo

**Resultado Esperado:** ✅ PASS si error no bloquea HU-001

---

## 📊 **Monitoreo de Integración**

### **Métricas Clave:**

| Métrica | Objetivo | Cómo Medir |
|---------|----------|------------|
| Tiempo respuesta HTTP | <3s | Logs n8n Executions |
| Tasa de éxito integración | >95% | Count(HTTP 200) / Total |
| Emails entregados | >95% | Logs_HU005 / HTTP Requests |
| Errores de validación | <5% | Count(HTTP 400) |
| Errores SMTP | <2% | Count(HTTP 500) |

### **Dashboard Recomendado:**

**Google Sheets - Hoja "Métricas_Integración":**

```excel
# Columnas:
Fecha | Total_Errores_Detectados | HTTP_Requests_HU005 | Emails_Enviados | 
Tasa_Exito | Errores_400 | Errores_500

# Fórmulas:
Tasa_Exito = Emails_Enviados / HTTP_Requests_HU005 * 100
```

---

## 🔐 **Seguridad**

### **Consideraciones:**

1. **Webhook Interno:** 
   - URL: `localhost:5678` (no expuesto públicamente)
   - Sin autenticación (uso interno entre workflows)
   - En producción: Considerar API Key

2. **Datos Sensibles:**
   - ✅ RUT se transmite (necesario para identificación)
   - ✅ Email se transmite (necesario para envío)
   - ❌ NO se transmiten contraseñas ni tokens
   - ❌ NO se transmite contenido del archivo

3. **Rate Limiting:**
   - No implementado (volumen bajo esperado)
   - Futuro: Limitar a 100 requests/minuto por seguridad

---

## 📚 **Referencias**

### **Archivos Relacionados:**
- `sistema-final/workflows/workflow.json` - Workflow integrado completo
- `hu005/workflows/HU-005.json` - Workflow standalone HU-005
- `hu005/docs/HU-05_FICHA_TECNICA.md` - Especificación HU-005

### **Nodos Clave:**
- HU-001: `HTTP-Notificar HU-005` (línea ~380 del workflow.json)
- HU-001: `Function - Preparar Error PDF` (línea ~350)
- HU-005: `Webhook-HU005` (línea ~10 de HU-005.json)
- HU-005: `Function-ValidarEntrada` (línea ~30)

---

## 🚀 **Mejoras Futuras**

### **Sprint 3:**
1. ✅ Validación de PDF corrupto
2. ✅ Reintentos automáticos si falla HTTP Request
3. ✅ Queue para notificaciones (evitar pérdida)
4. ✅ Autenticación webhook (API Key)

### **Largo Plazo:**
5. Notificación al admin si integración falla >3 veces
6. Dashboard en tiempo real de estado integración
7. Métricas de rendimiento end-to-end
8. Sistema de alertas automáticas

---

**Documento elaborado:** 12 noviembre 2025  
**Responsable:** Equipo DevOps + QA  
**Estado:** ✅ COMPLETO  
**Próxima revisión:** Sprint Review
