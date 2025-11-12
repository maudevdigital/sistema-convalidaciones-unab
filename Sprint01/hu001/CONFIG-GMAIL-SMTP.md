# 📧 Configuración Gmail SMTP para n8n

## ✅ Checklist de Configuración

### Paso 1: Gmail - Verificación en 2 pasos
- [ ] Ir a: https://myaccount.google.com/security
- [ ] Activar "Verificación en 2 pasos"
- [ ] Completar el proceso con tu teléfono

### Paso 2: Gmail - Crear Contraseña de Aplicación
- [ ] Ir a: https://myaccount.google.com/apppasswords
- [ ] Crear nueva contraseña con nombre: "n8n-convalidaciones"
- [ ] **Copiar la contraseña de 16 caracteres** (formato: xxxx xxxx xxxx xxxx)
- [ ] Guardarla en lugar seguro

### Paso 3: n8n - Configurar Credenciales SMTP
- [ ] Abrir n8n: http://localhost:5678
- [ ] Abrir workflow "HU-001"
- [ ] Click en nodo "Email-Confirmación"
- [ ] Crear/editar credencial SMTP:

```
Host:       smtp.gmail.com
Port:       587
SSL/TLS:    ✓ Use TLS
User:       TU_EMAIL@gmail.com
Password:   [Contraseña de 16 caracteres de Google]
From Email: TU_EMAIL@gmail.com
From Name:  Sistema UNAB Convalidaciones
```

- [ ] Guardar credenciales
- [ ] Aplicar las mismas credenciales al nodo "Email-Error PDF"
- [ ] Actualizar campo "From Email" en ambos nodos a tu email

### Paso 4: Guardar Workflow
- [ ] Click en "Save" en la parte superior
- [ ] Asegurar que el workflow esté "Active"

### Paso 5: Probar
- [ ] Abrir el formulario HTML
- [ ] Completar todos los campos con tu email personal
- [ ] Adjuntar un PDF
- [ ] Enviar
- [ ] **Verificar que llegue el email a tu bandeja**

---

## 📝 Datos de Configuración SMTP Gmail

| Campo | Valor |
|-------|-------|
| **Servidor SMTP** | smtp.gmail.com |
| **Puerto** | 587 (TLS) o 465 (SSL) |
| **Seguridad** | TLS (STARTTLS) |
| **Autenticación** | Contraseña de aplicación |
| **Límite diario** | 500 emails/día |

---

## ⚠️ Solución de Problemas

### Error: "Invalid login"
- Verifica que estés usando la contraseña de aplicación (16 caracteres)
- NO uses tu contraseña normal de Gmail

### Error: "Connection timeout"
- Verifica que el puerto sea 587
- Asegúrate de tener TLS activado

### No llegan los emails
- Revisa la carpeta de SPAM
- Verifica que el email del destinatario sea correcto
- Comprueba los logs de n8n (click derecho en el nodo → "View executions")

### "Verification in 2 steps required"
- Debes activar la verificación en 2 pasos primero
- Solo entonces podrás crear contraseñas de aplicación

---

## 🔐 Seguridad

✅ **HACER:**
- Usar contraseña de aplicación (no tu contraseña real)
- Mantener la contraseña segura
- No compartir las credenciales

❌ **NO HACER:**
- NO subir las credenciales a GitHub
- NO compartir la contraseña de aplicación
- NO usar tu contraseña personal de Gmail

---

## 📊 Monitoreo

Para ver si los emails se están enviando:
1. En n8n, click derecho en el nodo de email
2. Selecciona "View executions"
3. Verifica el estado: ✅ Success o ❌ Error

---

## 🎯 Email de Prueba Rápida

Para probar sin usar el formulario:
1. En n8n, click en nodo "Email-Confirmación"
2. Click en "Execute Node"
3. Verifica que aparezca como exitoso

---

**Fecha de configuración:** 22/10/2025  
**Creado por:** Sistema de Convalidaciones UNAB  
**Workflow:** HU-001
