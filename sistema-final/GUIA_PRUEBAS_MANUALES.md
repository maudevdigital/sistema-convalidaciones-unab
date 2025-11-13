# 🧪 Guía de Pruebas Manuales - Sistema Convalidaciones

**Fecha:** 12 de noviembre de 2025  
**Workflows:** HU-001 + HU-005 (Integrado)  
**Tester:** Lucas Maulen  
**Email de pruebas:** lucasmaulenr@gmail.com

---

## 📋 Pre-requisitos

### ✅ Verificar antes de comenzar:

1. **n8n corriendo:**
   ```powershell
   # En PowerShell:
   Test-NetConnection -ComputerName localhost -Port 5678 -InformationLevel Quiet
   # Debe retornar: True
   ```

2. **Workflow activado en n8n:**
   - Abrir: `http://localhost:5678`
   - Importar: `sistema-final/workflows/workflow.json`
   - **IMPORTANTE:** Activar el toggle (debe estar en verde/ON)
   - Verificar que los webhooks estén activos:
     - ✅ `/webhook/solicitud-convalidacion` (HU-001)
     - ✅ `/webhook/hu005-notificacion-correccion` (HU-005)

3. **Credenciales OAuth2 configuradas:**
   - Google Drive OAuth2 API
   - Google Sheets OAuth2 API
   - SMTP (maudevchile@gmail.com)

4. **Formulario HTML listo:**
   ```powershell
   # Abrir el formulario en el navegador:
   start sistema-final\formulario-convalidacion-unab.html
   ```

---

## 🎯 Plan de Pruebas

### **Caso de Prueba 1: Solicitud Válida Completa (HU-001 - Flujo Exitoso)**

**Objetivo:** Verificar que una solicitud con todos los datos correctos se procese exitosamente.

#### Datos de entrada:
```
Nombre completo: Lucas Maulen Rodriguez
RUT: 12.345.678-5
Carrera: Ingeniería Civil en Informática
Asignatura a convalidar: Programación Orientada a Objetos
Institución de origen: Universidad de Chile
Email: lucasmaulenr@gmail.com
Archivo: Un PDF válido de máximo 10MB
```

#### Pasos:
1. Abrir `sistema-final/formulario-convalidacion-unab.html` en el navegador
2. Llenar todos los campos con los datos de arriba
3. Adjuntar un PDF válido (ej: certificado de notas)
4. Click en "Enviar Solicitud"

#### Resultado esperado:
- ✅ Mensaje de éxito en el formulario: "Solicitud enviada correctamente"
- ✅ ID de solicitud visible (formato: `SOL-12345678-[timestamp]`)
- ✅ Email de confirmación recibido en `lucasmaulenr@gmail.com`
- ✅ Registro en Google Sheets (hoja "Solicitudes")
- ✅ Log en Google Sheets (hoja "Logs")
- ✅ Archivo subido a Google Drive

#### Evidencia a capturar:
- [ ] Screenshot del mensaje de éxito
- [ ] Screenshot del email de confirmación
- [ ] Screenshot de Google Sheets - Solicitudes
- [ ] Screenshot de Google Sheets - Logs
- [ ] Screenshot de Google Drive con el archivo

---

### **Caso de Prueba 2: Campo Obligatorio Faltante (HU-001 - Validación)**

**Objetivo:** Verificar que el sistema rechace solicitudes con campos obligatorios vacíos.

#### Datos de entrada:
```
Nombre completo: Lucas Maulen Rodriguez
RUT: [DEJAR VACÍO] ← Campo faltante
Carrera: Ingeniería Civil en Informática
Asignatura a convalidar: Bases de Datos
Institución de origen: Universidad Técnica Federico Santa María
Email: lucasmaulenr@gmail.com
Archivo: Un PDF válido
```

#### Pasos:
1. Llenar el formulario pero **omitir el RUT**
2. Click en "Enviar Solicitud"

#### Resultado esperado:
- ❌ Mensaje de error: "Faltan campos obligatorios"
- ❌ Especifica: "Campo requerido: rut"
- ❌ NO se envía email
- ❌ NO se registra en Google Sheets

#### Evidencia a capturar:
- [ ] Screenshot del mensaje de error

---

### **Caso de Prueba 3: RUT Inválido (HU-001 - Validación)**

**Objetivo:** Verificar que el sistema valide el formato del RUT chileno.

#### Datos de entrada:
```
Nombre completo: Lucas Maulen Rodriguez
RUT: 12.345.678-0 ← Dígito verificador incorrecto
Carrera: Ingeniería Civil en Informática
Asignatura a convalidar: Estructura de Datos
Institución de origen: Universidad de Santiago
Email: lucasmaulenr@gmail.com
Archivo: Un PDF válido
```

#### Pasos:
1. Llenar el formulario con un RUT con dígito verificador incorrecto
2. Click en "Enviar Solicitud"

#### Resultado esperado:
- ❌ Mensaje de error: "El RUT proporcionado no es válido"
- ❌ Detalles: "Formato esperado: 12.345.678-9 o 12345678-9"
- ❌ NO se procesa la solicitud

#### Evidencia a capturar:
- [ ] Screenshot del mensaje de error

---

### **Caso de Prueba 4: Email Inválido (HU-001 - Validación)**

**Objetivo:** Verificar que el sistema valide el formato del email.

#### Datos de entrada:
```
Nombre completo: Lucas Maulen Rodriguez
RUT: 12.345.678-5
Carrera: Ingeniería Civil en Informática
Asignatura a convalidar: Redes de Computadores
Institución de origen: Universidad Católica
Email: correo-invalido ← Sin @ y dominio
Archivo: Un PDF válido
```

#### Pasos:
1. Llenar el formulario con un email mal formado
2. Click en "Enviar Solicitud"

#### Resultado esperado:
- ❌ Mensaje de error: "El email proporcionado no es válido"

#### Evidencia a capturar:
- [ ] Screenshot del mensaje de error

---

### **Caso de Prueba 5: Formato de Archivo Incorrecto (HU-001 → HU-005)**

**Objetivo:** Verificar que el sistema rechace archivos que no sean PDF y envíe email de corrección.

#### Datos de entrada:
```
Nombre completo: Lucas Maulen Rodriguez
RUT: 12.345.678-5
Carrera: Ingeniería Civil en Informática
Asignatura a convalidar: Sistemas Operativos
Institución de origen: Universidad de Concepción
Email: lucasmaulenr@gmail.com
Archivo: certificado.docx ← ARCHIVO NO PDF
```

#### Pasos:
1. Llenar el formulario correctamente
2. Adjuntar un archivo `.docx` o `.jpg` (NO PDF)
3. Click en "Enviar Solicitud"

#### Resultado esperado:
- ❌ Mensaje de error: "Documento PDF no válido"
- ❌ Detalles: "Solo se aceptan archivos PDF de máximo 10MB"
- ✅ **Email de corrección enviado** (HU-005 activada)
- ✅ Email con template "Formato de Documento Incorrecto"
- ✅ Log registrado con estado "Rechazada - PDF Inválido"

#### Evidencia a capturar:
- [ ] Screenshot del mensaje de error en formulario
- [ ] Screenshot del email de corrección recibido
- [ ] Verificar que el email contenga:
  - [ ] ID de solicitud
  - [ ] Nombre del archivo rechazado
  - [ ] Instrucciones para corregir
  - [ ] Link de reenvío

---

### **Caso de Prueba 6: Archivo PDF Muy Grande (HU-001 → HU-005)**

**Objetivo:** Verificar que el sistema rechace archivos mayores a 10MB y envíe email de corrección.

#### Datos de entrada:
```
Nombre completo: Lucas Maulen Rodriguez
RUT: 12.345.678-5
Carrera: Ingeniería Civil en Informática
Asignatura a convalidar: Inteligencia Artificial
Institución de origen: Universidad de Valparaíso
Email: lucasmaulenr@gmail.com
Archivo: documento-grande.pdf ← MAYOR A 10MB
```

#### Pasos:
1. Crear un PDF de más de 10MB:
   ```powershell
   # Crear archivo de prueba de 12MB:
   $content = "A" * 12MB
   $content | Out-File -FilePath "test-12mb.txt" -Encoding ASCII
   # Convertir a PDF usando alguna herramienta
   ```
2. Llenar el formulario correctamente
3. Adjuntar el PDF grande
4. Click en "Enviar Solicitud"

#### Resultado esperado:
- ❌ Mensaje de error: "Documento PDF no válido"
- ❌ Detalles: "Archivo muy grande: XX.XX MB. Máximo: 10MB"
- ✅ **Email de corrección enviado** (HU-005 activada)
- ✅ Email con template "Archivo Demasiado Grande"
- ✅ Indica el tamaño actual vs. máximo permitido

#### Evidencia a capturar:
- [ ] Screenshot del mensaje de error
- [ ] Screenshot del email de corrección recibido
- [ ] Verificar mensaje personalizado con tamaño del archivo

---

### **Caso de Prueba 7: Prueba de Caracteres Especiales (HU-005)**

**Objetivo:** Verificar que el sistema maneje correctamente caracteres especiales en español.

#### Datos de entrada:
```
Nombre completo: José María Pérez Núñez
RUT: 19.876.543-2
Carrera: Ingeniería en Informática
Asignatura a convalidar: Diseño de Software Avanzado
Institución de origen: Universidad Católica de la Santísima Concepción
Email: lucasmaulenr@gmail.com
Archivo: Un archivo .jpg (forzar error para recibir email HU-005)
```

#### Pasos:
1. Llenar con datos que contengan tildes y ñ
2. Adjuntar archivo NO PDF para forzar error
3. Click en "Enviar Solicitud"

#### Resultado esperado:
- ✅ Email de corrección recibido
- ✅ Caracteres especiales correctamente renderizados (sin mojibake):
  - José → José (no JosÃ©)
  - María → María (no MarÃ­a)
  - Pérez → Pérez (no PÃ©rez)
  - Núñez → Núñez (no NÃºÃ±ez)

#### Evidencia a capturar:
- [ ] Screenshot del email verificando encoding correcto
- [ ] Verificar que NO aparezca: Ã©, Ã­, Ã±, etc.

---

## 📊 Tabla de Resultados

| # | Caso de Prueba | Estado | Observaciones | Evidencia |
|---|----------------|--------|---------------|-----------|
| 1 | Solicitud Válida Completa | ⏳ Pendiente | | |
| 2 | Campo Obligatorio Faltante | ⏳ Pendiente | | |
| 3 | RUT Inválido | ⏳ Pendiente | | |
| 4 | Email Inválido | ⏳ Pendiente | | |
| 5 | Formato Archivo Incorrecto | ⏳ Pendiente | | |
| 6 | Archivo PDF Muy Grande | ⏳ Pendiente | | |
| 7 | Caracteres Especiales | ⏳ Pendiente | | |

**Leyenda:**
- ⏳ Pendiente
- ✅ Exitoso
- ❌ Fallido
- ⚠️ Exitoso con observaciones

---

## 📁 Estructura de Evidencias

Guardar screenshots en:
```
Sprint02/
  registro-evidencias/
    TC01_solicitud_valida/
      - formulario_enviado.png
      - email_confirmacion.png
      - sheets_solicitudes.png
      - sheets_logs.png
      - drive_archivo.png
    TC02_campo_faltante/
      - error_campo_requerido.png
    TC03_rut_invalido/
      - error_rut.png
    TC04_email_invalido/
      - error_email.png
    TC05_formato_incorrecto/
      - error_formulario.png
      - email_correccion_formato.png
    TC06_archivo_grande/
      - error_formulario.png
      - email_correccion_tamano.png
    TC07_caracteres_especiales/
      - email_encoding_correcto.png
```

---

## 🔍 Checklist Final

### Antes de empezar:
- [ ] n8n corriendo (puerto 5678)
- [ ] Workflow importado y ACTIVADO
- [ ] Credenciales OAuth2 configuradas
- [ ] Gmail listo para recibir emails de prueba
- [ ] Google Sheets configurado
- [ ] Carpeta de evidencias creada

### Durante las pruebas:
- [ ] Tomar screenshots de cada resultado
- [ ] Nombrar archivos según convención
- [ ] Verificar cada email recibido
- [ ] Revisar Google Sheets después de cada prueba
- [ ] Limpiar datos entre pruebas si es necesario

### Después de las pruebas:
- [ ] Completar tabla de resultados
- [ ] Organizar evidencias en carpetas
- [ ] Documentar cualquier error encontrado
- [ ] Actualizar workflow si se encuentran problemas
- [ ] Preparar resumen ejecutivo

---

## 🚀 Comandos Útiles

### Abrir formulario:
```powershell
start sistema-final\formulario-convalidacion-unab.html
```

### Verificar n8n:
```powershell
Test-NetConnection -ComputerName localhost -Port 5678 -InformationLevel Quiet
```

### Ver logs de n8n (si corre en Docker):
```powershell
docker-compose logs -f n8n
```

### Crear archivo PDF de prueba grande (>10MB):
```powershell
# Opción 1: Usando PowerShell
$bytes = [byte[]]::new(12MB)
[System.IO.File]::WriteAllBytes("test-grande.bin", $bytes)
# Luego convertir a PDF con herramienta online o software

# Opción 2: Descargar PDF de prueba
# https://www.learningcontainer.com/sample-pdf-files-for-testing/
```

---

## 📞 Soporte

**En caso de problemas:**

1. **Webhook no responde:**
   - Verificar que el workflow esté activado (toggle verde)
   - Revisar executions en n8n
   - Verificar URL del webhook en el formulario

2. **No llegan emails:**
   - Verificar credenciales SMTP
   - Revisar carpeta de SPAM
   - Verificar que el email en el formulario sea correcto

3. **Error en Google Sheets/Drive:**
   - Re-autenticar credenciales OAuth2
   - Verificar permisos de las APIs
   - Verificar que el spreadsheet existe

4. **Caracteres con mojibake:**
   - El workflow tiene normalización UTF-8 automática
   - Si persiste, verificar configuración de charset en SMTP

---

**Fecha de creación:** 12 de noviembre de 2025  
**Última actualización:** 12 de noviembre de 2025  
**Responsable:** Lucas Maulen (lucasmaulenr@gmail.com)
