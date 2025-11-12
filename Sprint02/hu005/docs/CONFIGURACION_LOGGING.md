# Configuración de Logging - Sistema de Convalidaciones

## 📋 **Información General**

**Objetivo:** Documentar la configuración y uso del sistema de logging para el proyecto de Convalidaciones Académicas UNAB.

**Alcance:** HU-001, HU-004, HU-005

**Fecha:** 12 noviembre 2025

---

## 🎯 **Propósito del Logging**

El sistema de logging tiene tres objetivos principales:

1. **Auditoría:** Trazabilidad completa de todas las solicitudes procesadas
2. **Debugging:** Facilitar identificación y resolución de problemas
3. **Métricas:** Generar estadísticas de uso y rendimiento del sistema

---

## 📊 **Google Sheets como Sistema de Logs**

### **¿Por qué Google Sheets?**

- ✅ Accesible desde cualquier lugar (cloud)
- ✅ Fácil de consultar sin conocimientos técnicos
- ✅ Permite crear dashboards y gráficos automáticos
- ✅ Colaborativo (múltiples usuarios simultáneos)
- ✅ API bien documentada y soporte en n8n
- ✅ Sin costo adicional (incluido en Google Workspace)

---

## 🗂️ **Estructura de Hojas**

### **Hoja 1: "Solicitudes"** (HU-001)

Registra cada solicitud de convalidación recibida.

**Columnas:**
| Columna | Tipo | Descripción | Ejemplo |
|---------|------|-------------|---------|
| A: ID | String | ID único de solicitud | SOL-12345678-1699888000 |
| B: Fecha | DateTime | Timestamp de recepción | 2025-11-12 14:30:25 |
| C: Estudiante | String | Nombre completo | Juan Pérez González |
| D: RUT | String | RUT con formato | 12.345.678-9 |
| E: Carrera | String | Carrera del estudiante | Ingeniería en Informática |
| F: Asignatura | String | Asignatura a convalidar | Programación Web |
| G: Institución Origen | String | Institución de origen | Universidad de Chile |
| H: Documentos | String | Nombre del archivo | certificado_notas.pdf |
| I: Link Drive | URL | Link a Google Drive | https://drive.google.com/... |
| J: Drive File ID | String | ID del archivo en Drive | 1a2b3c4d5e6f... |
| K: Tamaño MB | Number | Tamaño del archivo | 2.5 |
| L: Email | Email | Email del estudiante | juan@estudiante.unab.cl |
| M: Estado | String | Estado de la solicitud | Recibida / Procesada / Error |

**Ejemplo de Registro:**
```
SOL-12345678-1699888000 | 2025-11-12 14:30:25 | Juan Pérez | 12.345.678-9 | Ing. Informática | 
Programación Web | U. de Chile | certificado.pdf | https://drive.google.com/... | 1a2b3c... | 
2.5 | juan@estudiante.unab.cl | Recibida
```

---

### **Hoja 2: "Logs"** (HU-001 - Eventos generales)

Registra eventos y operaciones del sistema.

**Columnas:**
| Columna | Tipo | Descripción | Ejemplo |
|---------|------|-------------|---------|
| A: Timestamp | DateTime | Fecha y hora del evento | 2025-11-12 14:30:25 |
| B: ID_Solicitud | String | ID relacionado (si aplica) | SOL-12345678-1699888000 |
| C: Evento | String | Tipo de evento | ValidacionExitosa |
| D: Detalles | String | Información adicional | RUT válido: 12.345.678-9 |
| E: Estado | String | Resultado | OK / ERROR / WARNING |

**Tipos de Eventos:**
- `SolicitudRecibida`
- `ValidacionExitosa`
- `ValidacionFallida`
- `ArchivoSubidoDrive`
- `EmailEnviado`
- `ErrorSMTP`

---

### **Hoja 3: "Logs_HU005"** (HU-005 - Notificaciones)

Registra específicamente los emails de corrección enviados.

**Columnas:**
| Columna | Tipo | Descripción | Ejemplo |
|---------|------|-------------|---------|
| A: Timestamp | DateTime | Fecha y hora del envío | 2025-11-12 14:35:10 |
| B: ID_Solicitud | String | ID de la solicitud | SOL-12345678-1699888000 |
| C: Email_Destino | Email | Email del estudiante | juan@estudiante.unab.cl |
| D: Tipo_Error | String | Tipo de error detectado | formato_incorrecto |
| E: Estado_Envio | String | Resultado del envío | Exitoso / Fallido |
| F: Mensaje | String | Detalles del envío | Email enviado correctamente |
| G: Template_Usado | String | Template utilizado | Template_Formato_Incorrecto |

**Ejemplo:**
```
2025-11-12 14:35:10 | SOL-12345678-1699888000 | juan@estudiante.unab.cl | 
formato_incorrecto | Exitoso | Email enviado OK | Template_Formato_Incorrecto
```

---

### **Hoja 4: "Logs_Errores"** (Todos - Errores críticos)

Registra errores y excepciones del sistema.

**Columnas:**
| Columna | Tipo | Descripción | Ejemplo |
|---------|------|-------------|---------|
| A: Timestamp | DateTime | Fecha y hora del error | 2025-11-12 15:00:00 |
| B: ID_Solicitud | String | ID relacionado | SOL-98765432-1699890000 |
| C: Tipo_Error | String | Categoría del error | SMTP_ERROR |
| D: Mensaje_Error | String | Mensaje técnico | Connection timeout |
| E: Nodo_n8n | String | Nodo donde ocurrió | Email-Confirmacion |
| F: Stack_Trace | Text | Traza completa (opcional) | Error: ETIMEDOUT... |
| G: Accion_Tomada | String | Qué se hizo | Log registrado, admin notificado |

---

## 🔧 **Configuración en n8n**

### **Paso 1: Crear Credenciales Google Sheets**

1. Ir a n8n → Credentials → Add Credential
2. Buscar "Google Sheets API"
3. Elegir método de autenticación:
   - **OAuth2** (Recomendado): Más seguro
   - **Service Account**: Para automatización

#### **Opción A: OAuth2 (Recomendado)**

4. Ir a [Google Cloud Console](https://console.cloud.google.com)
5. Crear nuevo proyecto: "Sistema Convalidaciones UNAB"
6. Habilitar API: "Google Sheets API"
7. Crear credenciales OAuth 2.0:
   - Tipo: Aplicación web
   - Authorized redirect URI: `https://localhost:5678/rest/oauth2-credential/callback`
8. Copiar Client ID y Client Secret a n8n
9. Autorizar acceso a Google Sheets
10. Guardar credenciales con ID descriptivo: "Sheets-Convalidaciones-UNAB"

#### **Opción B: Service Account**

4. Ir a [Google Cloud Console](https://console.cloud.google.com)
5. Crear Service Account
6. Descargar archivo JSON de credenciales
7. Compartir Google Sheets con email del Service Account
8. Copiar contenido JSON a n8n
9. Guardar credenciales

---

### **Paso 2: Configurar Nodos Google Sheets en n8n**

#### **Nodo: Google Sheets - Solicitudes** (HU-001)

**Configuración:**
```
Operation: Append Row
Document: [Seleccionar tu Google Sheets]
Sheet: Solicitudes
Values to Send:
  - ID: ={{$json.id}}
  - Fecha: ={{$json.fechaSolicitud}}
  - Estudiante: ={{$json.estudiante}}
  - RUT: ={{$json.rut}}
  - Carrera: ={{$json.carrera}}
  - Asignatura: ={{$json.asignatura}}
  - Institución Origen: ={{$json.institucionOrigen}}
  - Documentos: ={{$json.documentos}}
  - Link Drive: ={{$json.linkDrive}}
  - Drive File ID: ={{$json.driveFileId}}
  - Tamaño MB: ={{$json.fileSizeMB}}
  - Email: ={{$json.email}}
  - Estado: ={{$json.estado}}
```

---

#### **Nodo: Google Sheets - Logs** (HU-001)

**Configuración:**
```
Operation: Append Row
Document: [Mismo Google Sheets]
Sheet: Logs
Values to Send:
  - Timestamp: ={{$now.toISO()}}
  - ID_Solicitud: ={{$json.id}}
  - Evento: ={{$json.evento}}
  - Detalles: ={{$json.detalles}}
  - Estado: ={{$json.estado}}
```

---

#### **Nodo: Google Sheets - Logs HU005** (HU-005)

**Configuración:**
```
Operation: Append Row
Document: [Mismo Google Sheets]
Sheet: Logs_HU005
Values to Send:
  - Timestamp: ={{$now.toISO()}}
  - ID_Solicitud: ={{$json.idSolicitud}}
  - Email_Destino: ={{$json.estudiante.email}}
  - Tipo_Error: ={{$json.error.tipo}}
  - Estado_Envio: Exitoso
  - Mensaje: Email enviado correctamente
  - Template_Usado: ={{$json.templateUsado}}
```

---

#### **Nodo: Google Sheets - Logs Errores** (Todos)

**Configuración:**
```
Operation: Append Row
Document: [Mismo Google Sheets]
Sheet: Logs_Errores
Values to Send:
  - Timestamp: ={{$now.toISO()}}
  - ID_Solicitud: ={{$json.id || 'N/A'}}
  - Tipo_Error: ={{$json.errorType}}
  - Mensaje_Error: ={{$json.errorMessage}}
  - Nodo_n8n: ={{$node.name}}
  - Stack_Trace: ={{$json.stackTrace}}
  - Accion_Tomada: Log registrado
```

---

## 📝 **Mejores Prácticas de Logging**

### **1. Qué Loguear:**
- ✅ Todas las solicitudes recibidas
- ✅ Validaciones exitosas y fallidas
- ✅ Archivos subidos a Drive
- ✅ Emails enviados (confirmación y corrección)
- ✅ Errores y excepciones
- ❌ NO loguear: Contraseñas, tokens, datos sensibles

### **2. Formato de Timestamps:**
- Usar ISO 8601: `2025-11-12T14:30:25Z`
- Incluir zona horaria
- Expresión n8n: `={{$now.toISO()}}`

### **3. IDs Únicos:**
- Formato: `SOL-{RUT_SOLO_NUMEROS}-{UNIX_TIMESTAMP}`
- Ejemplo: `SOL-12345678-1699888000`
- Garantiza unicidad y trazabilidad

### **4. Estados Consistentes:**
- `Recibida` - Solicitud ingresada al sistema
- `Procesada` - Validaciones OK, archivos subidos
- `Error` - Falló alguna validación
- `Notificada` - Email de corrección enviado
- `Completada` - Proceso finalizado exitosamente

### **5. Niveles de Log:**
- `OK` - Operación exitosa
- `WARNING` - Advertencia (no crítico)
- `ERROR` - Error que requiere atención

---

## 🔍 **Consultas Útiles en Google Sheets**

### **Contar Solicitudes por Día:**
```excel
=COUNTIF(Solicitudes!B:B, ">=2025-11-12")
```

### **Buscar Solicitud por RUT:**
```excel
=FILTER(Solicitudes!A:M, Solicitudes!D:D="12.345.678-9")
```

### **Listar Errores del Día:**
```excel
=FILTER(Logs_Errores!A:G, Logs_Errores!A:A>=TODAY())
```

### **Tasa de Error de Envío HU005:**
```excel
=COUNTIF(Logs_HU005!E:E, "Fallido") / COUNTA(Logs_HU005!E:E)
```

### **Tipos de Error Más Comunes:**
```excel
=UNIQUE(Logs_HU005!D:D)
```

---

## 📊 **Dashboard Recomendado**

Crear una hoja "Dashboard" con:

1. **Métricas del Día:**
   - Total solicitudes recibidas
   - Solicitudes procesadas exitosamente
   - Emails de corrección enviados
   - Errores críticos

2. **Gráficos:**
   - Solicitudes por día (línea temporal)
   - Tipos de error más frecuentes (pie chart)
   - Tiempo promedio de procesamiento
   - Tasa de éxito/error

3. **Alertas:**
   - Solicitudes con estado "Error" >24 horas
   - Errores SMTP recurrentes
   - Archivos muy grandes (>9 MB)

---

## 🔐 **Seguridad y Permisos**

### **Acceso al Google Sheets:**

**Usuarios con Acceso Completo:**
- Administrador del sistema
- Scrum Master
- Product Owner

**Usuarios con Acceso de Lectura:**
- Eduardo Navarro (PO externo)
- Equipo de QA

**Sin Acceso:**
- Estudiantes (por privacidad)
- Externos no autorizados

### **Configuración de Permisos:**
1. Click en "Share" en Google Sheets
2. Agregar emails con roles:
   - Editor: Admin, SM, PO
   - Viewer: Eduardo, QA
3. Desactivar "Anyone with the link can view"
4. Restringir a organización UNAB

---

## 🚨 **Manejo de Errores en Logging**

### **¿Qué pasa si falla el logging?**

1. **Prioridad:** El flujo principal NO debe detenerse
2. **Estrategia:** Nodos de logging con `Continue On Fail` activado
3. **Fallback:** Logs en n8n Executions (siempre disponibles)
4. **Notificación:** Email al admin si logging falla >3 veces

### **Configuración en n8n:**

En cada nodo Google Sheets:
1. Click derecho → Settings
2. Activar "Continue On Fail"
3. Esto permite que el workflow continúe aunque falle el log

---

## 📈 **Retención de Datos**

### **Política Recomendada:**

| Hoja | Retención | Archivo |
|------|-----------|---------|
| Solicitudes | 2 años | Sí, anual |
| Logs | 6 meses | Mensual |
| Logs_HU005 | 3 meses | No |
| Logs_Errores | 1 año | Trimestral |

### **Proceso de Archivo:**

**Mensual (día 1):**
1. Crear copia del mes anterior
2. Renombrar: "Logs_2025-10_Archive"
3. Mover a carpeta "Archivos"
4. Limpiar hoja principal

**Anual (enero 1):**
1. Exportar "Solicitudes" a CSV
2. Guardar en Drive: "Solicitudes_2024.csv"
3. Mantener últimos 6 meses en hoja principal

---

## 🔧 **Troubleshooting**

### **Problema: Credenciales Expiradas**

**Síntoma:** Error "Invalid credentials" en nodo Google Sheets

**Solución:**
1. Ir a n8n → Credentials
2. Editar credencial de Google Sheets
3. Re-autorizar acceso (OAuth2)
4. Guardar y probar

---

### **Problema: Hoja No Encontrada**

**Síntoma:** Error "Sheet not found"

**Solución:**
1. Verificar nombre exacto de la hoja (case-sensitive)
2. Verificar permisos del Service Account
3. Refrescar conexión en n8n

---

### **Problema: Rate Limit Excedido**

**Síntoma:** Error "Quota exceeded"

**Solución:**
1. Google Sheets API límite: 100 requests/100 segundos
2. Reducir frecuencia de logging
3. Batch updates (agrupar logs)
4. Solicitar aumento de quota en Google Cloud

---

## 📚 **Referencias**

- [Google Sheets API Documentation](https://developers.google.com/sheets/api)
- [n8n Google Sheets Node](https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googlesheets/)
- [OAuth 2.0 Setup Guide](https://developers.google.com/identity/protocols/oauth2)

---

**Documento elaborado:** 12 noviembre 2025  
**Responsable:** Equipo DevOps  
**Próxima revisión:** Sprint 3  
**Estado:** ✅ COMPLETO
