# 🔧 Configuración Opcional de APIs para HU-01

## 📋 Estado Actual
- ✅ **Lógica de validación**: Funciona perfectamente
- ✅ **Webhook endpoint**: Activo y respondiendo  
- ⚠️ **Google Sheets**: Requiere credenciales (opcional)
- ⚠️ **Email SMTP**: Requiere credenciales (opcional)

## 🎯 Prioridades para Demostración

### **CRÍTICO - Debe Funcionar:**
1. **Webhook recibe datos** ✅
2. **Validación de campos obligatorios** ✅ 
3. **Validación formato PDF** ✅
4. **Respuestas HTTP correctas** ✅

### **OPCIONAL - Para Experiencia Completa:**
1. **Guardar en Google Sheets** ⚠️
2. **Enviar emails de confirmación** ⚠️

## 🚀 Opción A: Demo Sin APIs (5 minutos)

### Ventajas:
- ✅ Demuestra la lógica principal del HU-01
- ✅ Valida todos los criterios de aceptación
- ✅ No requiere configuración compleja
- ✅ Perfecto para evaluación académica

### Pasos:
1. Activar flujo (ignorar advertencias)
2. Ejecutar `test_hu01.sh`
3. Verificar respuestas JSON
4. Documentar resultados

## 🔧 Opción B: Configuración Completa (30 minutos)

### Google Sheets:
```bash
# 1. Ir a Google Cloud Console
# 2. Crear proyecto nuevo
# 3. Habilitar Google Sheets API
# 4. Crear Service Account
# 5. Descargar JSON de credenciales
# 6. En n8n: Settings > Credentials > Google Sheets
```

### SMTP (Gmail):
```bash
# 1. Activar autenticación de 2 factores en Gmail
# 2. Generar "App Password"
# 3. En n8n: Settings > Credentials > SMTP
# Usuario: tu-email@gmail.com
# Password: app-password-generado
# Host: smtp.gmail.com
# Port: 587
```

## 🎯 Recomendación

**Para Sprint 1 y evaluación académica**: Usar **Opción A**

### ¿Por qué?
1. **Foco en HU-01**: La lógica de negocio está implementada
2. **Criterios cumplidos**: Todos los CA del HU-01 se pueden validar
3. **Time-to-demo**: Funciona inmediatamente
4. **Evaluación clara**: El evaluador ve exactamente qué hace el HU-01

### ¿Cuándo usar Opción B?
- Para demo completa al cliente
- Para mostrar integración end-to-end
- Si tienes tiempo extra
- Para impresionar con funcionalidad completa