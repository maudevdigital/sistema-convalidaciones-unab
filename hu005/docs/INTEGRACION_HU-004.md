# HU-005: Guía de Integración con HU-004

## 📋 Objetivo

Conectar el workflow HU-004 (Verificación de Documentos) con HU-005 (Notificación de Corrección) para que automáticamente se envíen emails cuando se detecten errores de validación.

---

## 🔗 Arquitectura de Integración

```
┌─────────────────────────────────────────────────────────────────┐
│                      HU-001: Recepción                          │
│                  (Formulario + Almacenamiento)                  │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                  HU-004: Validación Documentos                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ IF-ValidacionDoc                                           │ │
│  │   ├─ Formato correcto?                                     │ │
│  │   ├─ Tamaño < 10 MB?                                       │ │
│  │   ├─ Archivo no corrupto?                                  │ │
│  │   └─ Campos completos?                                     │ │
│  └───────────────────┬────────────────────┬───────────────────┘ │
│                      │                    │                     │
│                  (válido)            (error)                    │
│                      │                    │                     │
└──────────────────────┼────────────────────┼─────────────────────┘
                       │                    │
                       ▼                    ▼
          ┌────────────────────┐   ┌──────────────────────────┐
          │ Continuar Proceso  │   │  ACTIVAR HU-005          │
          │ (HU-006+)          │   │  (Webhook / HTTP Call)   │
          └────────────────────┘   └────────────┬─────────────┘
                                                 │
                                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                HU-005: Notificación Corrección                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ 1. Recibir datos error desde HU-004                        │ │
│  │ 2. Generar email según tipo error                          │ │
│  │ 3. Enviar vía SMTP                                         │ │
│  │ 4. Registrar en Logs                                       │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Paso 1: Modificar HU-004 Workflow

### **1.1: Agregar Nodo HTTP Request en Rama de Error**

En el workflow HU-004, después del nodo `IF-ValidacionDoc` en la rama de **error**, agregar:

**Nodo:** HTTP Request  
**Nombre:** `HTTP-NotificarHU005`  
**Configuración:**

```json
{
  "method": "POST",
  "url": "http://localhost:5678/webhook/hu005-notificacion-correccion",
  "authentication": "none",
  "requestFormat": "json",
  "jsonBody": {
    "idSolicitud": "={{$node['Webhook-FormularioHU001'].json.idSolicitud}}",
    "estudiante": {
      "nombre": "={{$node['Webhook-FormularioHU001'].json.estudiante.nombre}}",
      "rut": "={{$node['Webhook-FormularioHU001'].json.estudiante.rut}}",
      "email": "={{$node['Webhook-FormularioHU001'].json.estudiante.email}}"
    },
    "error": {
      "tipo": "={{$json.tipoError}}",
      "mensaje": "={{$json.mensajeError}}",
      "detalles": "={{$json.detallesError}}"
    },
    "timestamp": "={{$now.toISO()}}"
  },
  "options": {
    "timeout": 10000,
    "response": {
      "response": {
        "fullResponse": false,
        "neverError": true
      }
    }
  }
}
```

### **1.2: Estructura de Datos Esperada**

HU-004 debe enviar este JSON al webhook de HU-005:

#### **Error: Formato Incorrecto**
```json
{
  "idSolicitud": "SOL-12345678-1699564800000",
  "estudiante": {
    "nombre": "Juan Pérez González",
    "rut": "19.876.543-2",
    "email": "juan.perez@estudiante.unab.cl"
  },
  "error": {
    "tipo": "formato_incorrecto",
    "mensaje": "Formato de archivo no válido",
    "detalles": {
      "archivoNombre": "certificado.docx",
      "archivoTipo": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      "motivoRechazo": "Solo se aceptan archivos PDF"
    }
  },
  "timestamp": "2025-11-09T14:30:00Z"
}
```

#### **Error: Tamaño Excedido**
```json
{
  "idSolicitud": "SOL-98765432-1699564800000",
  "estudiante": {
    "nombre": "María Silva Torres",
    "rut": "18.234.567-8",
    "email": "maria.silva@estudiante.unab.cl"
  },
  "error": {
    "tipo": "tamano_excedido",
    "mensaje": "Archivo supera tamaño máximo",
    "detalles": {
      "archivoNombre": "certificado_notas.pdf",
      "tamanoMB": 15.5,
      "tamanoMaximoMB": 10,
      "motivoRechazo": "El archivo supera el tamaño máximo de 10 MB"
    }
  },
  "timestamp": "2025-11-09T14:30:00Z"
}
```

#### **Error: Archivo Corrupto**
```json
{
  "idSolicitud": "SOL-11223344-1699564800000",
  "estudiante": {
    "nombre": "Pedro Ramírez Castro",
    "rut": "20.111.222-3",
    "email": "pedro.ramirez@estudiante.unab.cl"
  },
  "error": {
    "tipo": "archivo_corrupto",
    "mensaje": "El archivo no puede ser leído",
    "detalles": {
      "archivoNombre": "certificado_corrupto.pdf",
      "motivoRechazo": "El archivo está corrupto o dañado"
    }
  },
  "timestamp": "2025-11-09T14:30:00Z"
}
```

#### **Error: Campos Faltantes**
```json
{
  "idSolicitud": "SOL-55667788-1699564800000",
  "estudiante": {
    "nombre": "Ana López Martínez",
    "rut": "19.555.666-7",
    "email": "ana.lopez@estudiante.unab.cl"
  },
  "error": {
    "tipo": "campos_faltantes",
    "mensaje": "Faltan campos obligatorios",
    "detalles": {
      "camposFaltantes": ["asignaturaConvalidar", "institucionOrigen"],
      "motivoRechazo": "Debe completar todos los campos obligatorios"
    }
  },
  "timestamp": "2025-11-09T14:30:00Z"
}
```

---

## 🛠️ Paso 2: Configurar Webhook en HU-005

### **2.1: URL del Webhook**

El webhook de HU-005 ya está configurado en el workflow:

```
http://localhost:5678/webhook/hu005-notificacion-correccion
```

**Para entorno de producción:**
```
https://n8n.unab.cl/webhook/hu005-notificacion-correccion
```

### **2.2: Método HTTP**
- **Método:** POST
- **Content-Type:** application/json
- **Autenticación:** Ninguna (interno)

### **2.3: Activar Webhook**

1. Abrir workflow HU-005 en n8n
2. Click en nodo `Webhook-HU004`
3. Click en **"Listen for Test Event"** o **"Execute Node"**
4. Copiar la URL del webhook generada
5. Usar esa URL en HU-004

---

## 🛠️ Paso 3: Código de Integración en HU-004

### **3.1: Nodo Function para Preparar Payload**

Antes del nodo `HTTP-NotificarHU005`, agregar:

**Nodo:** Function  
**Nombre:** `Function-PrepararPayloadHU005`

```javascript
// Obtener datos de validación
const validacionResult = $input.all()[0].json;
const solicitudData = $node["Webhook-FormularioHU001"].json;

// Determinar tipo de error
let tipoError = "formato_incorrecto"; // default
let detallesError = {};

if (validacionResult.errorType === "invalid_format") {
  tipoError = "formato_incorrecto";
  detallesError = {
    archivoNombre: validacionResult.fileName,
    archivoTipo: validacionResult.fileType,
    motivoRechazo: "Solo se aceptan archivos PDF"
  };
} else if (validacionResult.errorType === "size_exceeded") {
  tipoError = "tamano_excedido";
  detallesError = {
    archivoNombre: validacionResult.fileName,
    tamanoMB: validacionResult.fileSizeMB,
    tamanoMaximoMB: 10,
    motivoRechazo: "El archivo supera el tamaño máximo de 10 MB"
  };
} else if (validacionResult.errorType === "corrupted_file") {
  tipoError = "archivo_corrupto";
  detallesError = {
    archivoNombre: validacionResult.fileName,
    motivoRechazo: "El archivo está corrupto o dañado"
  };
} else if (validacionResult.errorType === "missing_fields") {
  tipoError = "campos_faltantes";
  detallesError = {
    camposFaltantes: validacionResult.missingFields || [],
    motivoRechazo: "Debe completar todos los campos obligatorios"
  };
}

// Construir payload para HU-005
return {
  json: {
    idSolicitud: solicitudData.idSolicitud,
    estudiante: {
      nombre: solicitudData.estudiante.nombre,
      rut: solicitudData.estudiante.rut,
      email: solicitudData.estudiante.email
    },
    error: {
      tipo: tipoError,
      mensaje: validacionResult.errorMessage,
      detalles: detallesError
    },
    timestamp: new Date().toISOString()
  }
};
```

---

## 🧪 Paso 4: Pruebas de Integración

### **Test 1: Error de Formato**

**Input en HU-001:**
- Archivo: `certificado.docx` (no PDF)

**Flujo Esperado:**
1. HU-001 recibe y almacena
2. HU-004 detecta formato incorrecto
3. HU-004 llama webhook HU-005
4. HU-005 genera email "Formato Incorrecto"
5. Email enviado al estudiante
6. Log registrado en Google Sheets

**Verificación:**
```bash
# Revisar logs n8n
curl http://localhost:5678/webhook/hu005-notificacion-correccion \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "idSolicitud": "SOL-TEST-001",
    "estudiante": {
      "nombre": "Juan Test",
      "rut": "19.876.543-2",
      "email": "juan.test@ethereal.email"
    },
    "error": {
      "tipo": "formato_incorrecto",
      "mensaje": "Formato no válido",
      "detalles": {
        "archivoNombre": "certificado.docx",
        "archivoTipo": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "motivoRechazo": "Solo se aceptan archivos PDF"
      }
    },
    "timestamp": "2025-11-09T14:30:00Z"
  }'
```

### **Test 2: Error de Tamaño**

**Input en HU-001:**
- Archivo: `certificado.pdf` (15 MB)

**Verificación:**
```bash
curl http://localhost:5678/webhook/hu005-notificacion-correccion \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "idSolicitud": "SOL-TEST-002",
    "estudiante": {
      "nombre": "María Test",
      "rut": "18.234.567-8",
      "email": "maria.test@ethereal.email"
    },
    "error": {
      "tipo": "tamano_excedido",
      "mensaje": "Archivo muy grande",
      "detalles": {
        "archivoNombre": "certificado.pdf",
        "tamanoMB": 15.5,
        "tamanoMaximoMB": 10,
        "motivoRechazo": "El archivo supera el tamaño máximo de 10 MB"
      }
    },
    "timestamp": "2025-11-09T14:30:00Z"
  }'
```

---

## 📊 Paso 5: Monitoreo y Logs

### **5.1: Verificar Logs en n8n**

1. Ir a **Executions** en n8n
2. Filtrar por workflow "HU-005"
3. Revisar ejecuciones recientes
4. Verificar que todos los nodos ejecutaron exitosamente

### **5.2: Verificar Logs en Google Sheets**

Abrir hoja "Logs" y verificar columnas:
- `timestamp`
- `idSolicitud`
- `tipo_notificacion` = "error_documentacion"
- `tipo_error` = "formato_incorrecto" | "tamano_excedido" | etc.
- `email_enviado` = "si"
- `destinatario`
- `template_utilizado`
- `estado_envio` = "exitoso"

### **5.3: Verificar Email Enviado**

**Si usas Ethereal (testing):**
1. Ir a https://ethereal.email/messages
2. Buscar email enviado
3. Verificar asunto y cuerpo

**Si usas Gmail (producción):**
1. Revisar bandeja estudiante
2. Verificar que email no esté en spam

---

## ⚠️ Manejo de Errores en Integración

### **Error 1: Webhook No Responde**

**Síntoma:** HU-004 no puede conectar con HU-005

**Solución:**
```javascript
// En nodo HTTP-NotificarHU005 de HU-004
// Configurar timeout y continuar en caso de error

{
  "continueOnFail": true,
  "options": {
    "timeout": 10000,
    "response": {
      "neverError": true
    }
  }
}
```

### **Error 2: Datos Incompletos**

**Síntoma:** HU-005 responde con HTTP 400

**Solución:**
- Verificar que HU-004 envía todos los campos requeridos
- Revisar logs de validación en nodo `Function-ValidarEntrada`

### **Error 3: Email No Se Envía**

**Síntoma:** HU-005 ejecuta pero email no llega

**Solución:**
- Verificar credenciales SMTP
- Revisar logs de nodo `Email-Correccion`
- Confirmar que destinatario es válido

---

## ✅ Checklist de Integración

### Preparación
- ⬜ HU-001 funcionando correctamente
- ⬜ HU-004 detectando errores de validación
- ⬜ HU-005 workflow importado en n8n
- ⬜ Webhook HU-005 activado y URL copiada

### Modificación HU-004
- ⬜ Nodo `Function-PrepararPayloadHU005` agregado
- ⬜ Nodo `HTTP-NotificarHU005` configurado
- ⬜ URL webhook HU-005 correcta
- ⬜ Conexión desde IF-ValidacionDoc (rama error) establecida

### Pruebas
- ⬜ Test formato incorrecto ejecutado
- ⬜ Test tamaño excedido ejecutado
- ⬜ Test archivo corrupto ejecutado
- ⬜ Test campos faltantes ejecutado
- ⬜ Todos los emails recibidos correctamente
- ⬜ Todos los logs registrados en Google Sheets

### Validación E2E
- ⬜ Flujo completo HU-001 → HU-004 → HU-005 funciona
- ⬜ Tiempo total < 30 segundos
- ⬜ Sin pérdida de datos entre workflows
- ⬜ Estudiante recibe email con instrucciones claras

---

## 📝 Ejemplo de Flujo Completo

```
1. Estudiante envía formulario con archivo .docx
   └─ HU-001: Recibe y almacena en Google Sheets

2. HU-001 activa HU-004 para validación
   └─ HU-004: Detecta formato incorrecto

3. HU-004 identifica error y prepara payload
   └─ Function-PrepararPayloadHU005: Estructura datos

4. HU-004 llama webhook HU-005
   └─ HTTP POST a http://localhost:5678/webhook/hu005-notificacion-correccion

5. HU-005 recibe y valida datos
   └─ Function-ValidarEntrada: Verifica campos requeridos

6. HU-005 prepara datos para email
   └─ Function-PrepararDatos: Extrae información

7. HU-005 genera email con template correcto
   └─ Function-RedactarEmail: Template "formato_incorrecto"

8. HU-005 envía email vía SMTP
   └─ Email-Correccion: Envío a estudiante

9. HU-005 registra evento en Google Sheets
   └─ GoogleSheets-Log: Inserta fila en hoja "Logs"

10. HU-005 responde confirmación a HU-004
    └─ Respond-Success: HTTP 200 OK

11. Estudiante recibe email con instrucciones
    └─ Puede corregir y reenviar solicitud
```

---

**Versión:** 1.0  
**Última Actualización:** 9 noviembre 2025  
**Responsable:** Developer Sprint 2  
**Estado:** ✅ Guía de integración completada
