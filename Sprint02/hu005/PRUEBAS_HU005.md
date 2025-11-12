# HU-005: Pruebas Rápidas

## 🚀 Iniciar Servidor

```powershell
# Iniciar n8n
docker-compose up -d

# Verificar que esté corriendo
docker ps --filter "name=n8n"
```

**URL n8n:** http://localhost:5678

**Webhook HU-005:** http://localhost:5678/webhook/hu005-notificacion-correccion

---

## 🧪 Pruebas con PowerShell

### **Test 1: Formato Incorrecto (archivo .docx)**

```powershell
$body = @{
    idSolicitud = "SOL-TEST-001"
    estudiante = @{
        nombre = "Juan Pérez"
        rut = "12345678-5"
        email = "tu-email@gmail.com"
    }
    error = @{
        tipo = "formato_incorrecto"
        mensaje = "El archivo no es un PDF válido"
        detalles = @{
            archivoNombre = "certificado.docx"
            archivoTipo = "application/msword"
            tamanoMB = "2.5"
            motivoRechazo = "Solo se aceptan archivos en formato PDF"
        }
    }
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Method Post -Uri "http://localhost:5678/webhook/hu005-notificacion-correccion" -Body $body -ContentType "application/json"
```

---

### **Test 2: Tamaño Excedido (archivo > 10MB)**

```powershell
$body = @{
    idSolicitud = "SOL-TEST-002"
    estudiante = @{
        nombre = "María González"
        rut = "98765432-1"
        email = "tu-email@gmail.com"
    }
    error = @{
        tipo = "tamano_excedido"
        mensaje = "Archivo supera los 10 MB permitidos"
        detalles = @{
            archivoNombre = "programa_asignatura.pdf"
            archivoTipo = "application/pdf"
            tamanoMB = "15.8"
            motivoRechazo = "El archivo supera el tamaño máximo de 10 MB"
        }
    }
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Method Post -Uri "http://localhost:5678/webhook/hu005-notificacion-correccion" -Body $body -ContentType "application/json"
```

---

### **Test 3: Archivo Corrupto**

```powershell
$body = @{
    idSolicitud = "SOL-TEST-003"
    estudiante = @{
        nombre = "Pedro Silva"
        rut = "11223344-5"
        email = "tu-email@gmail.com"
    }
    error = @{
        tipo = "archivo_corrupto"
        mensaje = "El archivo PDF está dañado y no puede ser leído"
        detalles = @{
            archivoNombre = "notas.pdf"
            archivoTipo = "application/pdf"
            tamanoMB = "3.2"
            motivoRechazo = "El archivo está corrupto o dañado"
        }
    }
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Method Post -Uri "http://localhost:5678/webhook/hu005-notificacion-correccion" -Body $body -ContentType "application/json"
```

---

### **Test 4: Campos Faltantes**

```powershell
$body = @{
    idSolicitud = "SOL-TEST-004"
    estudiante = @{
        nombre = "Ana Torres"
        rut = "55667788-9"
        email = "tu-email@gmail.com"
    }
    error = @{
        tipo = "campos_faltantes"
        mensaje = "Información incompleta en la solicitud"
        detalles = @{
            archivoNombre = ""
            archivoTipo = ""
            camposFaltantes = @("Nombre completo", "RUT", "Carrera")
            motivoRechazo = "Faltan campos obligatorios en el formulario"
        }
    }
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Method Post -Uri "http://localhost:5678/webhook/hu005-notificacion-correccion" -Body $body -ContentType "application/json"
```

---

### **Test 5: Datos Inválidos (Error 400)**

```powershell
# Test con datos incompletos (debe fallar)
$body = @{
    idSolicitud = "SOL-TEST-005"
    # Falta campo estudiante
    error = @{
        tipo = "formato_incorrecto"
        mensaje = "Test"
    }
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Method Post -Uri "http://localhost:5678/webhook/hu005-notificacion-correccion" -Body $body -ContentType "application/json"
```

**Respuesta esperada:** Error 400 - Datos de entrada inválidos

---

## ✅ Verificar Resultados

### **En tu Email:**
- Debes recibir emails con templates HTML personalizados
- Cada tipo de error tiene un template diferente
- Verifica que los datos (nombre, ID, etc.) se muestren correctamente

### **En n8n:**
1. Abre: http://localhost:5678
2. Ve a "Executions" (menú izquierdo)
3. Deberías ver las ejecuciones de cada prueba
4. Click en cada una para ver el flujo completo

---

## 🔍 Troubleshooting

**Si no recibes emails:**
1. Verifica credenciales SMTP en n8n
2. Revisa que el workflow esté **Activo** (toggle verde)
3. Verifica en "Executions" si hay errores

**Si el webhook no responde:**
1. Verifica que n8n esté corriendo: `docker ps`
2. Verifica que el workflow esté activo
3. Revisa la URL del webhook

---

## 📊 Resultados Esperados

| Test | Tipo Error | Email | Código |
|------|-----------|-------|--------|
| 1 | Formato incorrecto | ✅ HTML | 200 |
| 2 | Tamaño excedido | ✅ HTML | 200 |
| 3 | Archivo corrupto | ✅ HTML | 200 |
| 4 | Campos faltantes | ✅ HTML | 200 |
| 5 | Datos inválidos | ❌ Error | 400 |
