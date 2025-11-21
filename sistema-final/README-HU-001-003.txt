SISTEMA DE CONVALIDACIONES ACADEMICAS - WORKFLOW HU-001-003 INTEGRADO

DESCRIPCION GENERAL

Este workflow automatiza el proceso completo de gestion de solicitudes de convalidacion academica en la Universidad Andres Bello. Integra la recepcion, validacion, procesamiento y resolucion de solicitudes de convalidacion de asignaturas provenientes de otras instituciones educativas.

El sistema maneja tres escenarios principales de decision:
1. Convalidada - La solicitud es aprobada y se genera acta oficial
2. No Convalidada - La solicitud es rechazada con motivo especifico
3. En Revision Adicional - Se requiere informacion adicional del estudiante


ARQUITECTURA DEL SISTEMA

El workflow se divide en dos flujos principales conectados:

FLUJO 1: RECEPCION Y VALIDACION DE SOLICITUDES
- Endpoint: POST /webhook/solicitud-convalidacion
- Proposito: Recibir, validar y registrar nuevas solicitudes de estudiantes

FLUJO 2: PROCESAMIENTO DE DECISIONES DEL DIRECTOR
- Endpoint: GET /webhook/decision-director
- Proposito: Procesar la decision del director y notificar resultados


TECNOLOGIAS Y SERVICIOS UTILIZADOS

Plataforma de Automatizacion:
- n8n version 1.115.3 Self Hosted
- Arquitectura basada en nodos y flujos visuales
- Modo de respuesta: lastNode

Base de Datos:
- Google Sheets como base de datos
- Hoja Solicitudes: 14 columnas (id, fecha, estudiante, rut, carrera, asignatura, institucionOrigen, documentos, linkDrive, driveFileId, tamanoMB, email, directorEmail, estado)
- Hoja Logs: 6 columnas (timestamp, id, evento, estudiante, estado, detalles)
- Autenticacion: OAuth2 (credential ID: ZM6AB0udQM5h68On)

Almacenamiento de Archivos:
- Google Drive para almacenar documentos PDF
- Autenticacion: OAuth2 (credential ID: PENDIENTE - requiere configuracion)
- Funcionalidad: Upload de archivos, generacion de enlaces compartidos

Servicio de Email:
- SMTP Gmail 
- Remitente: maudevchile@gmail.com
- Formatos: texto plano y HTML
- Soporte para archivos adjuntos

Generacion de PDF:
- API: API2PDF v2018 (https://v2018.api2pdf.com/chrome/html)
- Metodo: Conversion de HTML a PDF mediante Chrome
- Autenticacion: Header Auth (credential ID: GJpgmVVLmwUl8RYi)
- API Key: c903eb77-f5f2-4f41-880d-003254cc6c61


FLUJO DETALLADO - RECEPCION DE SOLICITUDES

PASO 1: RECEPCION INICIAL
Nodo: Webhook - Recepcion Solicitud
- Recibe solicitud via HTTP POST
- Formato: JSON con datos del estudiante y archivo PDF en base64

PASO 2: VALIDACION DE CAMPOS OBLIGATORIOS
Nodo: Function - Validar Campos
Campos requeridos:
- nombre: Nombre completo del estudiante
- rut: RUT chileno del estudiante
- carrera: Carrera en la que esta inscrito
- asignatura: Asignatura a convalidar
- institucionOrigen: Institucion de procedencia
- file o documentos: Archivo PDF con documentacion de respaldo

Genera ID unico: SOL-[RUT]-[timestamp]
Estado inicial: Pendiente

PASO 3: VALIDACION DE RUT CHILENO
Nodo: Function - Validar RUT
- Algoritmo: Modulo 11
- Formato aceptado: 12345678-9 o 123456789
- Digitos: 7-8 numeros mas digito verificador (0-9 o K)
- Validacion matematica del digito verificador

PASO 4: VALIDACION DE EMAILS
Nodo: Function - Validar Emails
- Email estudiante: Opcional pero debe ser valido si se proporciona
- Email director: Requerido, por defecto maudevchile@gmail.com
- Formato: RFC 5322 basico
- Longitud maxima: 254 caracteres

PASO 5: BIFURCACION DE VALIDACION
Nodo: IF - Validacion OK
- Ruta SI: Continua al procesamiento de documentos
- Ruta NO: Registra error y notifica al estudiante

PASO 6: VALIDACION DE FORMATO PDF
Nodo: Function - Validar PDF
Validaciones:
- Extension del archivo: debe terminar en .pdf
- MIME type: debe ser application/pdf
Resultado: Flag pdfsOk (true/false)

PASO 7: VALIDACION DE TAMANO
Nodo: Function - Validar Tamano
- Tamano maximo: 10 MB
- Calculo: Decodifica base64 y mide bytes
- Formula: (base64Length * 3) / 4 = bytes reales

PASO 8: BIFURCACION DE DOCUMENTO VALIDO
Nodo: IF - PDF Valido

RUTA EXITO (Documento valido):

PASO 9A: CONVERSION A BINARIO
Nodo: Code - Convertir a Binario
- Convierte base64 a Buffer de Node.js
- Prepara estructura binary para Google Drive
- Preserva metadatos: nombre, tipo MIME, extension

PASO 9B: SUBIDA A GOOGLE DRIVE
Nodo: Drive - Subir PDF
- Operacion: upload
- Nombre archivo: [ID]_[nombreOriginal]
- Retorna: ID de archivo, nombre, enlaces

PASO 9C: GENERACION DE ENLACES
Nodo: Function - Preparar Link Drive
- Link de visualizacion: https://drive.google.com/file/d/[ID]/view
- Link de descarga directa: https://drive.google.com/uc?id=[ID]&export=download

PASO 10: PREPARACION DE DATOS PARA REGISTRO
Nodo: Function - Preparar Datos Solicitud
Estructura de salida:
- id: Identificador unico de solicitud
- fecha: Timestamp ISO 8601
- estudiante: Nombre del estudiante
- rut: RUT formateado
- carrera: Nombre de la carrera
- asignatura: Asignatura a convalidar
- institucionOrigen: Institucion de procedencia
- documentos: Nombre del archivo PDF
- linkDrive: URL de visualizacion en Drive
- driveFileId: ID interno de Google Drive
- tamanoMB: Tamano del archivo en MB
- email: Email del estudiante
- directorEmail: Email del director
- estado: Pendiente

PASO 11: REGISTRO EN BASE DE DATOS
Nodo: DB - Registro Solicitud
- Operacion: append (agregar fila)
- Hoja: Solicitudes
- Mapeo automatico de columnas

PASO 12: REGISTRO DE LOG
Nodo: Function - Log Recepcion
Genera entrada de log:
- timestamp: Fecha y hora ISO
- id: ID de solicitud
- evento: Solicitud Recibida
- estudiante: Nombre
- estado: Pendiente
- detalles: Informacion de asignatura e institucion

Nodo: DB - Log
- Operacion: append
- Hoja: Logs

PASO 13: NOTIFICACION AL ESTUDIANTE
Nodo: Email - Confirmacion Estudiante
Contenido:
- Asunto: Confirmacion de Recepcion - Solicitud [ID]
- Cuerpo: Datos de la solicitud y proximos pasos
- Formato: Texto plano
- Tiempo estimado: 5-10 dias habiles

PASO 14: NOTIFICACION AL DIRECTOR
Nodo: Email - Notificacion Director
Contenido:
- Destinatario: maudevchile@gmail.com
- Asunto: Nueva Solicitud de Convalidacion - [Nombre]
- Formato: HTML
- Datos del estudiante en formato tabla
- PDF adjunto como attachment
- Botones de decision:
  * APROBAR SOLICITUD (enlace con decision=Convalidada)
  * SOLICITAR REVISION ADICIONAL (enlace con decision=En Revision Adicional)
  * Tres opciones de rechazo con motivos predefinidos

PASO 15: RESPUESTA AL CLIENTE
Nodo: Function - Success Response
Sistema de recuperacion de ID con manejo de errores:
- Intenta obtener ID de DB - Registro Solicitud
- Si falla, intenta de Function - Preparar Datos Solicitud
- Si falla, usa ID del input original
- Fallback: ERROR

Respuesta JSON:
{
  success: true,
  message: Solicitud recibida y procesada correctamente,
  id: [ID],
  solicitudId: [ID],
  fechaSolicitud: [ISO timestamp],
  estado: Pendiente,
  linkDrive: [URL],
  proximosPasos: Descripcion,
  tiempoEstimado: 5-10 dias habiles,
  code: 200
}

RUTA ERROR (Documento invalido):

PASO 9E: NOTIFICACION DE ERROR AL ESTUDIANTE
Nodo: Email - Error PDF
Contenido:
- Asunto: Error en Documentos - Solicitud de Convalidacion
- Problemas detectados
- Requisitos: Solo PDF, maximo 10 MB
- Instruccion: Reenviar con documentos correctos

PASO 10E: REGISTRO DE ERROR
Nodo: Function - Log Error PDF
- evento: Error en Documento PDF
- estado: Rechazada - PDF Invalido
- detalles: Lista de problemas detectados

PASO 11E: RESPUESTA DE ERROR
Nodo: Function - Error PDF Response
Respuesta JSON:
{
  success: false,
  message: Documento PDF no valido,
  errors: [lista de problemas],
  detalles: Requisitos especificos,
  id: [ID],
  code: 400
}


FLUJO DETALLADO - PROCESAMIENTO DE DECISION

PASO 1: RECEPCION DE DECISION
Nodo: Webhook - Decision Director
- Metodo: GET
- Parametros query:
  * decision: convalidada | no convalidada | en revision adicional
  * solicitudId: ID de la solicitud
  * motivo: Razon de la decision (URL encoded)

PASO 2: PROCESAMIENTO DE DECISION
Nodo: Function - Procesar Decision
Extrae y normaliza:
- decision: Convertida a minusculas
- solicitudId: ID de la solicitud
- motivoRechazo: Decodificado de URL
- timestamp: Momento de la decision

PASO 3: ACTUALIZACION DE ESTADO
Nodo: DB - Actualizar Estado
- Operacion: update
- Hoja: Solicitudes
- Columna de busqueda: id
- Columna actualizada: estado
- Valor: decision del director

PASO 4: RECUPERACION DE DATOS
Nodo: DB - Obtener Datos Solicitud
- Operacion: read/filter
- Hoja: Solicitudes
- Filtro: id igual a solicitudId
- Retorna: Fila completa con todos los datos del estudiante

PASO 5: BIFURCACION DE DECISION
Nodo: Switch - Decision
Version: 3.3 (rules-based)
Modo: Case sensitive
Evaluacion: estado.toLowerCase().trim()

REGLA 1: Convalidada
Condicion: estado === convalidada
Ruta: Generacion de acta de aprobacion

REGLA 2: No Convalidada
Condicion: estado === no convalidada
Ruta: Generacion de acta de rechazo

REGLA 3: En Revision Adicional
Condicion: estado === en revision adicional
Ruta: Notificacion sin acta formal


RUTA 1: SOLICITUD CONVALIDADA

PASO 6A: GENERACION DE HTML PARA ACTA
Nodo: Function - Generar HTML Aprobada
Estructura del documento:
- Encabezado: UNIVERSIDAD ANDRES BELLO
- Titulo: ACTA DE RESOLUCION DE CONVALIDACION
- Datos de la solicitud: Fecha, ID, Nombre, RUT, Carrera
- Resolucion: CONVALIDADA (centrado)
- Texto legal: Autorizacion para continuar plan de estudios
- Firma: Direccion de Carrera
- Estilos CSS: Fuente Arial, colores corporativos (rojo #E30613)

PASO 7A: CONVERSION A PDF
Nodo: API - Convertir HTML a PDF Aprobada
- API: https://v2018.api2pdf.com/chrome/html
- Metodo: POST
- Body: { html: [HTML generado] }
- Response: { pdf: [URL temporal del PDF] }
- Formato de respuesta: JSON

PASO 8A: DESCARGA DEL PDF
Nodo: HTTP - Descargar PDF Aprobada
- URL: Obtenida del campo pdf de API2PDF
- Response format: file (binary)
- Descarga el PDF generado como datos binarios

PASO 9A: NOTIFICACION AL ESTUDIANTE
Nodo: Email - Notificacion Aprobada
Contenido:
- Asunto: Solicitud Convalidada - [ID]
- Formato: HTML
- Mensaje: Felicitaciones, solicitud CONVALIDADA
- Detalles: Asignatura e institucion de origen
- Adjunto: PDF del acta oficial
- Remitente: Administracion Academica UNAB


RUTA 2: SOLICITUD NO CONVALIDADA

PASO 6B: GENERACION DE HTML PARA ACTA
Nodo: Function - Generar HTML Rechazada
Estructura similar a la aprobada con:
- Resolucion: NO CONVALIDADA (centrado)
- Seccion adicional: Motivo del Rechazo
- Contenido del motivo proporcionado por el director

PASO 7B: CONVERSION A PDF
Nodo: API - Convertir HTML a PDF Rechazada
Proceso identico al de aprobacion

PASO 8B: DESCARGA DEL PDF
Nodo: HTTP - Descargar PDF Rechazada
Proceso identico al de aprobacion

PASO 9B: NOTIFICACION AL ESTUDIANTE
Nodo: Email - Notificacion Rechazada
Contenido:
- Asunto: Solicitud No Convalidada - [ID]
- Formato: HTML
- Mensaje: Solicitud NO CONVALIDADA
- Detalles: Asignatura y motivo especifico
- Adjunto: PDF del acta oficial
- Informacion de contacto: Direccion de Carrera


RUTA 3: REVISION ADICIONAL

PASO 6C: NOTIFICACION DIRECTA
Nodo: Email - Notificacion Revision Adicional
Contenido:
- Asunto: Revision Adicional - Convalidacion [ID]
- Formato: HTML
- Mensaje: Solicitud requiere EN REVISION ADICIONAL
- Detalles: Asignatura, institucion y motivo
- Instruccion: Director contactara al estudiante
- Sin adjunto PDF (no hay acta formal en esta etapa)


CONVERGENCIA DE RUTAS

Todas las rutas convergen en:

PASO 10: REGISTRO DE DECISION EN LOG
Nodo: Function - Log Decision
Genera entrada:
- timestamp: Momento de la decision
- id: ID de solicitud
- evento: Decision Tomada
- estudiante: Nombre
- estado: Decision final
- detalles: Decision y motivo

Nodo: DB - Log
Registra en hoja Logs

PASO 11: RESPUESTA AL DIRECTOR
Nodo: Respond - Confirmacion Decision
Pagina HTML:
- Titulo: Decision Registrada Correctamente
- Mensaje: Confirmacion de la decision tomada
- Informacion: El estudiante recibira email con acta
- Link: Volver a n8n


MANEJO DE ERRORES

Error en Validacion de Campos:
- Captura: IF - Validacion OK (rama NO)
- Registro: Function - Log Error Validacion
- Notificacion: No se envia (error en datos basicos)
- Respuesta: JSON con code 400 y lista de errores

Error en Validacion de Documento PDF:
- Captura: IF - PDF Valido (rama NO)
- Registro: Function - Log Error PDF
- Notificacion: Email - Error PDF
- Respuesta: JSON con code 400 y requisitos

Error en Subida a Drive:
- Manejo: Try-catch en Function - Success Response
- Comportamiento: Continua el flujo sin Drive
- Consecuencia: linkDrive = Pendiente
- Email director: Se envia con PDF como adjunto


ESTADOS DE SOLICITUD

El sistema maneja los siguientes estados en el campo estado de Google Sheets:

1. Pendiente
   - Estado inicial al recibir solicitud
   - Esperando revision del director

2. Convalidada
   - Solicitud aprobada por el director
   - Se genera acta oficial de convalidacion
   - Estudiante autorizado a avanzar en plan de estudios

3. No Convalidada
   - Solicitud rechazada por el director
   - Se especifica motivo de rechazo
   - Se genera acta oficial de rechazo

4. En Revision Adicional
   - Solicitud requiere informacion o documentacion adicional
   - Director contactara al estudiante
   - No se genera acta formal en esta etapa

5. Rechazada (estados de error)
   - Rechazada - PDF Invalido: Documento no cumple requisitos
   - Rechazada: Error en validacion de campos


ESTRUCTURA DE LA BASE DE DATOS

Hoja: Solicitudes
Columnas:
1. id - Identificador unico formato SOL-[RUT]-[timestamp]
2. fecha - Timestamp ISO 8601 de recepcion
3. estudiante - Nombre completo del estudiante
4. rut - RUT chileno formateado
5. carrera - Nombre de la carrera
6. asignatura - Asignatura a convalidar
7. institucionOrigen - Institucion de procedencia
8. documentos - Nombre del archivo PDF
9. linkDrive - URL de visualizacion en Google Drive
10. driveFileId - ID interno de Google Drive
11. tamanoMB - Tamano del archivo en megabytes
12. email - Email del estudiante
13. directorEmail - Email del director de carrera
14. estado - Estado actual de la solicitud

Hoja: Logs
Columnas:
1. timestamp - Fecha y hora del evento
2. id - ID de solicitud relacionada
3. evento - Tipo de evento
4. estudiante - Nombre del estudiante
5. estado - Estado en ese momento
6. detalles - Informacion adicional del evento

Tipos de eventos registrados:
- Solicitud Recibida
- Error en Documento PDF
- Error de Validacion
- Decision Tomada


CREDENCIALES Y CONFIGURACION

Google Sheets OAuth2:
- ID: ZM6AB0udQM5h68On
- Nombre: Google Sheets account
- Permisos: Lectura y escritura en hojas
- Document ID: 1FWnWVXKy8mKIbO2JloHav9y7rYJYpVIqM1qcVhtg0yY

Google Drive OAuth2:
- ID: PENDIENTE
- Nombre: Google Drive account
- Estado: Requiere configuracion
- Permisos necesarios: Upload de archivos

Gmail SMTP:
- ID: 5PwfuVROJgdj9gpi
- Nombre: SMTP account
- Servidor: Gmail SMTP
- Remitente: maudevchile@gmail.com
- Configuracion: TLS/SSL

API2PDF Header Auth:
- ID: GJpgmVVLmwUl8RYi
- Nombre: API2PDF Auth
- Tipo: Header Authentication
- API Key: c903eb77-f5f2-4f41-880d-003254cc6c61
- Endpoint: https://v2018.api2pdf.com/chrome/html


ENDPOINTS DEL WORKFLOW

Endpoint 1: Recepcion de Solicitudes
- URL: http://localhost:5678/webhook/solicitud-convalidacion
- Metodo: POST
- Content-Type: application/json
- Body esperado:
  {
    nombre: string,
    rut: string,
    carrera: string,
    asignatura: string,
    institucionOrigen: string,
    email: string (opcional),
    directorEmail: string (opcional, default: maudevchile@gmail.com),
    file: {
      filename: string,
      data: string (base64),
      mimeType: string
    }
  }

Endpoint 2: Decision del Director
- URL: http://localhost:5678/webhook/decision-director
- Metodo: GET
- Parametros query:
  * decision: convalidada | no convalidada | en revision adicional
  * solicitudId: ID de la solicitud
  * motivo: Razon de la decision (URL encoded)
- Ejemplo:
  http://localhost:5678/webhook/decision-director?decision=Convalidada&solicitudId=SOL-123456789-1234567890&motivo=Documentacion%20completa


VALIDACIONES IMPLEMENTADAS

Validacion de RUT:
- Formato: 7-8 digitos mas digito verificador
- Digito verificador: 0-9 o K
- Algoritmo: Modulo 11
- Proceso:
  1. Eliminar puntos y guiones
  2. Separar cuerpo y digito verificador
  3. Multiplicar cada digito por factor (2-7, ciclico)
  4. Sumar resultados
  5. Calcular 11 - (suma mod 11)
  6. Comparar con digito verificador

Validacion de Email:
- Formato basico: usuario@dominio.extension
- Regex: /^[^\s@]+@[^\s@]+\.[^\s@]+$/
- Longitud maxima: 254 caracteres
- Campo opcional para estudiante
- Campo requerido para director

Validacion de Documento:
- Extension: Debe terminar en .pdf (case insensitive)
- MIME Type: Debe ser application/pdf
- Tamano: Maximo 10 MB (10485760 bytes)
- Formato: Base64 para transmision


CARACTERISTICAS DE SEGURIDAD

Validacion de Entrada:
- Todos los campos obligatorios verificados
- RUT validado con algoritmo modulo 11
- Emails validados con regex
- Documentos verificados en formato y tamano

Manejo de Errores:
- Try-catch en operaciones criticas
- Logs detallados de todos los eventos
- Mensajes de error descriptivos al usuario
- Respuestas HTTP con codigos apropiados

Trazabilidad:
- Cada solicitud recibe ID unico
- Todos los eventos registrados en Logs
- Timestamps ISO 8601 en todas las operaciones
- Registro de cambios de estado


FORMATO DE LOS DOCUMENTOS GENERADOS

Acta de Convalidacion:
- Formato: PDF generado desde HTML
- Encabezado institucional: Universidad Andres Bello
- Titulo: ACTA DE RESOLUCION DE CONVALIDACION
- Contenido:
  * Fecha de resolucion (formato chileno)
  * Identificador de solicitud
  * Datos del estudiante (nombre, RUT, carrera)
  * Detalle de asignatura e institucion de origen
  * Resolucion: CONVALIDADA o NO CONVALIDADA
  * Motivo (solo en caso de rechazo)
  * Firma de Direccion de Carrera
- Estilos: Fuente Arial, color corporativo rojo (#E30613)
- Estructura: HTML5 con CSS embebido


NOTIFICACIONES POR EMAIL

Email de Confirmacion al Estudiante:
- Enviado: Inmediatamente al recibir solicitud
- Formato: Texto plano
- Contenido:
  * Confirmacion de recepcion
  * Datos de la solicitud
  * Proximos pasos
  * Tiempo estimado de respuesta

Email de Notificacion al Director:
- Enviado: Junto con confirmacion al estudiante
- Formato: HTML
- Contenido:
  * Datos completos del estudiante
  * Documento PDF adjunto
  * Botones de decision con enlaces
  * Opciones: Aprobar, Revision Adicional, Rechazar (3 motivos)

Email de Resolucion al Estudiante:
- Enviado: Al procesar decision del director
- Formato: HTML
- Variantes:
  * Convalidada: Felicitaciones, PDF adjunto
  * No Convalidada: Lamento, motivo y PDF adjunto
  * Revision Adicional: Requiere mas informacion, sin PDF


CONSIDERACIONES DE DESPLIEGUE

Requisitos del Sistema:
- n8n version 1.115.3 o superior
- Node.js (requerido por n8n)
- Acceso a internet para APIs externas

Configuracion Necesaria:
1. Importar archivo HU-001-003-INTEGRADO.json en n8n
2. Configurar credencial de Google Sheets (OAuth2)
3. Configurar credencial de Google Drive (OAuth2)
4. Configurar credencial de Gmail SMTP
5. Configurar credencial de API2PDF (Header Auth)
6. Crear Google Sheet con estructura especificada
7. Actualizar IDs de documentos y hojas en nodos
8. Activar el workflow

Pruebas Recomendadas:
1. Test de recepcion con documento valido
2. Test de recepcion con documento invalido
3. Test de validacion de RUT
4. Test de decision Convalidada
5. Test de decision No Convalidada
6. Test de decision Revision Adicional
7. Test de manejo de errores


LIMITACIONES CONOCIDAS

1. Google Drive:
   - Credencial PENDIENTE de configuracion
   - Workflow funciona sin Drive (usa email attachments)
   - linkDrive queda como Pendiente

2. Tamano de Archivos:
   - Limite: 10 MB por documento
   - Archivos mayores son rechazados automaticamente

3. Concurrencia:
   - n8n procesa solicitudes secuencialmente
   - No hay manejo de cola para alta carga

4. Recuperacion:
   - No hay mecanismo de retry automatico
   - Errores requieren reenvio manual


METRICAS Y MONITOREO

Eventos Registrados en Logs:
- Solicitud Recibida
- Error en Documento PDF
- Error de Validacion
- Decision Tomada

Datos Capturados:
- Timestamp de cada evento
- ID de solicitud relacionada
- Estudiante involucrado
- Estado actual
- Detalles especificos del evento

Monitoreo Recomendado:
- Tasa de solicitudes exitosas vs rechazadas
- Tiempo promedio de decision
- Errores mas frecuentes
- Tasa de conversion por tipo de decision


MANTENIMIENTO

Tareas Periodicas:
- Revisar logs de errores
- Verificar espacio en Google Drive
- Renovar credenciales OAuth2 (cada 6 meses aprox)
- Actualizar API key de API2PDF si es necesario

Respaldo de Datos:
- Google Sheets mantiene historial automatico
- Exportar Sheets periodicamente
- Respaldar archivos de Google Drive

Actualizaciones:
- Verificar actualizaciones de n8n
- Revisar cambios en APIs externas
- Mantener documentacion actualizada


REFERENCIAS TECNICAS

Documentacion de APIs:
- n8n: https://docs.n8n.io
- Google Sheets API: https://developers.google.com/sheets
- Google Drive API: https://developers.google.com/drive
- API2PDF: https://www.api2pdf.com/documentation

Validacion de RUT:
- Algoritmo Modulo 11
- Servicio de Impuestos Internos de Chile

Formatos:
- ISO 8601 para timestamps
- RFC 5322 para emails
- Base64 para transferencia de archivos binarios


VERSION DEL DOCUMENTO

Version: 1.0
Fecha: 19 de noviembre de 2025
Sistema: HU-001-003 Integrado
Estado: Produccion
