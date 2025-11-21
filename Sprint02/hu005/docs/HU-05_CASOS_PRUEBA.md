HU-05: Notificación de Corrección de Documentos - Casos de Prueba

 Información General

Historia de Usuario: HU-05 - Notificación de Corrección de Documentos  
Fecha de Pruebas: 12 noviembre 2025  
Responsable: Equipo QA  
Ambiente: Local (n8n en Docker, localhost:5678)  

 Objetivo de las Pruebas

Validar que el sistema de notificaciones automáticas:
1. Detecte correctamente los diferentes tipos de errores
2. Genere emails personalizados según el tipo de error
3. Envíe correctamente las notificaciones vía SMTP
4. Registre todos los eventos en el sistema de logging
5. Maneje correctamente los casos de error

 CA1: Detección Automática del Rechazo de Documentación

TC1.1: Recepción de Notificación Formato Incorrecto

Objetivo: Verificar que el webhook recibe correctamente notificaciones de formato incorrecto

Precondiciones:
- n8n corriendo en http://localhost:5678
- Workflow HU-005 activo
- Credenciales SMTP configuradas

Datos de Entrada:
{
  "idSolicitud": "SOL-TEST-001",
  "estudiante": {
    "nombre": "Juan Pérez",
    "rut": "12345678-5",
    "email": "tu-email@gmail.com"
  },
  "error": {
    "tipo": "formato_incorrecto",
    "mensaje": "El archivo no es un PDF válido",
    "detalles": {
      "archivoNombre": "certificado.docx",
      "archivoTipo": "application/msword",
      "tamanoMB": "2.5",
      "motivoRechazo": "Solo se aceptan archivos en formato PDF"
    }
  }
}

Pasos:
1. Abrir PowerShell en directorio de trabajo
2. Ejecutar comando POST con datos de prueba
3. Verificar respuesta HTTP 200
4. Revisar email recibido en bandeja de entrada
5. Validar contenido del email contra template esperado

Resultado Esperado:
-  Respuesta HTTP 200 con {"success": true}
-  Email recibido en menos de 10 segundos
-  Asunto: "Corrección requerida: Formato de archivo - Solicitud SOL-TEST-001"
-  Cuerpo incluye nombre del estudiante "Juan Pérez"
-  Menciona archivo rechazado: "certificado.docx"
-  Incluye instrucciones para convertir a PDF

Criterio de Aceptación: TC1.1 PASS si email llega con contenido correcto

TC1.2: Recepción de Notificación Tamaño Excedido

Objetivo: Validar notificación cuando archivo supera límite de tamaño

Datos de Entrada:
{
  "idSolicitud": "SOL-TEST-002",
  "estudiante": {
    "nombre": "María González",
    "rut": "98765432-1",
    "email": "tu-email@gmail.com"
  },
  "error": {
    "tipo": "tamano_excedido",
    "mensaje": "Archivo supera los 10 MB permitidos",
    "detalles": {
      "archivoNombre": "programa_asignatura.pdf",
      "archivoTipo": "application/pdf",
      "tamanoMB": "15.8",
      "motivoRechazo": "El archivo supera el tamaño máximo de 10 MB"
    }
  }
}

Pasos:
1. Ejecutar POST con datos de tamaño excedido
2. Verificar respuesta exitosa
3. Revisar email recibido

Resultado Esperado:
-  HTTP 200 con confirmación
-  Email con template de "Tamaño Excedido"
-  Menciona: "programa_asignatura.pdf - 15.8 MB"
-  Indica límite: "Máximo permitido: 10 MB"
-  Incluye sugerencias de compresión

Criterio de Aceptación: TC1.2 PASS si template correcto se envía

TC1.3: Recepción de Notificación Archivo Corrupto

Objetivo: Verificar manejo de archivos PDF corruptos

Datos de Entrada:
{
  "idSolicitud": "SOL-TEST-003",
  "estudiante": {
    "nombre": "Pedro Silva",
    "rut": "11223344-5",
    "email": "tu-email@gmail.com"
  },
  "error": {
    "tipo": "archivo_corrupto",
    "mensaje": "El archivo PDF está dañado y no puede ser leído",
    "detalles": {
      "archivoNombre": "notas.pdf",
      "archivoTipo": "application/pdf",
      "tamanoMB": "3.2",
      "motivoRechazo": "El archivo está corrupto o dañado"
    }
  }
}

Resultado Esperado:
-  Email con template "Archivo Corrupto"
-  Explica posibles causas
-  Sugiere regenerar el PDF
-  Incluye instrucciones de verificación

Criterio de Aceptación: TC1.3 PASS

TC1.4: Logging de Recepción en Google Sheets

Objetivo: Verificar que cada notificación se registra en Sheets

Precondiciones:
- Google Sheets API configurado
- Hoja "Logs_HU005" creada

Pasos:
1. Ejecutar TC1.1, TC1.2 y TC1.3
2. Abrir Google Sheets
3. Verificar registros en hoja "Logs_HU005"

Resultado Esperado:
-  Mínimo 3 registros nuevos
-  Cada registro tiene: Timestamp, ID_Solicitud, Email_Destino, Tipo_Error, Estado_Envio
-  Todos los registros muestran "Exitoso"

Criterio de Aceptación: TC1.4 PASS si todos los envíos están logueados

 CA2: Redacción de Email de Corrección Personalizado

TC2.1: Template Formato Incorrecto Personalizado

Objetivo: Validar personalización del template de formato incorrecto

Datos de Entrada: (TC1.1)

Validaciones en el Email Recibido:
- Saludo incluye nombre completo: "Estimado/a Juan Pérez"
- ID de solicitud visible: "SOL-TEST-001"
- Nombre de archivo incorrecto: "certificado.docx"
- Tipo de archivo: "application/msword"
- Instrucciones claras de corrección
- Link para reenviar documentación
- Datos de contacto soporte técnico
- Formato HTML bien renderizado (sin errores visuales)

Criterio de Aceptación: TC2.1 PASS si todas las validaciones 

TC2.2: Template Tamaño Excedido Personalizado

Objetivo: Validar personalización del template de tamaño

Datos de Entrada: (TC1.2)

Validaciones:
- Nombre estudiante: "María González"
- ID solicitud: "SOL-TEST-002"
- Archivo: "programa_asignatura.pdf"
- Tamaño actual mostrado: "15.8 MB"
- Tamaño máximo indicado: "10 MB"
- Sugerencias de compresión incluidas
- Links a herramientas (Smallpdf, Adobe)
- HTML bien formateado

Criterio de Aceptación: TC2.2 PASS

TC2.3: Template Archivo Corrupto Personalizado

Objetivo: Validar template de archivo corrupto

Datos de Entrada: (TC1.3)

Validaciones:
- Nombre: "Pedro Silva"
- ID: "SOL-TEST-003"
- Archivo: "notas.pdf"
- Explicación del problema
- Posibles causas listadas
- Instrucciones de solución
- Datos de contacto

Criterio de Aceptación: TC2.3 PASS

TC2.4: Template Campos Faltantes

Objetivo: Validar template cuando faltan campos en formulario

Datos de Entrada:
{
  "idSolicitud": "SOL-TEST-004",
  "estudiante": {
    "nombre": "Ana Torres",
    "rut": "55667788-9",
    "email": "tu-email@gmail.com"
  },
  "error": {
    "tipo": "campos_faltantes",
    "mensaje": "Información incompleta en la solicitud",
    "detalles": {
      "archivoNombre": "",
      "archivoTipo": "",
      "camposFaltantes": ["Nombre completo", "RUT", "Carrera"],
      "motivoRechazo": "Faltan campos obligatorios en el formulario"
    }
  }
}

Validaciones:
- Lista de campos faltantes visible
- Instrucciones para completar formulario
- Link al formulario
- Formato de lista (bullets) correcto

Criterio de Aceptación: TC2.4 PASS

TC2.5: Caracteres Especiales en Nombres

Objetivo: Verificar manejo de caracteres especiales y tildes

Datos de Entrada:
{
  "idSolicitud": "SOL-TEST-CHARS",
  "estudiante": {
    "nombre": "José María Fernández-O'Connor",
    "rut": "16789012-3",
    "email": "tu-email@gmail.com"
  },
  "error": {
    "tipo": "formato_incorrecto",
    "mensaje": "Archivo en formato incorrecto",
    "detalles": {
      "archivoNombre": "certificado_josé_maría.docx",
      "archivoTipo": "application/msword",
      "tamanoMB": "1.5",
      "motivoRechazo": "Solo PDF"
    }
  }
}

Resultado Esperado:
-  Nombre renderizado correctamente: "José María Fernández-O'Connor"
-  No hay caracteres corruptos (�)
-  Tildes y acentos visibles
-  Apóstrofes y guiones correctos
-  Archivo con tildes: "certificado_josé_maría.docx"

Criterio de Aceptación: TC2.5 PASS si encoding UTF-8 correcto

 CA3: Envío del Email al Estudiante

TC3.1: Envío Exitoso vía SMTP Gmail

Objetivo: Verificar que emails se envían correctamente por SMTP

Precondiciones:
- SMTP configurado: smtp.gmail.com:465
- Credenciales válidas en n8n

Pasos:
1. Ejecutar TC1.1
2. Monitorear ejecución en n8n
3. Verificar nodo "Email-Correccion" exitoso (verde)
4. Revisar bandeja de entrada en <10 segundos

Resultado Esperado:
-  Nodo SMTP verde en n8n
-  Email recibido en bandeja
-  From: "Sistema de Convalidaciones UNAB <maudevchile@gmail.com>"
-  To: email del estudiante
-  No cae en spam

Criterio de Aceptación: TC3.1 PASS

TC3.2: Tiempo de Entrega del Email

Objetivo: Validar que emails llegan en tiempo razonable

Pasos:
1. Anotar timestamp del POST request
2. Anotar timestamp de recepción en email
3. Calcular diferencia

Resultado Esperado:
-  Email recibido en <10 segundos
-  Típicamente: 2-5 segundos

Criterio de Aceptación: TC3.2 PASS si <10s

TC3.3: Registro de Envío Exitoso en Sheets

Objetivo: Verificar logging de envíos exitosos

Pasos:
1. Ejecutar caso válido
2. Ir a Google Sheets hoja "Logs_HU005"
3. Verificar última fila

Datos Esperados en Sheets:
  Timestamp   ID_Solicitud   Email_Destino   Tipo_Error   Estado_Envio   Mensaje  

  2025-11-12T14:30:00   SOL-TEST-001   tu-email@gmail.com   formato_incorrecto   Exitoso   Email enviado correctamente  

Criterio de Aceptación: TC3.3 PASS

TC3.4: Respuesta HTTP 200 al Sistema Llamador

Objetivo: Validar respuesta del webhook

Pasos:
1. Ejecutar POST y capturar respuesta

Respuesta Esperada:
{
  "success": true,
  "mensaje": "Notificación enviada correctamente",
  "destinatario": "tu-email@gmail.com",
  "tipoError": "formato_incorrecto",
  "timestamp": "2025-11-12T14:30:00Z"
}

HTTP Status: 200 OK

Criterio de Aceptación: TC3.4 PASS

 Casos de Error y Validaciones

TC4.1: Datos de Entrada Inválidos - Sin Email

Objetivo: Verificar validación de campos obligatorios

Datos de Entrada:
{
  "idSolicitud": "SOL-TEST-ERROR-001",
  "estudiante": {
    "nombre": "Test Sin Email",
    "rut": "12345678-9"
  },
  "error": {
    "tipo": "formato_incorrecto",
    "mensaje": "Test"
  }
}

Resultado Esperado:
-  HTTP 400 Bad Request
-  Mensaje: "Falta campo requerido: estudiante.email"
-  NO se envía email
-  Se registra error en logs

Criterio de Aceptación: TC4.1 PASS si retorna 400

TC4.2: Tipo de Error No Reconocido

Objetivo: Validar manejo de tipos de error inválidos

Datos de Entrada:
{
  "idSolicitud": "SOL-TEST-ERROR-002",
  "estudiante": {
    "nombre": "Test Error",
    "rut": "12345678-9",
    "email": "test@test.com"
  },
  "error": {
    "tipo": "tipo_invalido_xyz",
    "mensaje": "Test"
  }
}

Resultado Esperado:
-  HTTP 400
-  Mensaje indica tipos válidos: formato_incorrecto, tamano_excedido, archivo_corrupto, campos_faltantes

Criterio de Aceptación: TC4.2 PASS

TC4.3: Email con Formato Inválido

Objetivo: Validar detección de emails mal formados

Datos de Entrada:
{
  "idSolicitud": "SOL-TEST-ERROR-003",
  "estudiante": {
    "nombre": "Test Email Inválido",
    "rut": "12345678-9",
    "email": "email-invalido-sin-arroba.com"
  },
  "error": {
    "tipo": "formato_incorrecto",
    "mensaje": "Test"
  }
}

Resultado Esperado:
-  HTTP 400
-  Mensaje: "Email inválido"
-  NO se intenta envío SMTP

Criterio de Aceptación: TC4.3 PASS

TC4.4: Simulación Falla SMTP

Objetivo: Verificar manejo de errores de envío

Pasos:
1. Desactivar credenciales SMTP temporalmente
2. Ejecutar caso válido
3. Observar comportamiento

Resultado Esperado:
-  HTTP 500 Internal Server Error
-  Mensaje técnico de error SMTP
-  Error registrado en Sheets hoja "Logs_Errores"
-  Detalles incluyen: timestamp, error SMTP, intentos

Criterio de Aceptación: TC4.4 PASS si se logea error

TC4.5: Payload JSON Malformado

Objetivo: Validar manejo de JSON inválido

Datos de Entrada:
{
  "idSolicitud": "SOL-TEST",
  "estudiante": {
    "nombre": "Test"
    // JSON inválido: falta coma
    "email": "test@test.com"
  }
}

Resultado Esperado:
-  HTTP 400
-  Mensaje: "Error al parsear JSON"

Criterio de Aceptación: TC4.5 PASS

 Casos de Integración

TC5.1: Integración HU-001 → HU-004 → HU-005

Objetivo: Probar flujo completo end-to-end

Precondiciones:
- Workflow integrado activo
- HU-001 recibe solicitud con PDF inválido

Pasos:
1. Enviar solicitud a HU-001 con archivo .docx
2. HU-004 detecta formato incorrecto
3. HU-004 llama a HU-005 via HTTP Request
4. HU-005 envía notificación

Resultado Esperado:
-  HU-001 procesa solicitud
-  HU-004 rechaza documento
-  HTTP Request exitoso a HU-005
-  Email de corrección enviado
-  Todo en <5 segundos

Criterio de Aceptación: TC5.1 PASS si flujo completo funciona

TC5.2: Múltiples Notificaciones Simultáneas

Objetivo: Verificar manejo de carga

Pasos:
1. Enviar 5 POST requests simultáneos
2. Diferentes tipos de error
3. Verificar que todos se procesan

Resultado Esperado:
-  5 emails recibidos
-  5 registros en Sheets
-  Todos con HTTP 200
-  No hay pérdida de datos

Criterio de Aceptación: TC5.2 PASS

 Resumen de Casos de Prueba

Por Criterio de Aceptación:

  CA   Casos   Total  

  CA1   TC1.1, TC1.2, TC1.3, TC1.4   4  
  CA2   TC2.1, TC2.2, TC2.3, TC2.4, TC2.5   5  
  CA3   TC3.1, TC3.2, TC3.3, TC3.4   4  
  Error   TC4.1, TC4.2, TC4.3, TC4.4, TC4.5   5  
  Integración   TC5.1, TC5.2   2  
  TOTAL     20  

Por Tipo:

  Tipo   Cantidad  

  Casos Válidos   9  
  Casos Inválidos   5  
  Casos Borde   4  
  Integración   2  

Cobertura:
-  Mínimo requerido: 3 casos por CA
-  Actual: 4-5 casos por CA
-  Cobertura: 133% del mínimo

 Comandos PowerShell para Ejecución

Todos los comandos están documentados en: HU-05_GUIA_PRUEBAS.md

Ejecución rápida de todos los casos:
Ejecutar desde: Sprint02/hu005/tests/
.\HU-05_test.ps1 -Email "tu-email@gmail.com"

 Criterios de Éxito Global

- Todos los TC de CA1 pasan (4/4)
- Todos los TC de CA2 pasan (5/5)
- Todos los TC de CA3 pasan (4/4)
- Manejo de errores correcto (5/5)
- Integración funciona (2/2)
- 0 defectos críticos
- Cobertura >100% del mínimo requerido

ESTADO GLOBAL:  PASS si todo 

Documento elaborado: 12 noviembre 2025  
Próxima revisión: Antes de Sprint Review  
Responsable: Tester QA  
Aprobado por: Scrum Master
