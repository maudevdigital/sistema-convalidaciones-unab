````markdown
# Configuración Local - HU-001 MEJORADO

## Variables de Entorno

```bash
# n8n
N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http
WEBHOOK_URL=http://localhost:5678/webhook/solicitud-convalidacion

# Google Sheets
GOOGLE_SHEET_ID=1FWnWVXKy8mKIbO2JloHav9y7rYJYpVIqM1qcVhtg0yY
SHEET_SOLICITUDES_ID=392534325
SHEET_LOGS_ID=0

# Google Drive
GOOGLE_DRIVE_FOLDER_ID=<TU_FOLDER_ID>
GOOGLE_DRIVE_FOLDER_NAME=Convalidaciones UNAB

# SMTP (Gmail)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=465
SMTP_USER=maudevchile@gmail.com
SMTP_FROM=maudevchile@gmail.com
SMTP_PASS=<TU_APP_PASSWORD>

# Validaciones
MAX_FILE_SIZE_MB=10
ALLOWED_FILE_TYPES=.pdf

# Servidor Formulario
FORM_PORT=8080
FORM_URL=http://localhost:8080/formulario-convalidacion-unab.html
```

## Credenciales Google Cloud

```
Project ID: proyecto-convalidaciones-unab
OAuth2 Client ID: <tu_client_id>.apps.googleusercontent.com
OAuth2 Client Secret: <tu_client_secret>
Redirect URI: http://localhost:5678/rest/oauth2-credential/callback

APIs Habilitadas:
- Google Sheets API
- Google Drive API
```

## Estructura Google Drive

```
📁 Convalidaciones UNAB/
  📁 2025/
    📁 Octubre/
      📄 SOL-{RUT}-{TIMESTAMP}_{NOMBRE_ARCHIVO}.pdf
    📁 Noviembre/
    📁 Diciembre/
  📁 2024/
```

## Estructura Google Sheets

### Hoja: Solicitudes
```
Columnas:
- id (texto)
- fecha (fecha/hora)
- estudiante (texto)
- rut (texto)
- carrera (texto)
- asignatura (texto)
- institucionOrigen (texto)
- documentos (texto)
- linkDrive (URL)
- driveFileId (texto)
- tamanoMB (número)
- email (email)
- estado (texto)
```

### Hoja: Logs
```
Columnas:
- timestamp (fecha/hora)
- id (texto)
- evento (texto)
- estudiante (texto)
- estado (texto)
- detalles (texto)
```

## Endpoints

- **n8n UI:** http://localhost:5678
- **Webhook:** http://localhost:5678/webhook/solicitud-convalidacion
- **Formulario:** Abrir archivo HTML directamente

## Validaciones Implementadas

### 1. Validación de Campos
- Todos los campos requeridos presentes
- No vacíos ni solo espacios

### 2. Validación de RUT
- Formato: 12.345.678-9 o 12345678-9
- Dígito verificador correcto (algoritmo chileno)
- Rango: 7-8 dígitos + verificador

### 3. Validación de Email
- Formato válido (regex)
- Longitud máxima: 254 caracteres
- Campo opcional

### 4. Validación de PDF
- Extensión: .pdf
- Tipo MIME: application/pdf
- Tamaño máximo: 10 MB
- Archivo no corrupto

### 5. Logs de Errores
- Errores de validación
- Errores de PDF
- Todos registrados en Google Sheets

## Flujo de Datos

```
1. Webhook recibe datos + archivo base64
2. Validar campos básicos
3. Validar RUT chileno
4. Validar email
5. Si validación OK:
   a. Validar PDF (tipo + tamaño)
   b. Si PDF OK:
      - Subir a Google Drive
      - Obtener link compartido
      - Guardar en Sheets con link
      - Enviar email de confirmación
      - Registrar log de éxito
   c. Si PDF error:
      - Enviar email de error
      - Registrar log de error
6. Si validación falla:
   - Registrar log de error
   - Responder con error detallado
```

## Notas de Seguridad

- ✅ No versionar credenciales reales
- ✅ Usar contraseñas de aplicación (no contraseñas reales)
- ✅ Validar RUT con dígito verificador
- ✅ Limitar tamaño de archivos (10MB)
- ✅ Validar tipo MIME del archivo
- ✅ Logs completos de todos los eventos

## Cambios en esta Versión (v3)

### ✅ Implementado:
1. Validación de RUT chileno con dígito verificador
2. Validación de email con regex
3. Validación de tamaño de archivo (10MB max)
4. Integración con Google Drive
5. Links de Drive en Google Sheets
6. Logs de errores completos
7. Emails mejorados con información de archivos
8. Respuestas de error para todos los casos
9. HTML con envío de archivo real (base64)
10. Validación de tamaño en el cliente

### 📝 Pendiente (Prioridad Baja):
- Verificación de duplicados por RUT
- Dashboard de estadísticas
- Notificaciones a administradores
- Compresión automática de archivos grandes

````
