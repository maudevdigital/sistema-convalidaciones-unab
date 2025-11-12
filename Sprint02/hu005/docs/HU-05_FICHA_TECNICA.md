# HU-05: Notificación de Corrección de Documentos - Ficha Técnica

## 📋 **Historia de Usuario**

**Como** administrador del sistema  
**Quiero** notificar automáticamente a los estudiantes cuando sus documentos requieren corrección  
**Para que** puedan reenviar la información correcta y agilizar el proceso de convalidación  

## 🎯 **Objetivo**
Implementar un sistema automatizado de notificaciones que detecte errores en la documentación recibida y envíe correos electrónicos personalizados al estudiante indicando el problema específico y las acciones necesarias para corregirlo.

## ✅ **Criterios de Aceptación (CA)**

### **CA1: Detección Automática del Rechazo de Documentación**
- **Given:** El sistema HU-004 detecta un error en la documentación recibida
- **When:** Se identifica el tipo específico de problema (formato, tamaño, campos, etc.)
- **Then:** El flujo HU-005 recibe los datos del error vía webhook
- **And:** Se registra el evento en el sistema de logging

### **CA2: Redacción de Email de Corrección Personalizado**
- **Given:** Se recibió la notificación de un documento rechazado
- **When:** Se procesa el tipo de error identificado
- **Then:** Se genera un email HTML con el template correspondiente al error
- **And:** El mensaje incluye: nombre del estudiante, ID solicitud, motivo específico del rechazo, instrucciones claras de corrección

### **CA3: Envío del Email al Estudiante**
- **Given:** El email de corrección fue generado correctamente
- **When:** Se envía vía SMTP al email del estudiante
- **Then:** El correo llega exitosamente a la bandeja del estudiante
- **And:** Se registra el envío exitoso en Google Sheets (hoja Logs)
- **And:** Se retorna confirmación HTTP 200 al sistema llamador

## 📊 **Entradas y Salidas**

### **Entradas (Input JSON vía Webhook)**
```json
{
  "idSolicitud": "SOL-12345678-1730984521",
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
      "motivoRechazo": "Solo se aceptan archivos PDF"
    }
  }
}
```

### **Tipos de Error Soportados:**
- `formato_incorrecto`: Archivo no es PDF
- `tamano_excedido`: Archivo supera 10 MB
- `archivo_corrupto`: PDF dañado o ilegible
- `campos_faltantes`: Información del formulario incompleta

### **Salidas (Response JSON)**
```json
{
  "success": true,
  "mensaje": "Notificación enviada correctamente",
  "destinatario": "juan.perez@estudiante.unab.cl",
  "tipoError": "formato_incorrecto",
  "timestamp": "2025-11-12T14:30:00Z"
}
```

### **Salida Error (Response JSON)**
```json
{
  "success": false,
  "error": "Datos de entrada inválidos",
  "detalles": "Falta campo requerido: estudiante.email",
  "code": 400
}
```

## 🔄 **Flujo del Proceso**

1. **Webhook-HU005** → Recibe notificación de error vía POST desde HU-004
2. **Function-ValidarEntrada** → Valida que existan campos obligatorios
3. **IF-DatosValidos** → Bifurca flujo: válidos continúan, inválidos retornan error 400
4. **Function-SeleccionarTemplate** → Determina qué template HTML usar según tipo error
5. **Function-GenerarEmail** → Construye el HTML personalizado con datos del estudiante
6. **Email-Correccion** → Envía email vía SMTP
7. **IF-EmailEnviado** → Verifica éxito del envío
8. **Sheets-LogExito** → Registra envío exitoso en Google Sheets
9. **Respond-Confirmacion** → Retorna HTTP 200 con confirmación
10. **Sheets-LogErrorSMTP** (rama error) → Registra falla SMTP si ocurre
11. **Respond-ErrorSMTP** → Retorna HTTP 500 si falla envío

## 📧 **Templates de Email**

### **Template 1: Formato Incorrecto**
**Asunto:** Corrección requerida: Formato de archivo - Solicitud {idSolicitud}

**Contenido:**
- Saludo personalizado con nombre del estudiante
- Explicación del error: "El archivo enviado no está en formato PDF"
- Nombre del archivo rechazado
- Instrucciones: "Por favor, convierta su documento a PDF"
- Herramientas sugeridas: Convertidores online, "Guardar como PDF"
- Link para reenviar documentación
- Datos de contacto mesa de ayuda

### **Template 2: Tamaño Excedido**
**Asunto:** Corrección requerida: Tamaño de archivo - Solicitud {idSolicitud}

**Contenido:**
- Saludo personalizado
- Explicación: "El archivo supera el tamaño máximo de 10 MB"
- Tamaño actual vs. tamaño máximo permitido
- Instrucciones: "Comprima el PDF o divídalo en varios archivos"
- Herramientas sugeridas: Adobe Acrobat, Smallpdf.com
- Link para reenviar
- Contacto soporte

### **Template 3: Archivo Corrupto**
**Asunto:** Corrección requerida: Archivo dañado - Solicitud {idSolicitud}

**Contenido:**
- Saludo personalizado
- Explicación: "El archivo PDF está corrupto y no puede ser procesado"
- Posibles causas: descarga incompleta, error al guardar
- Instrucciones: "Genere nuevamente el PDF o use el original"
- Cómo verificar: "Intente abrirlo en su computador"
- Link para reenviar
- Contacto soporte

### **Template 4: Campos Faltantes**
**Asunto:** Corrección requerida: Información incompleta - Solicitud {idSolicitud}

**Contenido:**
- Saludo personalizado
- Explicación: "La solicitud está incompleta"
- Lista de campos faltantes (bullet points)
- Instrucciones: "Complete todos los campos obligatorios"
- Link al formulario
- Contacto soporte

## ❌ **Manejo de Errores**

### **Error: Datos de Entrada Inválidos**
- **Trigger:** Falta campo obligatorio (idSolicitud, estudiante.email, error.tipo)
- **Response:** HTTP 400 con mensaje descriptivo
- **Action:** No se procesa, retorna inmediatamente
- **Log:** Registra en Sheets hoja "Logs_Errores"

### **Error: Tipo de Error No Reconocido**
- **Trigger:** error.tipo no está en lista permitida
- **Response:** HTTP 400 con lista de tipos válidos
- **Action:** No se envía email
- **Log:** Registra error de validación

### **Error: Falla en Envío SMTP**
- **Trigger:** Error de conexión, credenciales inválidas, servidor SMTP caído
- **Response:** HTTP 500 con mensaje técnico
- **Action:** Log detallado del error para debugging
- **Retry:** No hay reintentos automáticos (evitar spam)
- **Notificación:** Se podría notificar al administrador (futuro)

### **Error: Email Estudiante Inválido**
- **Trigger:** Formato de email incorrecto
- **Response:** HTTP 400 con mensaje de validación
- **Action:** No se intenta envío
- **Log:** Registra email inválido para corrección manual

## 🧪 **Datos de Prueba**

### **Caso Válido: Formato Incorrecto**
```json
{
  "idSolicitud": "SOL-12345678-1699888000",
  "estudiante": {
    "nombre": "María González Silva",
    "rut": "19.876.543-2",
    "email": "maria.gonzalez@estudiante.unab.cl"
  },
  "error": {
    "tipo": "formato_incorrecto",
    "mensaje": "Archivo en formato Word detectado",
    "detalles": {
      "archivoNombre": "certificado_notas.docx",
      "archivoTipo": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      "tamanoMB": "1.8",
      "motivoRechazo": "Solo se aceptan archivos PDF"
    }
  }
}
```

### **Caso Válido: Tamaño Excedido**
```json
{
  "idSolicitud": "SOL-98765432-1699888100",
  "estudiante": {
    "nombre": "Pedro Ramírez Torres",
    "rut": "15.234.567-8",
    "email": "pedro.ramirez@estudiante.unab.cl"
  },
  "error": {
    "tipo": "tamano_excedido",
    "mensaje": "Archivo supera límite de tamaño",
    "detalles": {
      "archivoNombre": "programa_completo.pdf",
      "archivoTipo": "application/pdf",
      "tamanoMB": "15.8",
      "motivoRechazo": "El tamaño máximo permitido es 10 MB"
    }
  }
}
```

### **Caso Inválido: Datos Incompletos**
```json
{
  "idSolicitud": "SOL-TEST-001",
  "estudiante": {
    "nombre": "Ana Torres"
  },
  "error": {
    "tipo": "formato_incorrecto"
  }
}
```
**Resultado esperado:** HTTP 400 - "Falta campo requerido: estudiante.email"

### **Caso Borde: Email con Caracteres Especiales**
```json
{
  "idSolicitud": "SOL-11223344-1699888200",
  "estudiante": {
    "nombre": "José María O'Connor-Fernández",
    "rut": "16.789.012-3",
    "email": "jose.maria.oconnor@estudiante.unab.cl"
  },
  "error": {
    "tipo": "campos_faltantes",
    "mensaje": "Formulario incompleto",
    "detalles": {
      "archivoNombre": "",
      "camposFaltantes": ["Carrera", "Asignatura a convalidar", "Institución de origen"],
      "motivoRechazo": "Debe completar todos los campos obligatorios"
    }
  }
}
```

## 🔧 **Configuración Técnica**

### **Webhook Endpoint**
- **URL:** `http://localhost:5678/webhook/hu005-notificacion-correccion`
- **Método:** POST
- **Content-Type:** application/json
- **Autenticación:** Ninguna (interno)
- **Timeout:** 30 segundos

### **Integración con HU-004**
HU-004 debe invocar este webhook cuando detecte errores:
```javascript
// Desde HU-004 o HU-001, nodo HTTP Request
POST http://localhost:5678/webhook/hu005-notificacion-correccion
Body: {
  idSolicitud: "...",
  estudiante: {...},
  error: {...}
}
```

### **SMTP Configuración**
- **Servidor:** smtp.gmail.com
- **Puerto:** 465 (SSL) o 587 (TLS)
- **Credenciales:** Configuradas en n8n (id: 5PwfuVROJgdj9gpi)
- **From:** maudevchile@gmail.com
- **From Name:** Sistema de Convalidaciones UNAB

### **Google Sheets Logging**
**Hoja "Logs_HU005":**
| Timestamp | ID_Solicitud | Email_Destino | Tipo_Error | Estado_Envio | Mensaje |
|-----------|--------------|---------------|------------|--------------|---------|
| 2025-11-12T10:30:00 | SOL-123... | juan@... | formato_incorrecto | Exitoso | Email enviado OK |

### **Nomenclatura de Nodos n8n**
- `Webhook-HU005` (Trigger webhook)
- `Function-ValidarEntrada` (Validation)
- `IF-DatosValidos` (Decision)
- `Function-SeleccionarTemplate` (Logic)
- `Function-GenerarEmail` (Transformation)
- `Email-Correccion` (SMTP Send)
- `IF-EmailEnviado` (Decision)
- `Sheets-LogExito` (Google Sheets)
- `Sheets-LogErrorSMTP` (Google Sheets error logging)
- `Function-LogErrorSMTP` (Prepare error data)
- `Respond-Confirmacion` (HTTP Response 200)
- `Respond-ErrorEntrada` (HTTP Response 400)
- `Respond-ErrorSMTP` (HTTP Response 500)

## 📈 **Métricas de Éxito**
- ✅ 100% de notificaciones válidas enviadas
- ✅ <3 segundos tiempo de respuesta del webhook
- ✅ 0% pérdida de notificaciones
- ✅ Emails entregados en <10 segundos
- ✅ Tasa de rebote <5%
- ✅ 100% de errores SMTP registrados en logs

## 🔗 **Dependencias**
- **HU-001:** Proporciona datos del estudiante (nombre, RUT, email)
- **HU-004:** Activa este flujo cuando detecta errores de validación
- **SMTP Gmail:** Requiere credenciales configuradas y contraseña de aplicación
- **Google Sheets API:** Para logging (opcional pero recomendado)
- **n8n:** Versión 1.0+ con soporte para HTTP Request node v4.2

## 🔄 **Integración con Otros Workflows**

### **Desde HU-001 (via HU-004):**
```
HU-001 → Validar PDF → Error detectado → HTTP Request → HU-005
```

### **Nodo HTTP Request en HU-001:**
```json
{
  "method": "POST",
  "url": "http://localhost:5678/webhook/hu005-notificacion-correccion",
  "jsonBody": {
    "idSolicitud": "={{$json.id}}",
    "estudiante": {
      "nombre": "={{$json.nombre}}",
      "rut": "={{$json.rut}}",
      "email": "={{$json.email}}"
    },
    "error": {
      "tipo": "={{$json.tipoError}}",
      "mensaje": "={{$json.mensajeError}}",
      "detalles": "={{$json.detallesError}}"
    }
  }
}
```

## 📝 **Notas de Implementación**
- Los templates HTML están embebidos en el nodo Function-GenerarEmail
- Se usa CSS inline para compatibilidad con clientes de email
- El sistema es stateless: no guarda estado entre ejecuciones
- Cada invocación del webhook es independiente
- No hay cola de reintentos: si falla SMTP, se registra y termina
- Los logs en Sheets son para auditoría, no afectan el flujo

## ⚠️ **Consideraciones de Seguridad**
- El webhook NO requiere autenticación (uso interno)
- En producción considerar: API Key, IP whitelist, o autenticación básica
- Credenciales SMTP nunca se exponen en JSON
- Los emails NO contienen información sensible (solo ID público)
- Sanitización de inputs para prevenir inyección HTML en emails

## 🚀 **Mejoras Futuras (Backlog)**
- [ ] Sistema de reintentos automáticos para fallos SMTP
- [ ] Notificación al admin cuando falla envío
- [ ] Plantillas editables desde interfaz (no hardcodeadas)
- [ ] Soporte para múltiples idiomas (ES/EN)
- [ ] Tracking de apertura de emails
- [ ] Dashboard de métricas de notificaciones

---
**Versión:** 1.0  
**Fecha:** 12 noviembre 2025  
**Responsable:** Equipo Desarrollo n8n  
**Estado:** Implementado y probado
