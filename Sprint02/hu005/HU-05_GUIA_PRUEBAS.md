# HU-005: Guía de Pruebas

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

## 🧪 Ejecución de Pruebas Automatizadas

### **Script Completo de Pruebas**

Se ha creado un script único y completo que ejecuta toda la batería de pruebas:

**Ubicación:** `tests/HU-05_test.ps1`

**Características:**
- ✅ 9 casos de prueba automatizados
- ✅ Validación de 4 templates de email
- ✅ Pruebas de casos inválidos
- ✅ Medición de tiempos de respuesta
- ✅ Reporte detallado de resultados
- ✅ Verificación interactiva de emails
- ✅ Pruebas de integración opcionales

---

### **Ejecución Básica**

```powershell
# Navegar a la carpeta de tests
cd Sprint02\hu005\tests

# Ejecutar con tu email
.\HU-05_test.ps1 -Email "tu-email@gmail.com"
```

---

### **Ejecución con Parámetros Personalizados**

```powershell
# Especificar webhook personalizado
.\HU-05_test.ps1 -Email "test@test.com" -WebhookUrl "http://localhost:5678/webhook/hu005-notificacion-correccion"

# Omitir pruebas de integración
.\HU-05_test.ps1 -Email "test@test.com" -SkipIntegrationTests

# Ver ayuda del script
Get-Help .\HU-05_test.ps1 -Detailed
```

---

## 📋 Casos de Prueba Incluidos

El script ejecuta los siguientes tests:

### **CA1: Detección de Errores (4 tests)**
- **TC1.1:** Formato Incorrecto (.docx)
- **TC1.2:** Tamaño Excedido (15.8 MB)
- **TC1.3:** Archivo Corrupto
- **TC1.4:** Campos Faltantes

### **CA2: Templates Personalizados (1 test)**
- **TC2.5:** Caracteres Especiales (José María, tildes, guiones)

### **CA3: Validación de Respuestas (implícito en tests anteriores)**

### **Casos de Error (4 tests)**
- **TC4.1:** Sin Email Estudiante (esperado: 400)
- **TC4.2:** Tipo Error Inválido (esperado: 400)
- **TC4.3:** Email Mal Formado (esperado: 400)
- **TC4.5:** Sin ID Solicitud (esperado: 400)

### **Integración E2E (opcional)**
- Prueba completa HU-001 → HU-005

---

## 📊 Salida del Script

El script proporciona:

```
═══════════════════════════════════════════════════════════════
  📊 RESUMEN DE EJECUCIÓN
═══════════════════════════════════════════════════════════════

   📈 Total Tests Ejecutados: 9
   ✅ Tests Exitosos: 9
   ❌ Tests Fallidos: 0
   📊 Tasa de Éxito: 100.0%
   ⏱️  Tiempo Total: 18.45s

   📧 EMAILS ESPERADOS EN: tu-email@gmail.com

      1. Corrección Requerida - Formato de Archivo (TC1.1)
      2. Corrección Requerida - Tamaño Excedido (TC1.2)
      3. Corrección Requerida - Archivo Corrupto (TC1.3)
      4. Corrección Requerida - Campos Faltantes (TC1.4)
      5. Corrección Requerida - Caracteres Especiales (TC2.5)
```

---

## ✅ Verificar Resultados

### **En tu Email:**
- Debes recibir 5 emails con templates HTML personalizados
- Cada tipo de error tiene un template diferente
- Verifica que los datos (nombre, ID, etc.) se muestren correctamente
- Revisa que caracteres especiales (tildes, ñ, guiones) se vean bien

### **En n8n:**
1. Abre: http://localhost:5678
2. Ve a "Executions" (menú izquierdo)
3. Deberías ver ~9 ejecuciones exitosas
4. Click en cada una para ver el flujo completo

### **En PowerShell:**
- Cada test muestra: ✅ PASS o ❌ FAIL
- Tiempos de respuesta por test
- Resumen final con estadísticas

---

## 🔍 Troubleshooting

**Si no recibes emails:**
1. Verifica credenciales SMTP en n8n
2. Revisa que el workflow esté **Activo** (toggle verde)
3. Verifica en "Executions" si hay errores
4. Revisa logs del nodo Email-Correccion

**Si el webhook no responde:**
1. Verifica que n8n esté corriendo: `docker ps`
2. Verifica que el workflow HU-005 esté activo
3. Revisa la URL del webhook en el script
4. Prueba acceder manualmente: `http://localhost:5678`

**Si los tests fallan:**
1. Revisa logs en n8n (Executions)
2. Verifica que el webhook URL sea correcta
3. Asegúrate de usar tu email real en el parámetro `-Email`
4. Valida que credenciales SMTP estén configuradas

---

## 📊 Resultados Esperados

| Test | Descripción | Email | HTTP | Tiempo |
|------|-------------|-------|------|--------|
| TC1.1 | Formato incorrecto | ✅ | 200 | ~2s |
| TC1.2 | Tamaño excedido | ✅ | 200 | ~2s |
| TC1.3 | Archivo corrupto | ✅ | 200 | ~2s |
| TC1.4 | Campos faltantes | ✅ | 200 | ~2s |
| TC2.5 | Caracteres especiales | ✅ | 200 | ~2s |
| TC4.1 | Sin email (error) | ❌ | 400 | <1s |
| TC4.2 | Tipo inválido (error) | ❌ | 400 | <1s |
| TC4.3 | Email inválido (error) | ❌ | 400 | <1s |
| TC4.5 | Sin ID (error) | ❌ | 400 | <1s |

**Total esperado:** 9 tests, 5 emails recibidos, 100% tasa de éxito

---

## 🎯 Código de Salida

El script retorna:
- **0:** Todos los tests pasaron ✅
- **1:** Algunos tests fallaron ❌

Útil para integración con CI/CD en el futuro.
