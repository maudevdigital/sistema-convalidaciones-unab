# 🎯 RESUMEN RÁPIDO - Configuración Gmail SMTP

## Pasos a seguir AHORA:

### 1️⃣ En Google (2 pestañas abiertas en tu navegador):

**Pestaña 1 - Activar verificación 2 pasos:**
→ https://myaccount.google.com/security
→ Buscar "Verificación en 2 pasos"
→ ACTIVAR (necesitarás tu teléfono)

**Pestaña 2 - Crear contraseña de app:**
→ https://myaccount.google.com/apppasswords
→ Nombre: "n8n-convalidaciones"
→ COPIAR la contraseña de 16 caracteres
→ Ejemplo: abcd efgh ijkl mnop

---

### 2️⃣ En n8n (http://localhost:5678):

1. Workflows → "HU-001"
2. Click en nodo "Email-Confirmación"
3. En "Credential to connect with" → Create New
4. Llenar:
   - Host: `smtp.gmail.com`
   - Port: `587`
   - ✓ Use TLS
   - User: `TU_EMAIL@gmail.com`
   - Password: `[los 16 caracteres copiados]`
5. Save
6. Cambiar "From Email" a tu email
7. Repetir para nodo "Email-Error PDF"
8. Save Workflow

---

### 3️⃣ PROBAR:

```powershell
# Abrir el formulario
Start-Process "developers\lucas\hu001\formulario-convalidacion-unab.html"
```

- Llenar con TU email
- Adjuntar PDF
- Enviar
- ✅ Revisar tu bandeja de Gmail

---

## ⚡ ¿Problemas?

- **"Invalid login"** → Usar contraseña de app (16 caracteres), NO tu contraseña normal
- **No llega email** → Revisar SPAM
- **"2-step required"** → Activar verificación en 2 pasos primero

---

**Email que configurarás:** ___________________________

**Contraseña de app (temporal):** ___ ___ ___ ___

**Estado:**
- [ ] Verificación 2 pasos activada
- [ ] Contraseña de app creada
- [ ] n8n configurado
- [ ] Email de prueba enviado ✅
