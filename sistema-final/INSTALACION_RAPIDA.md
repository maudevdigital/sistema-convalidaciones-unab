# 🚀 Instalación Rápida - Sistema de Convalidaciones

**Tiempo estimado:** 15-20 minutos

---

## 📋 **Prerequisitos**

- ✅ n8n instalado y ejecutándose
- ✅ Cuenta de Google (Gmail)
- ✅ Cuenta de Google Drive
- ✅ Cuenta de Google Sheets
- ✅ Navegador web moderno

---

## 🎯 **Pasos de Instalación**

### **1. Importar Workflow en n8n** (5 min)

1. Abre n8n: `http://localhost:5678`
2. Haz clic en **"Workflows"** → **"Import from File"**
3. Selecciona: `sistema-final/workflows/workflow.json`
4. El workflow se importará con el nombre: **"Convalidaciones: HU-001 + HU-005"**

---

### **2. Configurar Credenciales Google** (10 min)

#### **A. Google Sheets (para registro de datos)**

1. En n8n, ve a **Settings** → **Credentials**
2. Haz clic en **"+ Add credential"**
3. Busca y selecciona **"Google Sheets OAuth2 API"**
4. Sigue el asistente de autorización de Google
5. Guarda con el nombre: **"Google Sheets account"**

#### **B. Google Drive (para almacenar PDFs)**

1. En **Credentials**, haz clic en **"+ Add credential"**
2. Busca y selecciona **"Google Drive OAuth2 API"**
3. Autoriza el acceso
4. Guarda con el nombre: **"Google Drive account"**

#### **C. SMTP (para enviar emails)**

⚠️ **Nota:** Si ya configuraste SMTP en HU-001, omite este paso.

1. En **Credentials**, haz clic en **"+ Add credential"**
2. Busca **"SMTP"**
3. Configura:
   ```
   Host: smtp.gmail.com
   Port: 587
   User: tu-email@gmail.com
   Password: [App Password de Gmail]
   ```
4. **Importante:** Necesitas una [App Password](https://support.google.com/accounts/answer/185833) de Gmail
5. Guarda con el nombre: **"SMTP account"**

---

### **3. Configurar Nodos del Workflow** (3 min)

#### **A. Nodo "Drive - Subir PDF"**

1. Abre el workflow importado
2. Haz doble clic en el nodo **"Drive - Subir PDF"**
3. En **"Credentials"**, selecciona: **"Google Drive account"** (la que creaste antes)
4. En **"Folder"**, haz clic en el selector y elige la carpeta de Drive donde guardar los PDFs
   - Puedes crear una carpeta nueva: `Convalidaciones/Documentos`
5. Haz clic en **"Execute Node"** para probar
6. Guarda el nodo

#### **B. Nodo "DB-Registro" (Google Sheets)**

1. Haz doble clic en **"DB-Registro"**
2. En **"Credentials"**, selecciona: **"Google Sheets account"**
3. En **"Document"**, selecciona tu hoja de cálculo:
   - Si no existe, crea una nueva: **"Sistema Convalidaciones Académicas"**
4. En **"Sheet"**, selecciona la pestaña: **"Solicitudes"**
   - Si no existe, créala con estas columnas:
     ```
     id | fecha | estudiante | rut | carrera | asignatura | institucionOrigen | documentos | linkDrive | driveFileId | tamanoMB | email | estado
     ```
5. Guarda el nodo

#### **C. Nodo "DB-Log" (Google Sheets)**

1. Haz doble clic en **"DB-Log"**
2. En **"Credentials"**, selecciona: **"Google Sheets account"**
3. En **"Document"**, selecciona la misma hoja: **"Sistema Convalidaciones Académicas"**
4. En **"Sheet"**, selecciona: **"Logs"**
   - Si no existe, créala con estas columnas:
     ```
     timestamp | id | evento | estudiante | estado | detalles
     ```
5. Guarda el nodo

#### **D. Nodos de Email**

Los nodos `Email-Confirmación` y `Email-Correccion` deben tener:
- **Credentials:** Selecciona **"SMTP account"**
- **From Email:** `maudevchile@gmail.com` (o tu email)

---

### **4. Activar el Workflow** (1 min)

1. En el workflow, activa el toggle **"Active"** (arriba a la derecha)
2. El webhook ahora está escuchando en:
   ```
   http://localhost:5678/webhook/solicitud-convalidacion
   ```

---

### **5. Configurar el Formulario HTML** (1 min)

1. Abre: `sistema-final/formulario-convalidacion-unab.html`
2. Si n8n está en localhost, **no necesitas cambiar nada**
3. Si n8n está en otro servidor, actualiza la línea 156:
   ```javascript
   const WEBHOOK_URL = 'https://tu-servidor.com/webhook/solicitud-convalidacion';
   ```

---

### **6. Probar el Sistema** (5 min)

#### **Test 1: Solicitud Exitosa**

1. Abre `formulario-convalidacion-unab.html` en tu navegador
2. Completa el formulario:
   ```
   Nombre: Juan Pérez
   RUT: 12345678-5
   Carrera: Ingeniería
   Asignatura: Programación
   Institución: Universidad de Chile
   Email: tu-email@gmail.com
   Archivo: [Selecciona un PDF < 10MB]
   ```
3. Haz clic en **"Enviar Solicitud"**
4. Deberías ver: ✅ **"¡Solicitud enviada exitosamente!"**
5. Revisa tu email: deberías recibir la confirmación
6. Verifica Google Sheets: debe aparecer un nuevo registro
7. Verifica Google Drive: debe estar el PDF subido

#### **Test 2: Error de Validación**

1. En el formulario, deja el campo **RUT** vacío
2. Intenta enviar
3. Deberías ver: ❌ **"Faltan campos obligatorios"**

#### **Test 3: Error de PDF**

1. Completa el formulario correctamente
2. Selecciona un archivo que **NO sea PDF** (por ejemplo, una imagen .jpg)
3. Deberías ver: ❌ **"Solo se aceptan archivos en formato PDF"**
4. Ahora selecciona un PDF > 10MB
5. Deberías ver: ❌ **"El archivo es muy grande"**

#### **Test 4: Notificación HU-005**

1. En n8n, ve al workflow
2. Busca el nodo **"HTTP-Notificar HU-005"**
3. Prueba manual con este JSON en el nodo **"Webhook-HU004"**:
   ```json
   {
     "idSolicitud": "SOL-TEST-001",
     "estudiante": {
       "nombre": "Test Usuario",
       "rut": "12345678-9",
       "email": "tu-email@gmail.com"
     },
     "error": {
       "tipo": "formato_incorrecto",
       "mensaje": "El archivo no es un PDF válido",
       "detalles": {
         "archivoNombre": "documento.docx",
         "archivoTipo": "application/msword",
         "motivoRechazo": "Formato incorrecto"
       }
     }
   }
   ```
4. Ejecuta el nodo
5. Deberías recibir un email con el template HTML de corrección

---

## ✅ **Verificación Final**

### **Checklist de Funcionalidades:**

- [ ] Formulario HTML se abre correctamente
- [ ] Validaciones del cliente funcionan (RUT, email, PDF)
- [ ] Webhook recibe los datos
- [ ] Validaciones del servidor funcionan
- [ ] PDF se sube a Google Drive
- [ ] Registro se guarda en Google Sheets
- [ ] Email de confirmación se envía
- [ ] Email de error (HU-005) se envía con template HTML
- [ ] Log se registra correctamente
- [ ] ID de solicitud se preserva en el flujo

---

## 🛠️ **Troubleshooting**

### **Problema: "Webhook no responde"**

**Solución:**
1. Verifica que n8n esté ejecutándose: `http://localhost:5678`
2. Verifica que el workflow esté **Activo** (toggle verde)
3. Revisa la URL del webhook en el HTML

### **Problema: "Error al subir a Drive"**

**Solución:**
1. Verifica las credenciales de Google Drive
2. Asegúrate de haber seleccionado una carpeta
3. Prueba el nodo manualmente: "Execute Node"

### **Problema: "No se envía email"**

**Solución:**
1. Verifica las credenciales SMTP
2. Si usas Gmail, asegúrate de tener una **App Password**
3. Revisa que el email de destino sea válido
4. Verifica la configuración de seguridad de Gmail

### **Problema: "ID de solicitud no aparece"**

**Solución:**
1. Verifica el nodo **"Sincronizar - Preservar Datos"**
2. Revisa los logs del workflow en n8n
3. Asegúrate de que el ID se genera en **"Function - Validar Campos"**

### **Problema: "HU-005 no se dispara"**

**Solución:**
1. Verifica que el nodo **"HTTP-Notificar HU-005"** esté conectado
2. Revisa que el webhook HU-005 esté activo
3. Prueba llamar al webhook HU-005 manualmente con curl:
   ```bash
   curl -X POST http://localhost:5678/webhook/hu005-notificacion-correccion \
     -H "Content-Type: application/json" \
     -d '{"idSolicitud":"TEST","estudiante":{"nombre":"Test","email":"test@test.com"},"error":{"tipo":"formato_incorrecto","mensaje":"Test"}}'
   ```

---

## 📚 **Recursos Adicionales**

- **Documentación completa:** Ver `ANALISIS_Y_MEJORAS.md`
- **Configuración SMTP Gmail:** `hu001/CONFIG-GMAIL-SMTP.md`
- **Tests completos:** `hu001/tests/` y `hu005/tests/`
- **Fichas técnicas:** 
  - `hu001/docs/HU-01_FICHA_TECNICA.md`
  - `hu005/docs/HU-05_FICHA_TECNICA.md`

---

## 🎉 **¡Listo!**

Tu sistema de convalidaciones está funcionando. Ahora puedes:

1. **Personalizar** los templates de email
2. **Ajustar** las validaciones según tus necesidades
3. **Monitorear** el uso en Google Sheets
4. **Escalar** agregando más validaciones (HU-004, etc.)

---

**¿Necesitas ayuda?**
- Revisa los logs en n8n: Click derecho en un nodo → "Show executions"
- Consulta `ANALISIS_Y_MEJORAS.md` para detalles técnicos
- Revisa la documentación de cada HU en sus carpetas

---

**Última actualización:** 10 de noviembre de 2025
