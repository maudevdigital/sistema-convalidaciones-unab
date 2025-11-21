# 📋 Workflow Integrado: Sistema de Convalidaciones UNAB

**Archivo:** `HU-001-003-INTEGRADO.json`  
**Fecha de creación:** 18 de noviembre de 2025  
**Versión:** 1.0

---

## 🎯 Descripción General

Este workflow integra las funcionalidades de **HU-001** (Recepción y Validación) con **HU-003** (Flujo de Decisión Académica), creando un sistema completo de gestión de convalidaciones académicas según los requisitos del proyecto de práctica.

---

## 🔄 Flujo Completo del Sistema

### **FASE 1: Recepción de Solicitud** (Webhook Principal)

#### **Webhook - Recepción Solicitud**
- **Endpoint:** `http://localhost:5678/webhook/solicitud-convalidacion`
- **Método:** POST
- **Campos requeridos:**
  ```json
  {
    "nombre": "Nombre completo del estudiante",
    "rut": "12.345.678-9",
    "carrera": "Ingeniería Civil en Informática",
    "asignatura": "Programación Orientada a Objetos",
    "institucionOrigen": "Universidad de Chile",
    "email": "estudiante@ejemplo.com",
    "directorEmail": "director@unab.cl",
    "file": {
      "filename": "certificado.pdf",
      "data": "base64_encoded_data",
      "mimeType": "application/pdf"
    }
  }
  ```

### **FASE 2: Validaciones** (Nodos de Function)

#### ✅ **1. Validación de Campos Obligatorios**
- Verifica que todos los campos requeridos estén presentes
- Genera ID único: `SOL-{RUT}-{timestamp}`
- Estado inicial: `Pendiente`

#### ✅ **2. Validación de RUT**
- Valida formato chileno (12.345.678-9)
- Verifica dígito verificador usando algoritmo módulo 11
- Rechaza si el RUT es inválido

#### ✅ **3. Validación de Emails**
- Valida formato del email del estudiante
- Valida formato del email del director
- Verifica longitud máxima (254 caracteres)

#### ✅ **4. Validación de PDF**
- Verifica extensión `.pdf`
- Valida tipo MIME `application/pdf`
- Rechaza otros formatos (docx, jpg, etc.)

#### ✅ **5. Validación de Tamaño**
- Tamaño máximo: **10 MB**
- Calcula tamaño desde base64
- Rechaza archivos mayores

### **FASE 3: Almacenamiento y Registro**

#### **Si todas las validaciones pasan:**

1. **Code - Convertir a Binario**
   - Convierte archivo base64 a formato binario
   - Prepara para subida a Google Drive

2. **Drive - Subir PDF**
   - Sube archivo a Google Drive
   - Genera link de visualización
   - Almacena ID del archivo

3. **DB - Registro Solicitud** (Google Sheets)
   - Registra en hoja "Solicitudes":
     ```
     | id | fecha | estudiante | rut | carrera | asignatura | 
     | institucionOrigen | documentos | linkDrive | driveFileId | 
     | tamanoMB | email | directorEmail | estado |
     ```

4. **DB - Log** (Google Sheets)
   - Registra evento en hoja "Logs":
     ```
     | timestamp | id | evento | estudiante | estado | detalles |
     ```

5. **Emails Simultáneos:**
   - **Email - Confirmación Estudiante:**
     ```
     Asunto: Confirmación de Recepción - Solicitud {ID}
     Contenido: Confirmación de recepción con próximos pasos
     ```
   - **Email - Notificación Director:**
     ```
     Asunto: Nueva Solicitud de Convalidación - {Nombre}
     Contenido: Datos del estudiante + Link a Drive + Botones de decisión
     ```

6. **Respuesta HTTP:**
   ```json
   {
     "success": true,
     "message": "Solicitud recibida y procesada correctamente",
     "id": "SOL-12345678-1234567890",
     "estado": "Pendiente",
     "proximosPasos": "Recibirá notificación cuando el director tome una decisión",
     "tiempoEstimado": "5-10 días hábiles"
   }
   ```

#### **Si alguna validación falla:**

- **Error de Campos/RUT/Email:**
  - Registra log de error
  - Retorna mensaje descriptivo
  - NO almacena en Drive ni Sheets

- **Error de PDF/Tamaño:**
  - Envía email al estudiante con instrucciones de corrección
  - Registra log de error
  - Retorna mensaje de error

---

### **FASE 4: Decisión del Director** (Flujo HU-003)

#### **Webhook - Decisión Director**
- **Endpoint:** `http://localhost:5678/webhook/decision-director`
- **Método:** GET
- **Parámetros:**
  ```
  ?decision=aprobada&solicitudId=SOL-12345678-1234567890
  ?decision=rechazada&motivo=Documentacion%20Incompleta&solicitudId=SOL-12345678-1234567890
  ```

#### **Proceso de Decisión:**

1. **Function - Procesar Decisión**
   - Extrae parámetros de la URL
   - Decodifica motivo de rechazo
   - Registra timestamp

2. **DB - Actualizar Estado**
   - Actualiza estado en Google Sheets (Solicitudes)
   - Cambia de "Pendiente" a "aprobada" o "rechazada"

3. **DB - Obtener Datos Solicitud**
   - Recupera datos completos de la solicitud
   - Necesarios para generar acta y enviar email

4. **Switch - Decisión**
   - Bifurca el flujo según decisión:
     - **Salida 0:** Aprobada
     - **Salida 1:** Rechazada

---

### **FASE 5: Generación de Acta PDF**

#### **Si APROBADA:**

1. **Function - Generar HTML Aprobada**
   - Genera HTML con acta de aprobación
   - Incluye datos del estudiante
   - Mensaje de felicitación

2. **API - Convertir HTML a PDF Aprobada**
   - Llama a API2PDF
   - Convierte HTML a PDF profesional

3. **HTTP - Descargar PDF Aprobada**
   - Descarga PDF generado
   - Prepara como adjunto

4. **Email - Notificación Aprobada**
   - Asunto: ✅ Solicitud Aprobada
   - Adjunto: Acta en PDF
   - Mensaje de felicitaciones

#### **Si RECHAZADA:**

1. **Function - Generar HTML Rechazada**
   - Genera HTML con acta de rechazo
   - Incluye motivo del rechazo

2. **API - Convertir HTML a PDF Rechazada**
   - Llama a API2PDF
   - Convierte HTML a PDF

3. **HTTP - Descargar PDF Rechazada**
   - Descarga PDF generado

4. **Email - Notificación Rechazada**
   - Asunto: ❌ Solicitud Rechazada
   - Adjunto: Acta en PDF
   - Motivo del rechazo

---

### **FASE 6: Registro Final y Confirmación**

1. **Function - Log Decisión**
   - Registra decisión tomada en Logs
   - Timestamp de decisión
   - Motivo (si aplica)

2. **DB - Log**
   - Guarda log en Google Sheets

3. **Respond - Confirmación Decisión**
   - Responde al director con página HTML de confirmación
   - Muestra que la decisión fue registrada
   - Indica que el estudiante recibirá notificación

---

## 📊 Estructura de Datos

### **Google Sheets - Hoja "Solicitudes"**
```
| Columna           | Tipo   | Descripción                        |
|-------------------|--------|------------------------------------|
| id                | String | ID único (SOL-XXXXXXXX-TIMESTAMP)  |
| fecha             | Date   | Fecha de recepción                 |
| estudiante        | String | Nombre completo                    |
| rut               | String | RUT del estudiante                 |
| carrera           | String | Carrera actual                     |
| asignatura        | String | Asignatura a convalidar            |
| institucionOrigen | String | Universidad de origen              |
| documentos        | String | Nombre del archivo PDF             |
| linkDrive         | URL    | Link a Google Drive                |
| driveFileId       | String | ID del archivo en Drive            |
| tamanoMB          | Number | Tamaño del archivo en MB           |
| email             | Email  | Email del estudiante               |
| directorEmail     | Email  | Email del director                 |
| estado            | String | Pendiente/aprobada/rechazada       |
```

### **Google Sheets - Hoja "Logs"**
```
| Columna    | Tipo   | Descripción                    |
|------------|--------|--------------------------------|
| timestamp  | Date   | Fecha y hora del evento        |
| id         | String | ID de la solicitud             |
| evento     | String | Tipo de evento                 |
| estudiante | String | Nombre del estudiante          |
| estado     | String | Estado de la solicitud         |
| detalles   | String | Información adicional          |
```

---

## 🔧 Configuración Requerida

### **1. Credenciales de Google Drive**
- **Nodo:** "Drive - Subir PDF"
- **Tipo:** OAuth2
- **Permisos:** Subir archivos
- **ID:** `PENDIENTE` (reemplazar)

### **2. Credenciales de Google Sheets**
- **Nodos:** "DB - Registro Solicitud", "DB - Log", "DB - Actualizar Estado", "DB - Obtener Datos Solicitud"
- **Tipo:** OAuth2
- **Permisos:** Leer y escribir
- **Spreadsheet ID:** `1FWnWVXKy8mKIbO2JloHav9y7rYJYpVIqM1qcVhtg0yY`

### **3. Credenciales SMTP**
- **Nodos:** Todos los nodos de Email
- **Servidor:** Gmail SMTP
- **Email:** `maudevchile@gmail.com`
- **ID:** `5PwfuVROJgdj9gpi`

### **4. Credenciales API2PDF**
- **Nodos:** "API - Convertir HTML a PDF Aprobada", "API - Convertir HTML a PDF Rechazada"
- **Tipo:** Header Auth
- **Header:** `Authorization`
- **Valor:** API Key de API2PDF
- **ID:** `PENDIENTE` (reemplazar)
- **Obtener en:** https://portal.api2pdf.com

---

## ✅ Casos de Uso

### **Caso 1: Solicitud Exitosa**
```
1. Estudiante envía formulario con datos correctos
2. Sistema valida campos, RUT, email, PDF
3. Archivo se sube a Drive
4. Se registra en Sheets
5. Director recibe email con links de decisión
6. Estudiante recibe confirmación
7. Estado: Pendiente
```

### **Caso 2: Error en Validación**
```
1. Estudiante envía formulario con RUT inválido
2. Sistema detecta error en validación
3. Se registra log de error
4. Retorna mensaje de error
5. NO se almacena nada
6. NO se envían emails
```

### **Caso 3: Error en PDF**
```
1. Estudiante adjunta archivo .docx
2. Sistema detecta formato incorrecto
3. Envía email al estudiante con instrucciones
4. Registra log de error
5. Retorna error 400
6. Estado: No registrada
```

### **Caso 4: Aprobación**
```
1. Director hace click en "Aprobar"
2. Sistema actualiza estado a "aprobada"
3. Genera HTML de acta aprobada
4. Convierte HTML a PDF
5. Envía email al estudiante con PDF adjunto
6. Registra log de decisión
7. Director ve confirmación en navegador
```

### **Caso 5: Rechazo**
```
1. Director hace click en "Rechazar - No Cumple Requisitos"
2. Sistema actualiza estado a "rechazada"
3. Captura motivo: "No Cumple Requisitos"
4. Genera HTML de acta rechazada con motivo
5. Convierte HTML a PDF
6. Envía email al estudiante con PDF adjunto
7. Registra log de decisión con motivo
```

---

## 🚀 Cómo Usar

### **1. Importar Workflow en n8n**
```bash
1. Abrir n8n: http://localhost:5678
2. Click en "Import workflow"
3. Seleccionar: sistema-final/workflows/HU-001-003-INTEGRADO.json
4. Click en "Import"
```

### **2. Configurar Credenciales**
```
✅ Google Drive OAuth2
✅ Google Sheets OAuth2 (ya configurado)
✅ SMTP Gmail (ya configurado)
⚠️ API2PDF Header Auth (PENDIENTE)
```

### **3. Configurar API2PDF**
```bash
1. Registrarse en: https://portal.api2pdf.com
2. Obtener API Key
3. En n8n:
   - Settings > Credentials
   - New Credential > Header Auth
   - Name: API2PDF Auth
   - Header Name: Authorization
   - Value: tu-api-key
4. Asignar a nodos "API - Convertir HTML a PDF"
```

### **4. Seleccionar Carpeta de Drive**
```
1. Abrir nodo "Drive - Subir PDF"
2. Click en "Select Folder"
3. Elegir carpeta destino
4. Guardar
```

### **5. Activar Workflow**
```
1. Click en toggle superior derecho
2. Verificar que esté en ON (verde)
3. Confirmar webhooks activos:
   - ✅ /webhook/solicitud-convalidacion
   - ✅ /webhook/decision-director
```

### **6. Probar con Formulario**
```bash
# Abrir formulario HTML
start sistema-final\formulario-convalidacion-unab.html

# O configurar formulario para apuntar a:
http://localhost:5678/webhook/solicitud-convalidacion
```

---

## 📧 Plantillas de Email

### **Email de Confirmación al Estudiante**
```
Asunto: Confirmación de Recepción - Solicitud SOL-XXXXX

Estimado/a [Nombre],

Hemos recibido correctamente su solicitud de convalidación:

📋 DATOS DE LA SOLICITUD:
• ID: SOL-XXXXX
• Fecha: 18/11/2025
• Asignatura: Programación Orientada a Objetos
• Institución: Universidad de Chile
• Estado: Pendiente de revisión

📅 PRÓXIMOS PASOS:
1. El Director de Carrera revisará su solicitud
2. Recibirá un email cuando haya una decisión
3. El proceso puede tomar entre 5-10 días hábiles

Saludos cordiales,
Sistema de Convalidaciones UNAB
```

### **Email de Notificación al Director**
```html
Asunto: Nueva Solicitud de Convalidación - [Nombre Estudiante]

<h3>Datos del Estudiante:</h3>
• Nombre: Lucas Maulen Rodriguez
• RUT: 12.345.678-5
• Carrera: Ingeniería Civil en Informática
• Asignatura: Programación Orientada a Objetos
• Institución: Universidad de Chile
• ID Solicitud: SOL-12345678-1234567890

<h3>Documentación:</h3>
[📄 Ver documentos en Drive]

Por favor, tome una decisión:
[✅ APROBAR SOLICITUD]

Opciones de Rechazo:
• [❌ Rechazar - Documentación Incompleta]
• [❌ Rechazar - No Cumple Requisitos]
• [❌ Rechazar - Otro Motivo]
```

### **Email de Aprobación al Estudiante**
```
Asunto: ✅ Solicitud Aprobada - Convalidación SOL-XXXXX

Estimado/a [Nombre],

¡Felicitaciones!

Nos complace informarte que tu solicitud de convalidación ha sido APROBADA.

Detalles:
• Asignatura: Programación Orientada a Objetos
• Institución de Origen: Universidad de Chile

Se adjunta el acta de resolución oficial.

Atentamente,
Administración Académica
Universidad Andrés Bello
```

### **Email de Rechazo al Estudiante**
```
Asunto: ❌ Solicitud Rechazada - Convalidación SOL-XXXXX

Estimado/a [Nombre],

Lamentamos informarte que tu solicitud de convalidación ha sido RECHAZADA.

Detalles:
• Asignatura: Programación Orientada a Objetos
• Motivo: Documentación Incompleta

Se adjunta el acta de resolución con los detalles.

Para más información, puedes contactar a la Dirección de Carrera.

Atentamente,
Administración Académica
Universidad Andrés Bello
```

---

## 🐛 Solución de Problemas

### **Problema: Webhook no responde**
```
Solución:
1. Verificar que el workflow esté ACTIVADO (toggle verde)
2. Revisar URL del webhook en el formulario
3. Verificar logs en n8n (Executions)
```

### **Problema: No se suben archivos a Drive**
```
Solución:
1. Verificar credenciales de Google Drive
2. Re-autenticar OAuth2
3. Verificar que la carpeta seleccionada exista
4. Verificar permisos de la cuenta
```

### **Problema: No se envían emails**
```
Solución:
1. Verificar credenciales SMTP
2. Revisar carpeta de SPAM
3. Verificar que el email del destinatario sea válido
4. Revisar logs de error en n8n
```

### **Problema: Error al generar PDF**
```
Solución:
1. Verificar API Key de API2PDF
2. Verificar que el HTML sea válido
3. Revisar límites de uso de la API
4. Ver error específico en logs de n8n
```

### **Problema: Links de decisión no funcionan**
```
Solución:
1. Verificar que el webhook /decision-director esté activo
2. Verificar formato de la URL
3. Verificar que solicitudId sea correcto
4. Revisar que el workflow esté activado
```

---

## 📈 Métricas y Monitoreo

### **Logs a Revisar:**
```
✅ Solicitudes Recibidas: Evento "Solicitud Recibida"
✅ Errores de Validación: Evento "Error de Validación"
✅ Errores de PDF: Evento "Error en Documento PDF"
✅ Decisiones Tomadas: Evento "Decisión Tomada"
```

### **Estados Posibles:**
```
• Pendiente: Esperando decisión del director
• aprobada: Solicitud aprobada
• rechazada: Solicitud rechazada
• Rechazada - PDF Inválido: Error en documento
```

---

## 🎯 Cumplimiento de Requisitos del Proyecto

| Requisito | Estado | Implementación |
|-----------|--------|----------------|
| ✅ Recepción de Solicitud (Webhook + Formulario) | ✅ Completo | Webhook POST con validaciones |
| ✅ Verificación Automática de Documentos | ✅ Completo | Validación PDF + tamaño |
| ✅ Almacenamiento en Drive | ✅ Completo | Google Drive upload |
| ✅ Notificación a Dirección de Carrera | ✅ Completo | Email con links de decisión |
| ✅ Flujo de Validación Académica | ✅ Completo | Webhook de decisión |
| ✅ Notificación Final al Estudiante | ✅ Completo | Email con PDF adjunto |
| ✅ Registro Histórico | ✅ Completo | Google Sheets (Solicitudes + Logs) |
| ✅ Generación de PDF | ✅ Completo | API2PDF con actas |

---

## 📝 Notas Adicionales

- El workflow usa **Google Sheets** como base de datos
- Los archivos se almacenan en **Google Drive**
- Las actas se generan con **API2PDF**
- Los emails se envían vía **Gmail SMTP**
- El sistema mantiene **trazabilidad completa** en Logs
- Todos los IDs son únicos y rastreables
- El flujo es **100% automatizado**

---

**Autor:** GitHub Copilot  
**Fecha:** 18 de noviembre de 2025  
**Versión:** 1.0  
**Proyecto:** Sistema de Convalidaciones Académicas UNAB
