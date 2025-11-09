# HU-05: Casos de Prueba - Notificación de Corrección de Documentos

## 📋 Información General

**Historia de Usuario:** HU-05 - Notificación al Estudiante para Corrección de Documentación  
**Sprint:** Sprint 2 (4-22 noviembre 2025)  
**Responsable Testing:** Tester  
**Fecha Creación:** 9 noviembre 2025  
**Versión:** 1.0

---

## 🎯 Objetivo de las Pruebas

Validar que el sistema de notificación automática funciona correctamente al detectar errores de documentación, generando y enviando emails personalizados con los templates correctos según el tipo de error.

---

## ✅ Criterios de Aceptación Cubiertos

### **CA1: Detección de Rechazo de Documentación**
- Casos: CP-001, CP-002, CP-003, CP-004

### **CA2: Redacción Automática del Email de Corrección**
- Casos: CP-005, CP-006, CP-007, CP-008

### **CA3: Envío de Email al Estudiante**
- Casos: CP-009, CP-010, CP-011, CP-012

---

## 🧪 CASOS DE PRUEBA

### **CP-001: Detección de Formato Incorrecto**

**Precondiciones:**
- HU-004 está funcionando y detecta errores de formato
- HU-005 workflow está activado en n8n
- Conexión entre HU-004 y HU-005 está establecida

**Datos de Entrada:**
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
  },
  "timestamp": "2025-11-09T14:30:00Z"
}
```

**Pasos a Ejecutar:**
1. Activar HU-004 con documento en formato .docx
2. Verificar que HU-004 detecta error de formato
3. Observar que HU-005 recibe los datos del error
4. Verificar en n8n que el nodo `IF-ValidacionDoc` identifica tipo error

**Resultado Esperado:**
- ✅ HU-005 se activa automáticamente
- ✅ Datos del error se transfieren correctamente
- ✅ Campo `error.tipo` = "formato_incorrecto"
- ✅ Todos los campos requeridos están presentes (idSolicitud, email, detalles)

**Prioridad:** Alta  
**Estado:** ⬜ Pendiente

---

### **CP-002: Detección de Tamaño Excedido**

**Precondiciones:**
- HU-004 valida tamaño de archivos (máx 10 MB)
- HU-005 está integrado con HU-004

**Datos de Entrada:**
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

**Pasos a Ejecutar:**
1. Subir archivo PDF de 15.5 MB en HU-001
2. Esperar validación de HU-004
3. Verificar detección de error de tamaño
4. Confirmar activación de HU-005

**Resultado Esperado:**
- ✅ Error tipo "tamano_excedido" detectado
- ✅ Campo `tamanoMB` contiene valor correcto (15.5)
- ✅ Datos transferidos a HU-005 sin pérdida

**Prioridad:** Alta  
**Estado:** ⬜ Pendiente

---

### **CP-003: Detección de Archivo Corrupto**

**Precondiciones:**
- HU-004 valida integridad de archivos PDF
- Sistema puede detectar PDFs corruptos

**Datos de Entrada:**
```json
{
  "idSolicitud": "SOL-11223344-TEST003",
  "estudiante": {
    "nombre": "Pedro Ramírez Castro",
    "rut": "20.111.222-3",
    "email": "pedro.ramirez@test.unab.cl"
  },
  "error": {
    "tipo": "archivo_corrupto",
    "mensaje": "El archivo no puede ser leído",
    "detalles": {
      "archivoNombre": "certificado_corrupto.pdf",
      "motivoRechazo": "El archivo está corrupto o dañado"
    }
  }
}
```

**Pasos a Ejecutar:**
1. Crear archivo PDF corrupto (truncado o con bytes inválidos)
2. Subirlo mediante HU-001
3. Esperar validación de HU-004
4. Verificar detección de corrupción

**Resultado Esperado:**
- ✅ Error tipo "archivo_corrupto" detectado
- ✅ HU-005 recibe notificación
- ✅ Mensaje de error es claro y descriptivo

**Prioridad:** Media  
**Estado:** ⬜ Pendiente

---

### **CP-004: Detección de Campos Faltantes**

**Precondiciones:**
- HU-001 permite envío con campos opcionales vacíos
- HU-004 valida campos obligatorios

**Datos de Entrada:**
```json
{
  "idSolicitud": "SOL-55667788-TEST004",
  "estudiante": {
    "nombre": "Ana López Martínez",
    "rut": "19.555.666-7",
    "email": "ana.lopez@test.unab.cl"
  },
  "error": {
    "tipo": "campos_faltantes",
    "mensaje": "Faltan campos obligatorios",
    "detalles": {
      "camposFaltantes": ["asignaturaConvalidar", "institucionOrigen"],
      "motivoRechazo": "Debe completar todos los campos obligatorios"
    }
  }
}
```

**Pasos a Ejecutar:**
1. Enviar solicitud sin campos obligatorios
2. Esperar validación de HU-004
3. Verificar detección de campos faltantes
4. Confirmar lista de campos faltantes

**Resultado Esperado:**
- ✅ Error tipo "campos_faltantes" detectado
- ✅ Array `camposFaltantes` contiene nombres correctos
- ✅ HU-005 recibe detalles completos

**Prioridad:** Alta  
**Estado:** ⬜ Pendiente

---

### **CP-005: Generación de Email con Template Formato Incorrecto**

**Precondiciones:**
- CP-001 ejecutado exitosamente
- Template 1 definido en nodo `Function-RedactarEmail`

**Datos de Entrada:** (mismo que CP-001)

**Pasos a Ejecutar:**
1. Activar HU-005 con error tipo "formato_incorrecto"
2. Verificar nodo `Function-SeleccionarTemplate`
3. Confirmar que selecciona "template_formato_incorrecto"
4. Revisar email generado en nodo `Function-RedactarEmail`

**Resultado Esperado:**
```
Asunto: Corrección Requerida - Formato de Documento Incorrecto

Cuerpo incluye:
- ✅ Saludo personalizado: "Estimado/a Juan Pérez González"
- ✅ ID solicitud: "SOL-12345678-TEST001"
- ✅ Nombre archivo: "certificado.docx"
- ✅ Tipo detectado: "DOCX"
- ✅ Motivo rechazo: "Solo se aceptan archivos PDF"
- ✅ Instrucciones de corrección (3 pasos)
- ✅ Link de reenvío
- ✅ Datos de contacto: convalidaciones@unab.cl
```

**Prioridad:** Alta  
**Estado:** ⬜ Pendiente

---

### **CP-006: Generación de Email con Template Tamaño Excedido**

**Precondiciones:**
- CP-002 ejecutado exitosamente
- Template 2 definido

**Pasos a Ejecutar:**
1. Procesar error tipo "tamano_excedido"
2. Verificar selección de template correcto
3. Validar reemplazo de variables dinámicas

**Resultado Esperado:**
```
Asunto: Corrección Requerida - Archivo Demasiado Grande

Cuerpo incluye:
- ✅ Nombre estudiante: "María Silva Torres"
- ✅ Tamaño actual: "15.5 MB"
- ✅ Tamaño máximo: "10 MB"
- ✅ Sugerencias de compresión (3 tips)
- ✅ Link de reenvío funcional
```

**Prioridad:** Alta  
**Estado:** ⬜ Pendiente

---

### **CP-007: Generación de Email con Template Archivo Corrupto**

**Precondiciones:**
- CP-003 ejecutado exitosamente
- Template 3 disponible

**Resultado Esperado:**
```
Asunto: Corrección Requerida - Archivo No Puede Ser Leído

Cuerpo incluye:
- ✅ Explicación clara del problema
- ✅ Instrucciones para regenerar PDF
- ✅ Sugerencias de herramientas confiables
```

**Prioridad:** Media  
**Estado:** ⬜ Pendiente

---

### **CP-008: Generación de Email con Template Campos Faltantes**

**Precondiciones:**
- CP-004 ejecutado exitosamente
- Template 4 configurado

**Resultado Esperado:**
```
Asunto: Corrección Requerida - Información Incompleta

Cuerpo incluye:
- ✅ Lista de campos faltantes:
  * asignaturaConvalidar
  * institucionOrigen
- ✅ Lista completa de campos obligatorios
- ✅ Instrucciones para completar
```

**Prioridad:** Alta  
**Estado:** ⬜ Pendiente

---

### **CP-009: Envío Exitoso de Email vía SMTP**

**Precondiciones:**
- SMTP configurado (Ethereal para testing)
- Email generado correctamente (CP-005 a CP-008)

**Configuración SMTP Testing:**
```
Host: smtp.ethereal.email
Port: 587
User: [generated by Ethereal]
Pass: [generated by Ethereal]
```

**Pasos a Ejecutar:**
1. Configurar credenciales SMTP en n8n
2. Ejecutar HU-005 con caso CP-001
3. Verificar envío en nodo `Email-Correccion`
4. Revisar bandeja de entrada en Ethereal

**Resultado Esperado:**
- ✅ Email enviado sin errores SMTP
- ✅ Destinatario correcto: juan.perez@test.unab.cl
- ✅ Asunto y cuerpo formateados correctamente
- ✅ Tiempo de envío < 10 segundos
- ✅ Email visible en Ethereal inbox

**Prioridad:** Crítica  
**Estado:** ⬜ Pendiente

---

### **CP-010: Registro en Google Sheets (Hoja "Logs")**

**Precondiciones:**
- CP-009 ejecutado exitosamente
- Google Sheets API configurado
- Hoja "Logs" existe con columnas correctas

**Pasos a Ejecutar:**
1. Enviar email exitosamente (CP-009)
2. Verificar ejecución de nodo `DB-Log`
3. Abrir Google Sheets hoja "Logs"
4. Verificar última fila insertada

**Resultado Esperado:**
Última fila en "Logs" contiene:
- ✅ `timestamp`: "2025-11-09 14:30:15"
- ✅ `idSolicitud`: "SOL-12345678-TEST001"
- ✅ `tipo_notificacion`: "error_documentacion"
- ✅ `tipo_error`: "formato_incorrecto"
- ✅ `email_enviado`: "si"
- ✅ `destinatario`: "juan.perez@test.unab.cl"
- ✅ `template_utilizado`: "template_formato_incorrecto"
- ✅ `estado_envio`: "exitoso"

**Prioridad:** Alta  
**Estado:** ⬜ Pendiente

---

### **CP-011: Response JSON Exitoso**

**Precondiciones:**
- CP-009 y CP-010 completados
- Nodo `Respond-Confirmacion` configurado

**Pasos a Ejecutar:**
1. Ejecutar workflow completo
2. Capturar response del nodo final
3. Validar estructura JSON

**Resultado Esperado:**
```json
{
  "success": true,
  "idSolicitud": "SOL-12345678-TEST001",
  "emailEnviado": true,
  "destinatario": "juan.perez@test.unab.cl",
  "tipoError": "formato_incorrecto",
  "templateUtilizado": "template_formato_incorrecto",
  "timestamp": "2025-11-09T14:30:15Z",
  "logRegistrado": true,
  "mensaje": "Email de corrección enviado exitosamente"
}
```

**Prioridad:** Alta  
**Estado:** ⬜ Pendiente

---

### **CP-012: Manejo de Error SMTP (Connection Failed)**

**Precondiciones:**
- HU-005 configurado
- SMTP temporalmente desconectado (simular falla)

**Pasos a Ejecutar:**
1. Desactivar conexión SMTP o usar credenciales inválidas
2. Ejecutar HU-005
3. Observar manejo de error
4. Verificar reintentos automáticos

**Resultado Esperado:**
- ✅ Sistema detecta falla SMTP
- ✅ Realiza 3 reintentos con intervalo 30 segundos
- ✅ Registra error en Logs con detalles
- ✅ Marca como "pendiente_reenvio"
- ✅ Response indica falla:
```json
{
  "success": false,
  "error": "SMTP Connection Failed",
  "intentos": 3,
  "estadoSolicitud": "pendiente_reenvio"
}
```

**Prioridad:** Alta  
**Estado:** ⬜ Pendiente

---

### **CP-013: Validación End-to-End (E2E)**

**Precondiciones:**
- HU-001, HU-004, HU-005 integrados
- Todos los casos anteriores pasados

**Escenario Completo:**
1. **Paso 1:** Estudiante envía solicitud con documento .docx (HU-001)
2. **Paso 2:** Sistema recibe y almacena solicitud (HU-001)
3. **Paso 3:** Sistema valida documento y detecta formato incorrecto (HU-004)
4. **Paso 4:** Sistema activa notificación automática (HU-005)
5. **Paso 5:** Email de corrección generado y enviado
6. **Paso 6:** Estudiante recibe email con instrucciones
7. **Paso 7:** Evento registrado en Google Sheets

**Tiempo Máximo Total:** 30 segundos

**Resultado Esperado:**
- ✅ Flujo completo sin interrupciones
- ✅ Cada HU ejecuta su función correctamente
- ✅ Datos transferidos sin pérdida
- ✅ Email recibido por estudiante
- ✅ Log completo en Google Sheets

**Prioridad:** Crítica  
**Estado:** ⬜ Pendiente

---

## 📊 Resumen de Cobertura

| Criterio de Aceptación | Casos de Prueba | Prioridad |
|------------------------|-----------------|-----------|
| CA1: Detección de Rechazo | CP-001, CP-002, CP-003, CP-004 | Alta |
| CA2: Redacción Email | CP-005, CP-006, CP-007, CP-008 | Alta |
| CA3: Envío Email | CP-009, CP-010, CP-011, CP-012 | Crítica |
| E2E Integration | CP-013 | Crítica |

**Total Casos:** 13  
**Prioridad Crítica:** 3  
**Prioridad Alta:** 9  
**Prioridad Media:** 2

---

## ✅ Checklist de Ejecución

### Preparación
- ⬜ n8n versión 1.113.3 instalado
- ⬜ HU-001 funcionando correctamente
- ⬜ HU-004 integrado y validando documentos
- ⬜ SMTP Ethereal configurado
- ⬜ Google Sheets API activo
- ⬜ Hoja "Logs" con columnas correctas

### Ejecución por CA
- ⬜ CA1: 4/4 casos ejecutados
- ⬜ CA2: 4/4 casos ejecutados
- ⬜ CA3: 4/4 casos ejecutados
- ⬜ E2E: 1/1 caso ejecutado

### Documentación de Resultados
- ⬜ Screenshots capturadas para cada caso
- ⬜ Logs de n8n exportados
- ⬜ Evidencias de emails en Ethereal
- ⬜ Verificación de Google Sheets
- ⬜ Documento HU-05_RESULTADOS_PRUEBAS.md creado

---

## 📝 Plantilla de Reporte de Defectos

Si un caso falla, usar esta plantilla:

**ID Defecto:** DEF-HU05-XXX  
**Caso de Prueba:** CP-XXX  
**Severidad:** Crítica / Alta / Media / Baja  
**Descripción:** [Descripción del problema]  
**Pasos para Reproducir:**  
1. ...  
2. ...  

**Resultado Esperado:** [...]  
**Resultado Obtenido:** [...]  
**Capturas/Logs:** [Adjuntar evidencias]  
**Asignado a:** Developer  
**Estado:** Abierto / En Progreso / Resuelto

---

**Versión:** 1.0  
**Última Actualización:** 9 noviembre 2025  
**Responsable:** Tester Sprint 2  
**Estado:** ✅ Casos de prueba definidos
