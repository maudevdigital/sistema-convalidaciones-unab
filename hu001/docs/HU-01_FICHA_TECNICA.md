# HU-01: Recepción de Solicitud - Ficha Técnica

## 📋 **Historia de Usuario**

**Como** estudiante  
**Quiero** enviar una solicitud de convalidación de asignatura a través de un formulario web  
**Para que** mi solicitud sea procesada automáticamente por el sistema académico  

## 🎯 **Objetivo**
Implementar un flujo automatizado que reciba, valide y registre solicitudes de convalidación de asignaturas, proporcionando confirmación inmediata al estudiante.

## ✅ **Criterios de Aceptación (CA)**

### **CA1: Captura de Datos del Formulario**
- **Given:** Un estudiante accede al formulario de solicitud
- **When:** Completa y envía los datos requeridos  
- **Then:** El sistema captura: nombre, rut, carrera, asignatura, institución origen, documentos PDF
- **And:** Se valida que todos los campos obligatorios estén presentes

### **CA2: Guardado Automático en Google Sheets**
- **Given:** Los datos han sido validados correctamente
- **When:** Se procesa la solicitud
- **Then:** Los datos se guardan automáticamente en Google Sheets hoja "Solicitudes"
- **And:** Se registra log de la operación en hoja "Logs"

### **CA3: Confirmación de Recepción**
- **Given:** La solicitud ha sido guardada exitosamente
- **When:** Se completa el proceso de registro
- **Then:** Se envía email de confirmación al estudiante
- **And:** El email incluye número de solicitud y próximos pasos

## 📊 **Entradas y Salidas**

### **Entradas (Input JSON)**
```json
{
  "nombre": "string (requerido)",
  "rut": "string (requerido)", 
  "carrera": "string (requerido)",
  "asignatura": "string (requerido)",
  "institucionOrigen": "string (requerido)",
  "documentos": "file/string (requerido)",
  "email": "string (opcional para confirmación)"
}
```

### **Salidas (Response JSON)**
```json
{
  "success": true,
  "id": "ID-123456789",
  "mensaje": "Solicitud recibida correctamente",
  "fechaSolicitud": "2025-10-17T10:30:00Z",
  "proximosPasos": "Recibirá notificación por email una vez revisada"
}
```

## 🔄 **Flujo del Proceso**

1. **Webhook Recepción** → Recibe datos vía POST
2. **Validación de Campos** → Verifica campos obligatorios
3. **Validación de Documentos** → Confirma formato PDF
4. **Almacenamiento Drive** → Guarda documentos en Google Drive  
5. **Registro en Sheets** → Inserta fila en hoja "Solicitudes"
6. **Log de Operación** → Registra evento en hoja "Logs"
7. **Email Confirmación** → Envía confirmación al estudiante

## ❌ **Manejo de Errores**

### **Error: Campos Faltantes**
- **Trigger:** Campo obligatorio vacío
- **Response:** HTTP 400 + lista de campos faltantes
- **Action:** No se procesa la solicitud

### **Error: Formato Documento Inválido**
- **Trigger:** Archivo no es PDF
- **Response:** HTTP 400 + mensaje de formato
- **Action:** Email al estudiante solicitando corrección

### **Error: Falla en Google Sheets**
- **Trigger:** Error de conexión/permisos
- **Response:** HTTP 500 + mensaje técnico
- **Action:** Log del error + notificación admin

## 🧪 **Datos de Prueba**

### **Caso Válido**
```json
{
  "nombre": "Juan Pérez González",
  "rut": "12.345.678-9",
  "carrera": "Ingeniería en Informática",
  "asignatura": "Programación Web Avanzada", 
  "institucionOrigen": "Universidad de Chile",
  "documentos": "certificado_notas.pdf",
  "email": "juan.perez@estudiante.unab.cl"
}
```

### **Caso Inválido (Campo Faltante)**
```json
{
  "nombre": "María Silva",
  "carrera": "Psicología",
  "asignatura": "Estadística Aplicada"
  // Faltan: rut, institucionOrigen, documentos
}
```

### **Caso Borde (Caracteres Especiales)**
```json
{
  "nombre": "José María Fernández-O'Connor",
  "rut": "98.765.432-1",
  "carrera": "Administración de Empresas",
  "asignatura": "Gestión & Liderazgo (Nivel I)",
  "institucionOrigen": "UNAM - México",
  "documentos": "transcript_josé_maría.pdf"
}
```

## 🔧 **Configuración Técnica**

### **Webhook Endpoint**
- **URL:** `http://localhost:5678/webhook/solicitud-convalidacion`
- **Método:** POST
- **Autenticación:** Basic Auth (opcional)
- **Headers:** Content-Type: application/json

### **Google Sheets Estructura**
**Hoja "Solicitudes":**
- ID | Fecha | Estudiante | RUT | Carrera | Asignatura | InstitucionOrigen | Estado

**Hoja "Logs":** 
- Timestamp | ID | Status | Details

### **Nomenclatura de Nodos**
- `Webhook - Recepción` (Trigger)
- `Function - Validar` (Validation)
- `IF - Documentación` (Decision)
- `Storage - Documentos` (Google Drive)
- `DB - Registro` (Google Sheets)
- `Email - Confirmación` (Notification)

## 📈 **Métricas de Éxito**
- ✅ 100% de solicitudes válidas procesadas
- ✅ <2 segundos tiempo de respuesta
- ✅ 0% pérdida de datos
- ✅ Email confirmación enviado en <5 segundos

## 🔗 **Dependencias**
- Google Sheets API configurado
- Google Drive API configurado  
- SMTP/Email configurado
- n8n versión 1.113.3+

---
**Versión:** 1.0  
**Fecha:** 17 octubre 2025  
**Responsable:** Equipo Desarrollo n8n