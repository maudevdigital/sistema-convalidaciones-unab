# HU-05: Notificación al Estudiante para Corrección de Documentación - Ficha Técnica

## 📋 **Historia de Usuario**

**Como** estudiante  
**Quiero** recibir una notificación automática si la documentación que envié es incorrecta  
**Para que** pueda corregir y enviar mi solicitud sin tener que iniciar el trámite desde cero

## 🎯 **Objetivo**
Implementar un flujo automatizado que detecte rechazos de documentación en HU-004 y notifique automáticamente al estudiante con un email explicativo que incluya el motivo del rechazo y los pasos para corregir.

## ✅ **Criterios de Aceptación (CA)**

### **CA1: Detección de Rechazo de Documentación**
- **Given:** Una solicitud ha fallado la validación de documentos en HU-004
- **When:** El sistema detecta el error de validación (formato, tamaño, corrupción)
- **Then:** Se activa automáticamente el flujo de notificación HU-005
- **And:** Se capturan los detalles del error (tipo, motivo, ID solicitud, email estudiante)

### **CA2: Redacción Automática del Email de Corrección**
- **Given:** Se ha detectado un error de validación de documentos
- **When:** El sistema procesa el tipo de error detectado
- **Then:** Se genera automáticamente un email con template predefinido según tipo error
- **And:** El email incluye: motivo rechazo, instrucciones corrección, link reenvío, datos de contacto

### **CA3: Envío de Email al Estudiante**
- **Given:** El email de corrección ha sido generado correctamente
- **When:** El sistema procede al envío vía SMTP
- **Then:** El email se envía a la dirección proporcionada por el estudiante en HU-001
- **And:** Se registra el evento en Google Sheets hoja "Logs" con timestamp, ID, tipo_error, email_enviado
- **And:** Se retorna confirmación de envío exitoso al workflow

## 📊 **Entradas y Salidas**

### **Entradas (Input desde HU-004)**
```json
{
  "idSolicitud": "SOL-12345678-1699564800000",
  "estudiante": {
    "nombre": "María Elena Rodríguez",
    "rut": "20.111.222-3",
    "email": "maria.elena@estudiante.unab.cl"
  },
  "error": {
    "tipo": "formato_incorrecto | tamano_excedido | archivo_corrupto | campos_faltantes",
    "mensaje": "Descripción específica del error",
    "detalles": {
      "archivoNombre": "certificado.docx",
      "archivoTipo": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      "tamanoMB": 15.5,
      "motivoRechazo": "Solo se aceptan archivos PDF"
    }
  },
  "timestamp": "2025-11-09T14:30:00Z"
}
```

### **Salidas (Response JSON)**
```json
{
  "success": true,
  "idSolicitud": "SOL-12345678-1699564800000",
  "emailEnviado": true,
  "destinatario": "maria.elena@estudiante.unab.cl",
  "tipoError": "formato_incorrecto",
  "templateUtilizado": "template_formato_incorrecto",
  "timestamp": "2025-11-09T14:30:15Z",
  "logRegistrado": true,
  "mensaje": "Email de corrección enviado exitosamente"
}
```

## 🔄 **Flujo del Proceso**

```
1. IF-ValidacionDoc (desde HU-004)
   ↓ (Si error detectado)
2. Function-PrepararDatos
   ↓
3. Function-SeleccionarTemplate
   ↓
4. Function-RedactarEmail
   ↓
5. Email-Correccion (SMTP)
   ↓
6. DB-Log (Google Sheets)
   ↓
7. Respond-Confirmacion
```

## 🎨 **Templates de Email**

### **Template 1: Formato Incorrecto**
**Asunto:** Corrección Requerida - Formato de Documento Incorrecto

**Cuerpo:**
```
Estimado/a [NOMBRE_ESTUDIANTE],

Hemos recibido tu solicitud de convalidación (ID: [ID_SOLICITUD]), sin embargo, 
no podemos procesarla debido a que el documento adjunto no está en el formato correcto.

📌 PROBLEMA DETECTADO:
- Archivo recibido: [NOMBRE_ARCHIVO]
- Formato detectado: [TIPO_ARCHIVO]
- Motivo rechazo: Solo se aceptan archivos PDF

✅ CÓMO CORREGIR:
1. Convierte tu documento a formato PDF
2. Verifica que el archivo no supere 10 MB
3. Reenvía tu solicitud haciendo clic aquí: [LINK_REENVIO]

📧 ¿NECESITAS AYUDA?
Contacta a nuestro equipo: convalidaciones@unab.cl

Saludos cordiales,
Sistema de Convalidaciones Académicas
Universidad Andrés Bello
```

### **Template 2: Tamaño Excedido**
**Asunto:** Corrección Requerida - Archivo Demasiado Grande

**Cuerpo:**
```
Estimado/a [NOMBRE_ESTUDIANTE],

Hemos recibido tu solicitud de convalidación (ID: [ID_SOLICITUD]), sin embargo, 
no podemos procesarla debido a que el archivo adjunto supera el tamaño máximo permitido.

📌 PROBLEMA DETECTADO:
- Archivo recibido: [NOMBRE_ARCHIVO]
- Tamaño actual: [TAMANO_MB] MB
- Tamaño máximo: 10 MB

✅ CÓMO CORREGIR:
1. Comprime tu archivo PDF (puedes usar herramientas online gratuitas)
2. Verifica que el tamaño final sea menor a 10 MB
3. Reenvía tu solicitud haciendo clic aquí: [LINK_REENVIO]

💡 SUGERENCIAS:
- Reduce la calidad de imágenes en el PDF
- Elimina páginas innecesarias
- Usa un compresor de PDF online

📧 ¿NECESITAS AYUDA?
Contacta a nuestro equipo: convalidaciones@unab.cl

Saludos cordiales,
Sistema de Convalidaciones Académicas
Universidad Andrés Bello
```

### **Template 3: Archivo Corrupto**
**Asunto:** Corrección Requerida - Archivo No Puede Ser Leído

**Cuerpo:**
```
Estimado/a [NOMBRE_ESTUDIANTE],

Hemos recibido tu solicitud de convalidación (ID: [ID_SOLICITUD]), sin embargo, 
no podemos procesarla debido a que el archivo adjunto no puede ser leído correctamente.

📌 PROBLEMA DETECTADO:
- Archivo recibido: [NOMBRE_ARCHIVO]
- Error: El archivo está corrupto o dañado

✅ CÓMO CORREGIR:
1. Verifica que el archivo PDF se abra correctamente en tu computador
2. Si el archivo está dañado, genera uno nuevo desde el documento original
3. Asegúrate de que el archivo se descargue/exporte completamente
4. Reenvía tu solicitud haciendo clic aquí: [LINK_REENVIO]

💡 SUGERENCIAS:
- Genera el PDF nuevamente desde el documento original
- Verifica la integridad del archivo antes de enviar
- Usa herramientas confiables para generar PDFs

📧 ¿NECESITAS AYUDA?
Contacta a nuestro equipo: convalidaciones@unab.cl

Saludos cordiales,
Sistema de Convalidaciones Académicas
Universidad Andrés Bello
```

### **Template 4: Campos Faltantes**
**Asunto:** Corrección Requerida - Información Incompleta

**Cuerpo:**
```
Estimado/a [NOMBRE_ESTUDIANTE],

Hemos recibido tu solicitud de convalidación (ID: [ID_SOLICITUD]), sin embargo, 
no podemos procesarla debido a que falta información requerida.

📌 CAMPOS FALTANTES:
[LISTA_CAMPOS_FALTANTES]

✅ CÓMO CORREGIR:
1. Completa todos los campos obligatorios del formulario
2. Verifica que hayas adjuntado el certificado de notas en PDF
3. Reenvía tu solicitud haciendo clic aquí: [LINK_REENVIO]

📝 CAMPOS OBLIGATORIOS:
- Nombre completo
- RUT
- Carrera actual
- Asignatura a convalidar
- Institución de origen
- Certificado de notas (PDF)

📧 ¿NECESITAS AYUDA?
Contacta a nuestro equipo: convalidaciones@unab.cl

Saludos cordiales,
Sistema de Convalidaciones Académicas
Universidad Andrés Bello
```

## ❌ **Manejo de Errores**

### **Error: SMTP Connection Failed**
- **Trigger:** No se puede conectar al servidor SMTP
- **Response:** HTTP 500 + mensaje técnico
- **Action:** 
  - Registrar error en Logs con detalles
  - Reintentar envío 3 veces con intervalo de 30 segundos
  - Si persiste: notificar a admin y marcar como "pendiente_reenvio"

### **Error: Credenciales SMTP Inválidas**
- **Trigger:** Autenticación SMTP falla
- **Response:** HTTP 500 + mensaje credenciales
- **Action:**
  - Registrar error crítico en Logs
  - Notificar inmediatamente a admin
  - Pausar workflow hasta corrección

### **Error: Timeout al Enviar Email**
- **Trigger:** Email no se envía en tiempo límite (30 segundos)
- **Response:** HTTP 408 + mensaje timeout
- **Action:**
  - Registrar timeout en Logs
  - Reintentar envío 2 veces
  - Si persiste: marcar como "pendiente_reenvio"

### **Error: Estudiante Sin Email**
- **Trigger:** Campo email vacío o inválido en datos de entrada
- **Response:** HTTP 400 + mensaje email faltante
- **Action:**
  - Registrar error en Logs
  - No intentar envío
  - Notificar a admin para contacto manual

### **Error: Registro en Logs Falla**
- **Trigger:** No se puede escribir en Google Sheets
- **Response:** Advertencia (no bloquea flujo)
- **Action:**
  - Continuar con envío de email
  - Registrar error localmente en n8n
  - Notificar a admin para verificación

## 🧪 **Datos de Prueba**

### **Caso Válido - Formato Incorrecto**
```json
{
  "idSolicitud": "SOL-12345678-TEST001",
  "estudiante": {
    "nombre": "Juan Pérez González",
    "rut": "19.876.543-2",
    "email": "juan.perez@test.unab.cl"
  },
  "error": {
    "tipo": "formato_incorrecto",
    "mensaje": "Formato de archivo no válido",
    "detalles": {
      "archivoNombre": "certificado.docx",
      "archivoTipo": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      "motivoRechazo": "Solo se aceptan archivos PDF"
    }
  }
}
```

### **Caso Válido - Tamaño Excedido**
```json
{
  "idSolicitud": "SOL-98765432-TEST002",
  "estudiante": {
    "nombre": "María Silva Torres",
    "rut": "18.234.567-8",
    "email": "maria.silva@test.unab.cl"
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
  }
}
```

### **Caso Inválido - Sin Email**
```json
{
  "idSolicitud": "SOL-11223344-TEST003",
  "estudiante": {
    "nombre": "Pedro Ramírez",
    "rut": "20.111.222-3",
    "email": ""
  },
  "error": {
    "tipo": "formato_incorrecto"
  }
}
```

## 🔧 **Configuración Técnica**

### **Integración con HU-004**
- **Punto de Conexión:** Rama "error" del nodo IF-ValidacionDoc
- **Datos Transferidos:** idSolicitud, estudiante (nombre, rut, email), error (tipo, detalles)
- **Validación:** Verificar que todos los campos requeridos estén presentes

### **SMTP Configuration**
- **Host:** smtp.gmail.com (producción) / smtp.ethereal.email (testing)
- **Port:** 587 (STARTTLS) / 465 (SSL)
- **Autenticación:** Usuario + App Password (Gmail) / Usuario + Password (Ethereal)
- **Timeout:** 30 segundos

### **Google Sheets Estructura (Hoja "Logs")**
Agregar estas columnas adicionales:
- **tipo_notificacion:** "error_documentacion"
- **email_enviado:** "si" / "no"
- **template_utilizado:** nombre del template
- **destinatario:** email del estudiante
- **intentos_envio:** número de reintentos
- **estado_envio:** "exitoso" / "fallido" / "pendiente"

### **Nomenclatura de Nodos n8n**
- `IF-ValidacionDoc` (desde HU-004)
- `Function-PrepararDatos` (extrae y valida datos)
- `Function-SeleccionarTemplate` (según tipo error)
- `Function-RedactarEmail` (reemplaza variables)
- `Email-Correccion` (envío SMTP)
- `DB-Log` (registro Google Sheets)
- `Respond-Confirmacion` (response final)

## 📈 **Métricas de Éxito**
- ✅ 100% de emails de error enviados correctamente
- ✅ Tiempo de envío < 10 segundos desde detección error
- ✅ 100% de eventos registrados en Logs
- ✅ 0% pérdida de datos entre HU-004 y HU-005
- ✅ Templates correctos según tipo error (4/4)
- ✅ Tasa de reenvío exitoso > 80%

## 🔗 **Dependencias**
- ✅ HU-001: Recepción de solicitud (proporciona datos estudiante)
- ⏳ HU-004: Verificación de documentos (activa HU-005 en caso error)
- ✅ Google Sheets API configurado (hoja "Logs")
- ✅ SMTP configurado (Gmail App Password o Ethereal)
- ✅ n8n versión 1.113.3+

---

**Versión:** 1.0  
**Fecha:** 9 noviembre 2025  
**Responsable:** Equipo Desarrollo Sprint 2  
**Estado:** ✅ Ficha técnica completa
