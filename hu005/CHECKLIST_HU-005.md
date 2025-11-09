# ✅ CHECKLIST HU-005: Control de Avance

**Proyecto:** Convalidaciones Académicas UNAB  
**Sprint:** 2 | **HU:** 005 - Notificación Corrección Documentación  
**Fecha Inicio:** ___/___/2025 | **Fecha Fin:** ___/___/2025

---

## 📊 RESUMEN RÁPIDO

- **Total Tareas:** 30
- **Story Points:** 90
- **Developer:** _________________ 
- **Tester:** _________________
- **Scrum Master:** _________________

---

## FASE 1: ESTRUCTURA Y DOCUMENTACIÓN (11 pts)

### T-001: Crear estructura carpetas ⬜ → 🔄 → ✅
- [ ] Crear carpeta `hu005/`
- [ ] Subcarpetas: `docs/`, `workflows/`, `tests/`, `registro_imagenes_hu-005/`
- [ ] Archivos `.gitkeep` en carpetas vacías
- **Commit:** `feat(hu005): crear estructura carpetas`

### T-002: Ficha técnica ⬜ → 🔄 → ✅
- [ ] Crear `HU-05_FICHA_TECNICA.md`
- [ ] Incluir CA en Given/When/Then
- [ ] Inputs/outputs JSON
- [ ] Flujo de proceso
- [ ] Manejo de errores

### T-003: Criterios de aceptación ⬜ → 🔄 → ✅
- [ ] CA1: Detección rechazo documentación
- [ ] CA2: Redacción email corrección
- [ ] CA3: Envío email al estudiante
- [ ] Formato Given/When/Then

### T-004: Casos de prueba ⬜ → 🔄 → ✅
- [ ] Crear `HU-05_CASOS_PRUEBA.md`
- [ ] Mínimo 3 casos por CA (total 9+)
- [ ] Casos válidos, inválidos, borde
- [ ] Datos JSON de prueba

**Milestone FASE 1:** ⬜ Documentación inicial completa

---

## FASE 2: DISEÑO E IMPLEMENTACIÓN (24 pts)

### T-005: Diseñar workflow ⬜ → 🔄 → ✅
- [ ] Diagrama de flujo en papel/digital
- [ ] Nomenclatura: IF-ValidacionDoc, Function-RedactarEmail, Email-Correccion, DB-Log
- [ ] Puntos de conexión con HU-004

### T-006: Implementar workflow ⬜ → 🔄 → ✅
- [ ] Crear workflow en n8n
- [ ] Exportar como `HU-005.json`
- [ ] Configurar credenciales (reutilizar HU-001)
- [ ] Probar ejecución básica
- **Commit:** `feat(hu005): implementar workflow`

### T-007: Templates emails ⬜ → 🔄 → ✅
- [ ] Template 1: Formato incorrecto (solo PDF)
- [ ] Template 2: Tamaño excedido (max 10MB)
- [ ] Template 3: Archivo corrupto
- [ ] Template 4: Campos faltantes
- [ ] Variables dinámicas funcionando

### T-008: Integrar con HU-004 ⬜ → 🔄 → ✅
- [ ] Conectar rama error de HU-004
- [ ] Pasar ID solicitud
- [ ] Pasar email estudiante
- [ ] Pasar tipo error
- [ ] Probar flujo completo HU-001→004→005

### T-009: Logging Google Sheets ⬜ → 🔄 → ✅
- [ ] Nodo Google Sheets configurado
- [ ] Registra timestamp
- [ ] Registra ID solicitud
- [ ] Registra tipo_error
- [ ] Registra email_enviado (sí/no)
- [ ] Registra destinatario

**Milestone FASE 2:** ⬜ Workflow funcional implementado

---

## FASE 3: TESTING Y VALIDACIÓN (15 pts)

### T-010: Script pruebas ⬜ → 🔄 → ✅
- [ ] Crear `tests/test_hu05.sh`
- [ ] TC5.1: Email formato incorrecto
- [ ] TC5.2: Email tamaño excedido
- [ ] TC5.3: Email múltiples errores
- [ ] TC5.4: Verificar envío email
- [ ] TC5.5: Validar log registro
- [ ] Permisos ejecución (`chmod +x`)
- **Commit:** `test(hu005): agregar script pruebas`

### T-011: Manejo errores ⬜ → 🔄 → ✅
- [ ] Error SMTP documentado
- [ ] Error credenciales email
- [ ] Timeout envío
- [ ] Estudiante sin email
- [ ] Acciones de reintento
- [ ] Notificación admin

### T-012: Ejecutar pruebas ⬜ → 🔄 → ✅
- [ ] Ejecutar `test_hu05.sh`
- [ ] Documentar en `HU-05_RESULTADOS_PRUEBAS.md`
- [ ] 100% emails enviados ✓
- [ ] Logs registrados ✓
- [ ] Templates correctos ✓
- [ ] Tiempos <10s ✓

### T-013: Evidencias visuales ⬜ → 🔄 → ✅
- [ ] Captura 1: Diagrama workflow
- [ ] Captura 2: Nodos configurados
- [ ] Captura 3: Ejemplo email enviado
- [ ] Captura 4: Logs en Sheets
- [ ] Captura 5: Ejecución exitosa
- [ ] Guardar en `registro_imagenes_hu-005/`

**Milestone FASE 3:** ⬜ Tests ejecutados y aprobados

---

## FASE 4: DOCUMENTACIÓN FINAL (14 pts)

### T-014: README.md ⬜ → 🔄 → ✅
- [ ] Descripción HU-005
- [ ] Objetivos
- [ ] Estructura archivos
- [ ] Guía uso rápida
- [ ] Configuración credenciales
- [ ] Casos de prueba
- [ ] Troubleshooting

### T-015: Resumen final ⬜ → 🔄 → ✅
- [ ] Crear `HU-05_RESUMEN_FINAL.md`
- [ ] Entregables completados
- [ ] Cumplimiento CA
- [ ] Métricas de calidad
- [ ] Estado final (100%)
- [ ] Próximos pasos

### T-016: Exportar JSON ⬜ → 🔄 → ✅
- [ ] Exportar workflow desde n8n
- [ ] Guardar en `hu005/workflows/HU-005.json`
- [ ] Verificar sin credenciales sensibles
- [ ] Reimportar para validar

### T-017: Validar integración ⬜ → 🔄 → ✅
- [ ] Probar HU-001→004→005 end-to-end
- [ ] Datos pasan correctamente
- [ ] Documentar puntos integración
- [ ] Capturar logs ejecución

**Milestone FASE 4:** ⬜ Documentación completa

---

## FASE 5: CONTROL VERSIONES GITHUB (4 pts)

### T-018: Commit inicial ⬜ → 🔄 → ✅
- [ ] Rama: `feature/hu005-notificacion-correccion`
- [ ] Commit estructura carpetas
- [ ] Mensaje: `feat(hu005): crear estructura carpetas`
- [ ] Push a GitHub

### T-019: Commit workflow ⬜ → 🔄 → ✅
- [ ] Commit `HU-005.json`
- [ ] Commit templates emails
- [ ] Mensaje: `feat(hu005): implementar workflow`
- [ ] Push a GitHub

### T-020: Commit documentación ⬜ → 🔄 → ✅
- [ ] Commit fichas técnicas
- [ ] Commit casos de prueba
- [ ] Commit resultados
- [ ] Mensaje: `docs(hu005): agregar ficha técnica`
- [ ] Push a GitHub

### T-021: Commit tests ⬜ → 🔄 → ✅
- [ ] Commit `test_hu05.sh`
- [ ] Mensaje: `test(hu005): agregar script pruebas`
- [ ] Push a GitHub

**Milestone FASE 5:** ⬜ Código versionado en GitHub

---

## FASE 6: GESTIÓN EN TAIGA (5 pts)

### T-022: Crear tareas Taiga ⬜ → 🔄 → ✅
- [ ] Importar desde CSV
- [ ] HU-005 creada con título y descripción
- [ ] 30 tareas agregadas (T-001 a T-030)
- [ ] Asignar responsables
- [ ] Vincular a Sprint 2

### T-023: Wiki Taiga ⬜ → 🔄 → ✅
- [ ] Crear página HU-005 en Wiki
- [ ] Link a ficha técnica
- [ ] Link a casos de prueba
- [ ] Link a resultados
- [ ] Adjuntar PDFs

### T-024: Actualizar tablero ⬜ → 🔄 → ✅
- [ ] Mover tareas: Nueva→En curso→Hecha
- [ ] Actualizar horas trabajadas
- [ ] Vincular commits de GitHub
- [ ] Mantener sincronizado

**Milestone FASE 6:** ⬜ Taiga actualizado

---

## FASE 7: CALIDAD Y VALIDACIONES (5 pts)

### T-025: Validar CVEs ⬜ → 🔄 → ✅
- [ ] Verificar dependencias email
- [ ] Sin CVEs conocidos
- [ ] Documentar versiones usadas
- [ ] Fecha verificación

### T-026: Planning Poker ⬜ → 🔄 → ✅
- [ ] Sesión con equipo
- [ ] Valores Fibonacci (1,2,3,5,8,13)
- [ ] Consenso: _____ puntos
- [ ] Documentar justificación

### T-027: DoD Checklist ⬜ → 🔄 → ✅
- [ ] Workflow funcional ✓
- [ ] 3+ casos por CA ✓
- [ ] Logs registrados ✓
- [ ] Documentación completa ✓
- [ ] Evidencias capturadas ✓
- [ ] Integración probada ✓
- [ ] Commits realizados ✓
- [ ] Taiga actualizado ✓

**Milestone FASE 7:** ⬜ Calidad validada

---

## FASE 8: ENTREGA Y DEMO (12 pts)

### T-028: Preparar demo ⬜ → 🔄 → ✅
- [ ] Video/presentación max 7 min
- [ ] 0:00 - Intro y equipo
- [ ] 0:30 - Objetivo HU-005
- [ ] 1:00 - Demo CA1 (detección rechazo)
- [ ] 2:00 - Demo CA2 (email generado)
- [ ] 3:00 - Demo CA3 (email enviado)
- [ ] 4:00 - Logs verificados
- [ ] 5:00 - Flujo integrado
- [ ] 6:00 - Próximos pasos

### T-029: Pruebas integración ⬜ → 🔄 → ✅
- [ ] Escenario 1: Solicitud válida→Sin notif
- [ ] Escenario 2: PDF inválido→Email error
- [ ] Escenario 3: Tamaño excedido→Email
- [ ] Escenario 4: Múltiples errores→Email
- [ ] Documentar en `HU-05_RESULTADOS_PRUEBAS.md`

### T-030: Commit final + PR ⬜ → 🔄 → ✅
- [ ] Commit resumen final
- [ ] Commit todas evidencias
- [ ] Mensaje: `feat(hu005): completar HU-005`
- [ ] Push rama `feature/hu005`
- [ ] Crear Pull Request
- [ ] Descripción completa en PR
- [ ] Solicitar revisión equipo

**Milestone FASE 8:** ⬜ HU-005 COMPLETADO ✅

---

## 🎯 DEFINITION OF DONE FINAL

### Checklist Entrega (Verificar antes de Sprint Review)

#### Implementación
- [ ] Workflow HU-005.json funcional
- [ ] Importable en n8n sin errores
- [ ] 4 templates de email funcionando
- [ ] Integración con HU-004 probada
- [ ] Logs en Google Sheets operando

#### Testing
- [ ] 9+ casos de prueba ejecutados
- [ ] 100% casos Pass (éxito)
- [ ] Script `test_hu05.sh` funcional
- [ ] Evidencias de ejecución capturadas

#### Documentación
- [ ] HU-05_FICHA_TECNICA.md ✓
- [ ] HU-05_CASOS_PRUEBA.md ✓
- [ ] HU-05_RESULTADOS_PRUEBAS.md ✓
- [ ] HU-05_RESUMEN_FINAL.md ✓
- [ ] README.md ✓
- [ ] 5+ capturas en registro_imagenes/ ✓

#### Calidad
- [ ] Nomenclatura estándares n8n
- [ ] Sin credenciales hardcodeadas
- [ ] Manejo de errores documentado
- [ ] CVEs validados (sin críticos)

#### Git y Taiga
- [ ] 4+ commits convencionales
- [ ] Rama feature/hu005 actualizada
- [ ] Pull Request creado
- [ ] Taiga 100% actualizado
- [ ] Horas registradas correctamente
- [ ] Wiki Sprint con documentos

#### Demo
- [ ] Video/presentación preparado
- [ ] Max 7 minutos
- [ ] Cubre todos los CA
- [ ] Muestra flujo integrado

---

## 📊 TRACKING DE PROGRESO

### Semana 1 (4-8 Nov)
- **FASE 1:** ⬜ 0% → ⬜ 25% → ⬜ 50% → ⬜ 75% → ⬜ 100% ✅
- **FASE 2:** ⬜ 0% → ⬜ 25% → ⬜ 50%
- **Puntos completados:** ___/90

### Semana 2 (11-15 Nov)
- **FASE 2:** ⬜ 75% → ⬜ 100% ✅
- **FASE 3:** ⬜ 0% → ⬜ 50% → ⬜ 100% ✅
- **Puntos completados:** ___/90

### Semana 3 (18-22 Nov)
- **FASE 4:** ⬜ 0% → ⬜ 100% ✅
- **FASE 5-8:** ⬜ 0% → ⬜ 100% ✅
- **Puntos completados:** 90/90 ✅

**Sprint Review:** 22 de noviembre ⬜

---

## 📝 NOTAS Y BLOQUEOS

### Bloqueos Encontrados
1. _______________________________________________
   - Fecha: ___/___
   - Resuelto: ⬜ Sí ⬜ No
   
2. _______________________________________________
   - Fecha: ___/___
   - Resuelto: ⬜ Sí ⬜ No

### Decisiones Importantes
1. _______________________________________________
   - Fecha: ___/___
   
2. _______________________________________________
   - Fecha: ___/___

### Mejoras Identificadas
1. _______________________________________________
2. _______________________________________________

---

## ✅ FIRMA DE COMPLETITUD

**Developer:** _________________ Fecha: ___/___/2025  
**Tester:** _________________ Fecha: ___/___/2025  
**Scrum Master:** _________________ Fecha: ___/___/2025

**Estado Final:** ⬜ COMPLETADO AL 100% ✅

---

**Documento:** Checklist HU-005  
**Versión:** 1.0  
**Para:** Control de avance Sprint 2  
**Uso:** Imprimir o mantener en Taiga
