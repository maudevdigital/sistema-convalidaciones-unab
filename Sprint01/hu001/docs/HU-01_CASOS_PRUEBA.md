# HU-01: Casos de Prueba - Plan de Pruebas Unitarias

## 📋 **Resumen de Pruebas**
- **Historia:** HU-01 - Recepción de Solicitud
- **Tester:** Por asignar  
- **Versión:** 1.0
- **Fecha:** 17 octubre 2025

## 🧪 **Casos de Prueba por Criterio de Aceptación**

### **CA1: Captura de Datos del Formulario**

#### **TC1.1 - Entrada Válida Completa**
| Campo | Valor |
|-------|-------|
| **ID:** | TC1.1 |
| **Descripción:** | Verificar captura correcta con todos los campos válidos |
| **Entrada:** | `{"nombre": "Ana García López", "rut": "15.234.567-8", "carrera": "Ingeniería Civil Industrial", "asignatura": "Investigación de Operaciones", "institucionOrigen": "Pontificia Universidad Católica", "documentos": "transcript.pdf", "email": "ana.garcia@estudiante.unab.cl"}` |
| **Resultado Esperado:** | HTTP 200 + JSON con success=true + ID generado |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

#### **TC1.2 - Campo Obligatorio Faltante**  
| Campo | Valor |
|-------|-------|
| **ID:** | TC1.2 |
| **Descripción:** | Verificar rechazo cuando falta campo 'rut' |
| **Entrada:** | `{"nombre": "Carlos Mendoza", "carrera": "Derecho", "asignatura": "Derecho Civil", "institucionOrigen": "Universidad de Valparaíso", "documentos": "notas.pdf"}` |
| **Resultado Esperado:** | HTTP 400 + JSON con errors=["Campo requerido: rut"] |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

#### **TC1.3 - Múltiples Campos Faltantes**
| Campo | Valor |
|-------|-------|
| **ID:** | TC1.3 |
| **Descripción:** | Verificar lista de errores con múltiples campos faltantes |
| **Entrada:** | `{"nombre": "Luis Torres", "carrera": "Medicina"}` |
| **Resultado Esperado:** | HTTP 400 + JSON con array de errores para rut, asignatura, institucionOrigen, documentos |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

### **CA2: Guardado Automático en Google Sheets**

#### **TC2.1 - Inserción Exitosa en Hoja Solicitudes**
| Campo | Valor |
|-------|-------|
| **ID:** | TC2.1 |
| **Descripción:** | Verificar inserción correcta en Google Sheets hoja "Solicitudes" |
| **Precondición:** | Datos válidos procesados correctamente |
| **Entrada:** | Datos del TC1.1 |
| **Resultado Esperado:** | Nueva fila en "Solicitudes" con todos los campos + Estado="Pendiente" |
| **Verificación:** | Consultar Google Sheets y confirmar registro |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

#### **TC2.2 - Log de Operación Registrado**
| Campo | Valor |
|-------|-------|
| **ID:** | TC2.2 |
| **Descripción:** | Verificar registro en hoja "Logs" de la operación |
| **Entrada:** | Mismos datos del TC2.1 |
| **Resultado Esperado:** | Nueva fila en "Logs" con Timestamp, ID, Status="Registro creado", Details="" |
| **Verificación:** | Consultar hoja "Logs" y confirmar entrada |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

#### **TC2.3 - Error de Conexión Google Sheets**
| Campo | Valor |
|-------|-------|
| **ID:** | TC2.3 |
| **Descripción:** | Simular falla de conexión a Google Sheets |
| **Precondición:** | Desconectar credenciales Google Sheets temporalmente |
| **Entrada:** | Datos válidos |
| **Resultado Esperado:** | HTTP 500 + mensaje de error técnico + log del error |
| **Verificación:** | Confirmar manejo de excepción sin crash del flujo |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

### **CA3: Confirmación de Recepción**

#### **TC3.1 - Email de Confirmación Enviado**
| Campo | Valor |
|-------|-------|
| **ID:** | TC3.1 |
| **Descripción:** | Verificar envío de email de confirmación exitoso |
| **Precondición:** | Solicitud procesada y guardada correctamente |
| **Entrada:** | Datos con email válido |
| **Resultado Esperado:** | Email enviado con ID de solicitud + próximos pasos |
| **Verificación:** | Revisar bandeja de entrada del email de prueba |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

#### **TC3.2 - Email sin Dirección Proporcionada**
| Campo | Valor |
|-------|-------|
| **ID:** | TC3.2 |
| **Descripción:** | Verificar comportamiento cuando no se proporciona email |
| **Entrada:** | Datos válidos sin campo 'email' |
| **Resultado Esperado:** | Solicitud procesada correctamente, email no enviado (sin error) |
| **Verificación:** | Confirmar procesamiento normal sin fallos |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

#### **TC3.3 - Email con Dirección Inválida**
| Campo | Valor |
|-------|-------|
| **ID:** | TC3.3 |
| **Descripción:** | Verificar comportamiento con email mal formateado |
| **Entrada:** | Datos válidos + email="direccion-incorrecta" |
| **Resultado Esperado:** | Solicitud procesada, error en envío de email logueado |
| **Verificación:** | Confirmar que el error de email no bloquea el proceso principal |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

## 🔍 **Casos de Prueba de Validación de Documentos**

#### **TC4.1 - Documento PDF Válido**
| Campo | Valor |
|-------|-------|
| **ID:** | TC4.1 |
| **Descripción:** | Verificar aceptación de archivo PDF válido |
| **Entrada:** | Archivo real con extensión .pdf |
| **Resultado Esperado:** | Documento almacenado en Google Drive + flujo continúa |
| **Verificación:** | Confirmar archivo en Google Drive |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

#### **TC4.2 - Documento No PDF**
| Campo | Valor |
|-------|-------|
| **ID:** | TC4.2 |
| **Descripción:** | Verificar rechazo de archivo no PDF |
| **Entrada:** | Archivo con extensión .docx o .jpg |
| **Resultado Esperado:** | Email al estudiante + flujo detenido + status actualizado |
| **Verificación:** | Confirmar email de corrección enviado |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

#### **TC4.3 - Documento Faltante**
| Campo | Valor |
|-------|-------|
| **ID:** | TC4.3 |
| **Descripción:** | Verificar comportamiento sin archivo adjunto |
| **Entrada:** | Datos válidos pero campo documentos vacío |
| **Resultado Esperado:** | Error en validación inicial + HTTP 400 |
| **Verificación:** | Confirmar rechazo en fase de validación |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

## 📊 **Casos de Prueba de Límites y Estrés**

#### **TC5.1 - Nombres con Caracteres Especiales**
| Campo | Valor |
|-------|-------|
| **ID:** | TC5.1 |
| **Descripción:** | Verificar manejo de caracteres especiales en nombres |
| **Entrada:** | `{"nombre": "José María Fernández-O'Connor Ñuñez", "rut": "12.345.678-9", ...}` |
| **Resultado Esperado:** | Procesamiento normal, caracteres preservados |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

#### **TC5.2 - Campos con Longitud Máxima**
| Campo | Valor |
|-------|-------|
| **ID:** | TC5.2 |
| **Descripción:** | Probar límites de longitud en campos de texto |
| **Entrada:** | Nombre con 255 caracteres, asignatura con 100 caracteres |
| **Resultado Esperado:** | Procesamiento normal o truncado controlado |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

#### **TC5.3 - Múltiples Solicitudes Simultáneas**  
| Campo | Valor |
|-------|-------|
| **ID:** | TC5.3 |
| **Descripción:** | Enviar 5 solicitudes simultáneas para probar concurrencia |
| **Entrada:** | 5 payloads diferentes enviados al mismo tiempo |
| **Resultado Esperado:** | Todas procesadas correctamente sin conflictos |
| **Resultado Obtenido:** | _[Por completar en prueba]_ |
| **Estado:** | 🟡 Pendiente |

## 📋 **Plantilla de Reporte de Ejecución**

### **Resumen de Ejecución**
- **Fecha de Ejecución:** _[Por completar]_
- **Ejecutado por:** _[Nombre del tester]_
- **Versión del Flujo:** _[Versión n8n]_
- **Ambiente:** _[Desarrollo/Testing]_

### **Resultados Globales**
- **Total Casos:** 15
- **Casos Pasados:** _[Por completar]_
- **Casos Fallidos:** _[Por completar]_  
- **Casos Bloqueados:** _[Por completar]_
- **% Éxito:** _[Por completar]_

### **Evidencias**
- [ ] Capturas de pantalla del flujo n8n
- [ ] Logs de ejecución de cada caso
- [ ] Screenshots de Google Sheets con datos insertados
- [ ] Emails de confirmación recibidos
- [ ] Export del flujo .json después de las pruebas

### **Issues Encontrados**
| ID | Descripción | Severidad | Estado |
|----|-------------|-----------|--------|
| _[Issue-001]_ | _[Descripción del problema]_ | _[Alta/Media/Baja]_ | _[Abierto/Cerrado]_ |

---
**Versión:** 1.0  
**Última Actualización:** 17 octubre 2025