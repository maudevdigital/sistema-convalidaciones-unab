# HU-05: Configuración de Logging en Google Sheets

## 📊 Estructura de Hoja "Logs"

### **Columnas Requeridas**

| Columna | Tipo | Descripción | Ejemplo |
|---------|------|-------------|---------|
| `timestamp` | DateTime | Fecha y hora del evento | `2025-11-09 14:30:15` |
| `idSolicitud` | String | ID único de la solicitud | `SOL-12345678-1699564800000` |
| `tipo_notificacion` | String | Tipo de notificación enviada | `error_documentacion` |
| `tipo_error` | String | Categoría específica del error | `formato_incorrecto`, `tamano_excedido`, `archivo_corrupto`, `campos_faltantes` |
| `email_enviado` | String | Confirmación de envío | `si` / `no` |
| `destinatario` | String | Email del estudiante | `juan.perez@estudiante.unab.cl` |
| `template_utilizado` | String | Template de email usado | `formato_incorrecto`, `tamano_excedido`, etc. |
| `estado_envio` | String | Estado final del envío | `exitoso`, `fallido`, `pendiente_reenvio` |
| `intentos_envio` | Number | Número de intentos realizados | `1`, `2`, `3` |
| `estudiante_nombre` | String | Nombre completo del estudiante | `Juan Pérez González` |
| `detalles_error` | String | Descripción detallada del error | `Formato de archivo no válido` |

---

## 🛠️ Paso 1: Crear Hoja "Logs" en Google Sheets

### **1.1: Crear Nueva Hoja**

1. Abrir Google Sheets: https://sheets.google.com
2. Seleccionar el spreadsheet de Convalidaciones
3. Click en **"+"** para agregar nueva hoja
4. Renombrar a **"Logs"**

### **1.2: Agregar Encabezados**

En la fila 1, agregar estos encabezados (copiar y pegar):

```
timestamp	idSolicitud	tipo_notificacion	tipo_error	email_enviado	destinatario	template_utilizado	estado_envio	intentos_envio	estudiante_nombre	detalles_error
```

### **1.3: Formatear Encabezados**

1. Seleccionar fila 1 completa
2. **Negrita:** Ctrl+B
3. **Fondo:** Color gris claro (#f3f3f3)
4. **Alineación:** Centro
5. **Congelar:** Ver → Congelar → 1 fila

---

## 🛠️ Paso 2: Configurar Validación de Datos

### **2.1: Validar Columna "tipo_error"**

1. Seleccionar columna `D` (tipo_error)
2. Datos → Validación de datos
3. Criterios: **Lista de elementos**
4. Lista:
```
formato_incorrecto
tamano_excedido
archivo_corrupto
campos_faltantes
```
5. **Rechazar entrada inválida:** ✅
6. Guardar

### **2.2: Validar Columna "email_enviado"**

1. Seleccionar columna `E` (email_enviado)
2. Datos → Validación de datos
3. Criterios: **Lista de elementos**
4. Lista:
```
si
no
```
5. Guardar

### **2.3: Validar Columna "estado_envio"**

1. Seleccionar columna `H` (estado_envio)
2. Datos → Validación de datos
3. Criterios: **Lista de elementos**
4. Lista:
```
exitoso
fallido
pendiente_reenvio
```
5. Guardar

---

## 🛠️ Paso 3: Configurar Formato Condicional

### **3.1: Resaltar Estados de Envío**

**Estados Exitosos (Verde):**
1. Seleccionar columna `H` (estado_envio)
2. Formato → Formato condicional
3. Regla: **El texto es exactamente**
4. Valor: `exitoso`
5. Estilo de formato: **Fondo verde claro (#d9ead3)**
6. Listo

**Estados Fallidos (Rojo):**
1. Nueva regla en columna `H`
2. Regla: **El texto es exactamente**
3. Valor: `fallido`
4. Estilo: **Fondo rojo claro (#f4cccc)**

**Estados Pendientes (Amarillo):**
1. Nueva regla en columna `H`
2. Regla: **El texto es exactamente**
3. Valor: `pendiente_reenvio`
4. Estilo: **Fondo amarillo claro (#fff2cc)**

### **3.2: Resaltar Emails No Enviados**

1. Seleccionar columna `E` (email_enviado)
2. Formato → Formato condicional
3. Regla: **El texto es exactamente**
4. Valor: `no`
5. Estilo: **Fondo naranja claro (#fce5cd)**

---

## 🛠️ Paso 4: Agregar Fórmulas de Resumen

### **4.1: Crear Hoja "Dashboard"**

1. Agregar nueva hoja llamada **"Dashboard"**
2. En celda `A1`: **"Resumen HU-005 - Notificaciones"**

### **4.2: Métricas Clave**

En la hoja **Dashboard**, agregar:

```
A3: Total Notificaciones Enviadas
B3: =COUNTIF(Logs!E:E,"si")

A4: Total Errores Detectados
B4: =COUNTA(Logs!B:B)-1

A5: Tasa de Envío Exitoso
B5: =COUNTIF(Logs!H:H,"exitoso")/COUNTA(Logs!B:B)*100 & "%"

A6: Emails Pendientes de Reenvío
B6: =COUNTIF(Logs!H:H,"pendiente_reenvio")

A8: Errores por Tipo
A9: Formato Incorrecto
B9: =COUNTIF(Logs!D:D,"formato_incorrecto")
A10: Tamaño Excedido
B10: =COUNTIF(Logs!D:D,"tamano_excedido")
A11: Archivo Corrupto
B11: =COUNTIF(Logs!D:D,"archivo_corrupto")
A12: Campos Faltantes
B12: =COUNTIF(Logs!D:D,"campos_faltantes")
```

---

## 🔧 Paso 5: Configurar n8n para Escribir en Logs

### **5.1: Verificar Credenciales Google Sheets**

En n8n:
1. Ir a **Credentials** → **Google Sheets OAuth2**
2. Verificar que está autenticado
3. Test de conexión debe ser exitoso

### **5.2: Configurar Nodo GoogleSheets-Log**

Ya está configurado en `HU-005.json`, pero verificar:

```javascript
{
  "operation": "append",
  "sheetName": "Logs",
  "columns": {
    "mappings": [
      { "column": "timestamp", "value": "={{$json.timestamp}}" },
      { "column": "idSolicitud", "value": "={{$json.idSolicitud}}" },
      { "column": "tipo_notificacion", "value": "={{$json.tipo_notificacion}}" },
      { "column": "tipo_error", "value": "={{$json.tipo_error}}" },
      { "column": "email_enviado", "value": "={{$json.email_enviado}}" },
      { "column": "destinatario", "value": "={{$json.destinatario}}" },
      { "column": "template_utilizado", "value": "={{$json.template_utilizado}}" },
      { "column": "estado_envio", "value": "={{$json.estado_envio}}" },
      { "column": "intentos_envio", "value": "={{$json.intentos_envio}}" },
      { "column": "estudiante_nombre", "value": "={{$json.estudiante_nombre}}" },
      { "column": "detalles_error", "value": "={{$json.detalles_error}}" }
    ]
  }
}
```

---

## 🧪 Paso 6: Prueba de Logging

### **Test de Inserción Manual**

Insertar fila de prueba en Google Sheets:

| timestamp | idSolicitud | tipo_notificacion | tipo_error | email_enviado | destinatario | template_utilizado | estado_envio | intentos_envio | estudiante_nombre | detalles_error |
|-----------|-------------|-------------------|------------|---------------|--------------|-------------------|--------------|----------------|-------------------|----------------|
| 2025-11-09 14:30:15 | SOL-TEST-001 | error_documentacion | formato_incorrecto | si | test@unab.cl | formato_incorrecto | exitoso | 1 | Juan Test | Formato no válido |

### **Test desde n8n**

Ejecutar workflow HU-005 con datos de prueba y verificar:
- ✅ Nueva fila aparece en hoja "Logs"
- ✅ Timestamp formateado correctamente
- ✅ Estado "exitoso" resaltado en verde
- ✅ Métricas en Dashboard actualizadas

---

## 📊 Paso 7: Queries Útiles para Análisis

### **7.1: Filtrar por Tipo de Error**

```
=QUERY(Logs!A:K, "SELECT * WHERE D = 'formato_incorrecto' ORDER BY A DESC")
```

### **7.2: Contar Emails Enviados Hoy**

```
=COUNTIFS(Logs!A:A, ">="&TODAY(), Logs!E:E, "si")
```

### **7.3: Listar Estudiantes con Errores Pendientes**

```
=QUERY(Logs!A:K, "SELECT B, J, D WHERE H = 'pendiente_reenvio' ORDER BY A DESC")
```

### **7.4: Promedio de Intentos por Envío**

```
=AVERAGE(Logs!I:I)
```

---

## ✅ Checklist de Configuración

### Google Sheets
- ⬜ Hoja "Logs" creada con 11 columnas
- ⬜ Encabezados formateados (negrita, fondo gris)
- ⬜ Primera fila congelada
- ⬜ Validación de datos en columnas D, E, H
- ⬜ Formato condicional en columnas E y H
- ⬜ Hoja "Dashboard" creada con métricas

### n8n
- ⬜ Credenciales Google Sheets configuradas
- ⬜ Nodo GoogleSheets-Log configurado
- ⬜ Mapeo de columnas correcto (11/11)
- ⬜ Test de inserción exitoso

### Validación
- ⬜ Fila de prueba insertada manualmente
- ⬜ Workflow HU-005 ejecutado correctamente
- ⬜ Dashboard muestra métricas actualizadas
- ⬜ Formato condicional funciona correctamente

---

**Versión:** 1.0  
**Última Actualización:** 9 noviembre 2025  
**Estado:** ✅ Configuración de logging completada
