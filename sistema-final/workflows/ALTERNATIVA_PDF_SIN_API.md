# 🔄 Alternativa: Generar PDFs sin API2PDF

Si no quieres usar API2PDF, n8n tiene un nodo integrado para generar PDFs.

## ✅ Ventajas del método sin API:
- ✅ Gratis (sin límites)
- ✅ No requiere credenciales externas
- ✅ Más rápido (sin llamadas HTTP)
- ✅ Mayor privacidad (datos no salen de n8n)

## ❌ Desventajas:
- ❌ PDFs más básicos (menos personalización)
- ❌ Requiere instalar dependencias en n8n

---

## 🛠️ Opción 1: Usar HTML to PDF Node (Community)

1. **Instalar el nodo:**
   ```bash
   # Entrar al contenedor de n8n
   docker exec -it n8n /bin/sh
   
   # Instalar el nodo
   npm install n8n-nodes-html-to-pdf
   
   # Reiniciar n8n
   exit
   docker restart n8n
   ```

2. **En el workflow:**
   - Reemplazar nodo "API - Convertir HTML a PDF"
   - Por nodo "HTML to PDF"
   - Configurar input HTML

---

## 🛠️ Opción 2: Usar Function Node con Puppeteer

**Desventaja:** Requiere instalar Puppeteer en el contenedor Docker de n8n.

```javascript
// En nodo Function
const puppeteer = require('puppeteer');

const browser = await puppeteer.launch();
const page = await browser.newPage();

await page.setContent($json.actaHtml);
const pdfBuffer = await page.pdf({
  format: 'A4',
  printBackground: true
});

await browser.close();

return {
  binary: {
    data: {
      data: pdfBuffer.toString('base64'),
      mimeType: 'application/pdf',
      fileName: 'acta.pdf'
    }
  }
};
```

---

## 🎯 Recomendación:

**Para desarrollo/práctica:**
- ✅ Usar **API2PDF** (plan gratuito, 100 PDFs/mes es suficiente)
- ✅ Fácil de configurar
- ✅ PDFs profesionales

**Para producción:**
- ✅ Implementar solución propia con Puppeteer
- ✅ Sin límites
- ✅ Mayor control

---

## 📝 Configuración Rápida API2PDF:

```bash
1. Registro: https://portal.api2pdf.com/register
2. Obtener API Key del dashboard
3. En n8n → Settings → Credentials → New Credential
4. Tipo: Header Auth
5. Name: API2PDF Auth
6. Header Name: Authorization
7. Value: [tu-api-key]
8. Guardar y asignar a nodos de conversión PDF
```

**¡Listo para generar PDFs profesionales!** 🎉
