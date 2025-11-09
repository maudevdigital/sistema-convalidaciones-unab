# 📋 Plan de Trabajo HU-005: Notificación al Estudiante para Corrección de Documentación

**Proyecto:** Sistema de Convalidaciones Académicas UNAB  
**Historia de Usuario:** HU-005  
**Developer:** [Asignar]  
**Tester:** [Asignar]  
**Sprint:** 2  
**Fecha Creación:** 9 de noviembre de 2025

---

## 🎯 Historia de Usuario

**Como** estudiante,  
**Quiero** recibir una notificación automática si la documentación que envié es incorrecta,  
**Para** poder corregir y enviar mi solicitud sin tener que iniciar el trámite desde cero.

---

## 📊 Contexto y Dependencias

### Flujo Previo
Esta HU se activa **después del fallo de HU-004** (Verificación de formato de documentos):

```
HU-001 → HU-004 → HU-005 (si error)
                ↓
              HU-006 (si OK)
```

### Dependencias
- ✅ **HU-001:** Recepción de solicitud (COMPLETADO)
- 🔄 **HU-004:** Verificación automática de documentos (PENDIENTE)
- 📧 Credenciales SMTP configuradas (reutilizar de HU-001)
- 📊 Google Sheets con hoja "Logs" (ya existe)

---

## ✅ Criterios de Aceptación (CA)

### **CA1: Detección de Rechazo de Documentación**
- **Given:** Una solicitud ha fallado la validación de documentos en HU-004
- **When:** El sistema detecta el error de validación
- **Then:** Se activa automáticamente el flujo de notificación HU-005
- **And:** Se capturan los detalles del error (tipo, motivo, ID solicitud)

### **CA2: Redacción Automática del Email de Corrección**
- **Given:** Se ha detectado un error de validación de documentos
- **When:** El sistema procesa el tipo de error (formato, tamaño, corrupción)
- **Then:** Se genera automáticamente un email con template predefinido según tipo error
- **And:** El email incluye: motivo rechazo, instrucciones corrección, link reenvío

### **CA3: Envío de Email al Estudiante**
- **Given:** El email de corrección ha sido generado correctamente
- **When:** El sistema procede al envío
- **Then:** El email se envía a la dirección proporcionada por el estudiante
- **And:** Se registra el evento en Google Sheets hoja "Logs"
- **And:** Se retorna confirmación de envío exitoso

---

## 📋 30 Tareas Detalladas para Taiga

### **FASE 1: Estructura y Documentación Inicial (Tareas 1-4)**

#### **T-001: Crear estructura de carpetas para HU-005**
- **Descripción:** Crear carpeta `hu005/` con subcarpetas: `docs/`, `workflows/`, `tests/`, `registro_imagenes_hu-005/`
- **Responsable:** Developer
- **Estimación:** 1 punto
- **Criterio Salida:** Estructura de carpetas completa con archivos `.gitkeep`
- **Commit:** `feat(hu005): crear estructura carpetas y documentación inicial`

#### **T-002: Documentar ficha técnica HU-005**
- **Descripción:** Crear `HU-05_FICHA_TECNICA.md` con CA en Given/When/Then, inputs/outputs JSON, flujo proceso, manejo errores
- **Responsable:** Developer + Tester
- **Estimación:** 3 puntos
- **Criterio Salida:** Documento completo siguiendo template de HU-01
- **Referencias:** `hu001/docs/HU-01_FICHA_TECNICA.md`

#### **T-003: Diseñar criterios de aceptación HU-005**
- **Descripción:** Definir mínimo 3 CA en formato Given/When/Then según sprint1.txt
- **Responsable:** Tester (PO o SM)
- **Estimación:** 2 puntos
- **Criterio Salida:** 3 CA documentados, medibles y observables
- **Validación:** Revisión con PO

#### **T-004: Crear casos de prueba detallados HU-005**
- **Descripción:** Documentar en `HU-05_CASOS_PRUEBA.md`: mínimo 3 casos por CA (válido/inválido/borde)
- **Responsable:** Tester
- **Estimación:** 5 puntos
- **Criterio Salida:** Mínimo 9 casos prueba con datos JSON y valores esperados
- **Referencias:** `hu001/docs/HU-01_CASOS_PRUEBA.md`

---

### **FASE 2: Diseño e Implementación Workflow (Tareas 5-9)**

#### **T-005: Diseñar workflow n8n para HU-005**
- **Descripción:** Diseñar flujo que: (1)Conecta con HU-004, (2)Detecta error, (3)Redacta email, (4)Envía email, (5)Registra log
- **Responsable:** Developer
- **Estimación:** 3 puntos
- **Criterio Salida:** Diagrama de flujo con nomenclatura estándar
- **Nomenclatura:** `IF-ValidacionDoc`, `Function-RedactarEmail`, `Email-Correccion`, `DB-Log`

#### **T-006: Implementar workflow HU-005 en n8n**
- **Descripción:** Crear `HU-005.json` con nodos: IF rama error, Function templates email, Email SMTP, Google Sheets logs
- **Responsable:** Developer
- **Estimación:** 8 puntos
- **Criterio Salida:** Workflow funcional importable en n8n
- **Credenciales:** Reutilizar de HU-001 (SMTP, Sheets)

#### **T-007: Crear templates de emails de corrección**
- **Descripción:** Diseñar 4 templates: (1)Formato incorrecto, (2)Tamaño excedido, (3)Archivo corrupto, (4)Campos faltantes
- **Responsable:** Developer + Tester
- **Estimación:** 5 puntos
- **Criterio Salida:** Templates HTML/texto con variables dinámicas
- **Contenido:** Motivo, instrucciones, link, contacto

#### **T-008: Integrar HU-005 con validación HU-004**
- **Descripción:** Conectar rama error del IF-ValidacionDoc de HU-004 al inicio HU-005
- **Responsable:** Developer
- **Estimación:** 5 puntos
- **Criterio Salida:** Datos pasan correctamente entre workflows
- **Datos:** ID solicitud, email estudiante, tipo error, detalles

#### **T-009: Implementar logging en Google Sheets**
- **Descripción:** Agregar nodo que registre en hoja "Logs": timestamp, ID, tipo_error, email_enviado, destinatario
- **Responsable:** Developer
- **Estimación:** 3 puntos
- **Criterio Salida:** Logs se guardan correctamente en Sheets
- **Validación:** Ejecutar y verificar registro

---

### **FASE 3: Testing y Validación (Tareas 10-13)**

#### **T-010: Crear casos de prueba manuales**
- **Descripción:** Crear `tests/casos_prueba_manuales.md` con procedimientos paso a paso para: TC5.1-Email formato incorrecto, TC5.2-Email tamaño excedido, TC5.3-Email múltiples errores, TC5.4-Verificar envío, TC5.5-Validar log. Incluir datos entrada, pasos, resultado esperado
- **Responsable:** Tester
- **Estimación:** 3 puntos
- **Criterio Salida:** Documento con 5+ casos manuales documentados
- **Referencias:** `hu001/docs/HU-01_CASOS_PRUEBA.md`

#### **T-011: Documentar manejo de errores HU-005**
- **Descripción:** Especificar en ficha técnica: error SMTP, credenciales, timeout, sin email. Definir acciones
- **Responsable:** Developer + Tester
- **Estimación:** 3 puntos
- **Criterio Salida:** Todos escenarios error documentados con acciones
- **Acciones:** Reintento, notificación admin, log detallado

#### **T-012: Ejecutar pruebas unitarias HU-005**
- **Descripción:** Ejecutar `test_hu05.sh` y documentar en `HU-05_RESULTADOS_PRUEBAS.md`
- **Responsable:** Tester
- **Estimación:** 5 puntos
- **Criterio Salida:** 100% casos ejecutados, evidencias capturadas
- **Métricas:** Emails enviados, logs registrados, tiempos <10s

#### **T-013: Capturar evidencias visuales workflow**
- **Descripción:** En `registro_imagenes_hu-005/` guardar: diagrama, nodos, email, logs, ejecución
- **Responsable:** Developer + Tester
- **Estimación:** 2 puntos
- **Criterio Salida:** Mínimo 5 capturas con descripciones
- **Formato:** PNG, nombradas descriptivamente

---

### **FASE 4: Documentación Final (Tareas 14-17)**

#### **T-014: Crear README.md para HU-005**
- **Descripción:** Documentar: descripción, objetivos, estructura, guía uso, configuración, casos prueba, troubleshooting
- **Responsable:** Developer
- **Estimación:** 5 puntos
- **Criterio Salida:** README completo siguiendo template HU-001
- **Referencias:** `hu001/README.md`

#### **T-015: Documentar resumen final HU-005**
- **Descripción:** Crear `HU-05_RESUMEN_FINAL.md`: entregables, cumplimiento CA, métricas, estado, próximos pasos
- **Responsable:** Developer + Tester
- **Estimación:** 3 puntos
- **Criterio Salida:** Resumen ejecutivo con tabla métricas
- **Validación:** 100% completado

#### **T-016: Exportar workflow JSON final**
- **Descripción:** Exportar desde n8n el workflow `HU-005.json` probado y funcional
- **Responsable:** Developer
- **Estimación:** 1 punto
- **Criterio Salida:** JSON en `hu005/workflows/` sin credenciales sensibles
- **Validación:** Reimportar y verificar

#### **T-017: Validar integración con HU-001 y HU-004**
- **Descripción:** Probar flujo end-to-end: HU-001→HU-004→HU-005. Documentar puntos integración
- **Responsable:** Developer + Tester
- **Estimación:** 5 puntos
- **Criterio Salida:** Flujo completo funciona sin errores
- **Evidencia:** Logs de ejecución exitosa

---

### **FASE 5: Control de Versiones GitHub (Tareas 18-21)**

#### **T-018: Commit inicial estructura HU-005**
- **Descripción:** Git commit estructura carpetas, README básico, .gitkeep
- **Responsable:** Developer
- **Estimación:** 1 punto
- **Mensaje:** `feat(hu005): crear estructura carpetas y documentación inicial`
- **Rama:** `feature/hu005-notificacion-correccion`

#### **T-019: Commit implementación workflow HU-005**
- **Descripción:** Git commit workflow JSON, templates emails, configuración nodos
- **Responsable:** Developer
- **Estimación:** 1 punto
- **Mensaje:** `feat(hu005): implementar workflow notificación corrección documentación`
- **Archivos:** `HU-005.json`, templates

#### **T-020: Commit documentación técnica completa**
- **Descripción:** Git commit ficha técnica, casos prueba, resultados, evidencias visuales
- **Responsable:** Developer + Tester
- **Estimación:** 1 punto
- **Mensaje:** `docs(hu005): agregar ficha técnica, casos prueba y resultados`
- **Archivos:** `HU-05_*.md`, imágenes

#### **T-021: Commit scripts de pruebas automatizadas**
- **Descripción:** Git commit `test_hu05.sh` con permisos ejecución, datos prueba, validaciones
- **Responsable:** Tester
- **Estimación:** 1 punto
- **Mensaje:** `test(hu005): agregar script pruebas automatizadas test_hu05.sh`
- **Validación:** Documentar uso en README

---

### **FASE 6: Gestión en Taiga (Tareas 22-24)**

#### **T-022: Crear tareas en Taiga para HU-005**
- **Descripción:** En Taiga crear HU-005 con: título, descripción, CA, estimación, estado. Agregar T-001 a T-030
- **Responsable:** Scrum Master
- **Estimación:** 2 puntos
- **Criterio Salida:** HU y todas tareas creadas en Taiga
- **Asignación:** Vincular developer+tester, sprint

#### **T-023: Subir documentación a Wiki Taiga**
- **Descripción:** En Wiki Sprint crear página HU-005 con links a documentos y adjuntar PDFs
- **Responsable:** Scrum Master
- **Estimación:** 2 puntos
- **Criterio Salida:** Todos documentos accesibles desde Wiki
- **Formato:** PDFs exportados de markdowns

#### **T-024: Actualizar tablero Taiga HU-005**
- **Descripción:** Mover tareas según progreso: Nueva→En curso→En revisión→Hecha. Actualizar horas, vincular commits
- **Responsable:** Scrum Master + Developer
- **Estimación:** 1 punto (continuo)
- **Criterio Salida:** Tablero refleja estado real
- **Frecuencia:** Actualizar diariamente

---

### **FASE 7: Calidad y Validaciones Finales (Tareas 25-27)**

#### **T-025: Validar CVEs dependencias emails**
- **Descripción:** Si hay librerías adicionales, validar con herramientas seguridad que no tengan CVEs
- **Responsable:** Developer
- **Estimación:** 2 puntos
- **Criterio Salida:** Reporte de seguridad sin CVEs críticos
- **Documentar:** Versiones usadas, fecha verificación

#### **T-026: Realizar Planning Poker HU-005**
- **Descripción:** Estimar esfuerzo HU-005 con equipo usando Fibonacci (1,2,3,5,8,13)
- **Responsable:** Todo el equipo
- **Estimación:** 1 punto
- **Criterio Salida:** Estimación consensuada documentada
- **Documentar:** Participantes, estimaciones, justificación

#### **T-027: Documentar Definition of Done HU-005**
- **Descripción:** Verificar checklist DoD: workflow funcional, 3+ casos por CA, logs, documentación, evidencias, integración, commits, Taiga
- **Responsable:** Scrum Master + Tester
- **Estimación:** 2 puntos
- **Criterio Salida:** Checklist 100% completado
- **Validación:** Revisión con equipo

---

### **FASE 8: Entrega y Demo (Tareas 28-30)**

#### **T-028: Preparar demo HU-005 para Review**
- **Descripción:** Crear video/presentación demo 7 min: intro, objetivo, CA1-3, logs, flujo integrado, próximos pasos
- **Responsable:** Developer + Tester
- **Estimación:** 5 puntos
- **Criterio Salida:** Video max 7 min con todos elementos
- **Formato:** MP4, diapositiva inicial equipo

#### **T-029: Ejecutar pruebas de integración completas**
- **Descripción:** Probar escenarios integrados: solicitud válida, PDF inválido, tamaño excedido, múltiples errores
- **Responsable:** Tester
- **Estimación:** 5 puntos
- **Criterio Salida:** Todos escenarios documentados en resultados
- **Evidencia:** Logs ejecución, capturas, tiempos

#### **T-030: Commit final y push a GitHub**
- **Descripción:** Git commit resumen final, todas evidencias, documentación 100%. Push rama, crear Pull Request
- **Responsable:** Developer
- **Estimación:** 2 puntos
- **Mensaje:** `feat(hu005): completar HU-005 notificación corrección documentación`
- **Acción:** Crear PR para revisión equipo

---

## 📊 Resumen de Estimaciones

### Por Fase
| Fase | Tareas | Puntos | Descripción |
|------|--------|--------|-------------|
| FASE 1 | T-001 a T-004 | 11 | Estructura y documentación inicial |
| FASE 2 | T-005 a T-009 | 24 | Diseño e implementación workflow |
| FASE 3 | T-010 a T-013 | 15 | Testing y validación |
| FASE 4 | T-014 a T-017 | 14 | Documentación final |
| FASE 5 | T-018 a T-021 | 4 | Control versiones GitHub |
| FASE 6 | T-022 a T-024 | 5 | Gestión en Taiga |
| FASE 7 | T-025 a T-027 | 5 | Calidad y validaciones |
| FASE 8 | T-028 a T-030 | 12 | Entrega y demo |
| **TOTAL** | **30 tareas** | **88 puntos** | **Estimación completa HU-005** |

### Distribución por Rol
| Rol | Tareas Asignadas | Puntos | % Carga |
|-----|------------------|--------|---------|
| Developer | 15 tareas | 48 puntos | 53% |
| Tester | 10 tareas | 28 puntos | 31% |
| Developer+Tester | 4 tareas | 11 puntos | 12% |
| Scrum Master | 2 tareas | 3 puntos | 3% |

---

## 🎯 Definition of Done (DoD) HU-005

### Checklist Final
- [ ] **Workflow funcional:** HU-005.json importable y ejecutable en n8n
- [ ] **Criterios Aceptación:** 3 CA cumplidos y documentados
- [ ] **Casos de Prueba:** Mínimo 9 casos (3 por CA) ejecutados exitosamente
- [ ] **Logs registrados:** Todos eventos registrados en Google Sheets
- [ ] **Templates email:** 4 templates funcionando correctamente
- [ ] **Integración:** Flujo HU-001→HU-004→HU-005 completo probado
- [ ] **Documentación:** 5 documentos completos (Ficha, Casos, Resultados, README, Resumen)
- [ ] **Evidencias:** Mínimo 5 capturas guardadas con descripciones
- [ ] **Scripts prueba:** test_hu05.sh ejecutable y documentado
- [ ] **Commits GitHub:** 4 commits realizados con mensajes convencionales
- [ ] **Taiga actualizado:** HU y tareas creadas, horas registradas, Wiki actualizado
- [ ] **Demo preparado:** Video/presentación max 7 min lista
- [ ] **Manejo errores:** Todos escenarios error documentados y probados
- [ ] **Nomenclatura:** Nodos siguen estándares (AUTH_, API_, MAP_, etc.)
- [ ] **Seguridad:** Sin credenciales hardcodeadas, CVEs validados

---

## 🚀 Próximos Pasos Después de HU-005

1. **HU-006:** Almacenamiento de documentos en Google Drive (si validación OK)
2. **HU-007:** Notificación a Dirección de Carrera
3. **Integración completa:** Unir todos los workflows en flujo maestro
4. **Testing E2E:** Pruebas end-to-end del sistema completo
5. **Sprint Review:** Presentar incremento completo Sprint 2

---

## 📚 Referencias y Recursos

### Documentos Base
- ✅ `Proyecto-Gestor-Convalidaciones-Academicas.txt` - Especificaciones generales
- ✅ `sprint1.txt` - Metodología y estándares Scrum
- ✅ `hu001/README.md` - Template HU completado
- ✅ `hu001/docs/HU-01_FICHA_TECNICA.md` - Template ficha técnica
- ✅ `hu001/workflows/HU-001-MEJORADO.json` - Referencia workflow

### Herramientas
- **n8n:** http://localhost:5678 (workflows)
- **Google Sheets:** Hoja "Logs" para registros
- **SMTP:** Credenciales Gmail/Ethereal de HU-001
- **Taiga:** Gestión de tareas y Sprint Backlog
- **GitHub:** Control de versiones y colaboración

### Convenciones Git
- **Formato commit:** `tipo(scope): mensaje`
- **Tipos:** feat, docs, test, fix, refactor, style, chore
- **Rama:** `feature/hu005-notificacion-correccion`
- **PR:** Incluir descripción completa y vincular a Taiga

---

## 👥 Asignaciones Recomendadas

### Developer Principal
- Responsable de: Tareas 1, 2, 5, 6, 8, 9, 14, 16, 18, 19, 25, 30
- Foco: Implementación workflow, integración, commits
- Horas estimadas: ~20-25 horas

### Tester (PO/SM)
- Responsable de: Tareas 3, 4, 10, 11, 12, 21, 29
- Foco: Casos prueba, validación, scripts automatizados
- Horas estimadas: ~15-18 horas

### Colaboración Developer+Tester
- Tareas: 7, 13, 15, 17, 20, 28
- Foco: Templates, evidencias, demo
- Horas estimadas: ~8-10 horas

### Scrum Master
- Tareas: 22, 23, 24, 26, 27
- Foco: Gestión Taiga, facilitación equipo
- Horas estimadas: ~5-7 horas

**Total estimado HU-005:** 48-60 horas (90 puntos Story Points)

---

## 📅 Cronograma Sugerido (Sprint 2)

### Semana 1 (4-8 Nov)
- Días 1-2: FASE 1 (T-001 a T-004) - Documentación inicial
- Días 3-5: FASE 2 inicio (T-005 a T-007) - Diseño workflow

### Semana 2 (11-15 Nov)
- Días 1-2: FASE 2 fin (T-008 a T-009) - Integración
- Días 3-5: FASE 3 (T-010 a T-013) - Testing

### Semana 3 (18-22 Nov)
- Días 1-2: FASE 4 (T-014 a T-017) - Documentación final
- Día 3: FASE 5+6 (T-018 a T-024) - Git y Taiga
- Días 4-5: FASE 7+8 (T-025 a T-030) - Calidad y demo

**Entrega:** 22 de noviembre (Sprint Review)

---

## ✅ Criterios de Éxito HU-005

### Métricas Técnicas
- ✅ 100% de emails de error enviados correctamente
- ✅ Tiempo envío email < 10 segundos
- ✅ 100% de eventos registrados en logs
- ✅ 0% pérdida de datos entre workflows
- ✅ Templates correctos según tipo error

### Métricas de Calidad
- ✅ 100% casos de prueba ejecutados (Pass)
- ✅ Cobertura mínima 3 casos por CA
- ✅ Documentación 100% completa
- ✅ Nomenclatura estándares cumplida
- ✅ Integración HU-001→HU-004→HU-005 funcional

### Métricas de Proceso
- ✅ 100% tareas en Taiga actualizadas
- ✅ 4+ commits realizados con mensajes convencionales
- ✅ Pull Request creado y revisado
- ✅ Demo preparado y presentado
- ✅ DoD 100% completado

---

## 📞 Contactos y Soporte

**Developer Principal:** [Nombre] - [email]  
**Tester:** [Nombre] - [email]  
**Scrum Master:** [Nombre] - [email]  
**Product Owner:** [Nombre] - [email]

**Repositorio GitHub:** [URL]  
**Tablero Taiga:** [URL]  
**Wiki Sprint:** [URL]

---

**Documento creado:** 9 de noviembre de 2025  
**Última actualización:** 9 de noviembre de 2025  
**Versión:** 1.0  
**Estado:** ✅ Listo para inicio Sprint 2

---

## 🎓 Notas Finales

Este plan está diseñado para ser ejecutado de manera **sistemática y profesional**, siguiendo las mismas prácticas exitosas del HU-001. 

**Claves para el éxito:**
1. Seguir el orden de las tareas (dependencias lógicas)
2. Documentar mientras se desarrolla (no al final)
3. Hacer commits frecuentes y pequeños
4. Actualizar Taiga diariamente
5. Solicitar revisiones tempranas (no esperar al final)
6. Mantener comunicación constante con el equipo
7. Validar integración constantemente

**¡Éxito en el desarrollo del HU-005!** 🚀
