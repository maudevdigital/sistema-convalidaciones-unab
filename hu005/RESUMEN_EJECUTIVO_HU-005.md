# 📋 HU-005: Resumen Ejecutivo y Guía Rápida

**Proyecto:** Sistema de Convalidaciones Académicas UNAB  
**Sprint:** 2  
**Fecha:** 9 de noviembre de 2025  
**Estado:** 📝 Planificado - Listo para inicio

---

## 🎯 Historia de Usuario

**Como** estudiante,  
**Quiero** recibir una notificación automática si mi documentación es incorrecta,  
**Para** poder corregirla sin reiniciar el trámite desde cero.

---

## 📊 Números Clave

| Métrica | Valor |
|---------|-------|
| **Total Tareas** | 30 tareas |
| **Story Points** | 90 puntos |
| **Horas Estimadas** | 48-60 horas |
| **Fases** | 8 fases |
| **Criterios Aceptación** | 3 CA |
| **Casos de Prueba** | Mínimo 9 (3 por CA) |
| **Templates Email** | 4 templates |
| **Commits GitHub** | 4+ commits |
| **Duración Sprint** | 3 semanas |

---

## ✅ Criterios de Aceptación (Resumen)

### CA1: Detección de Rechazo ✓
Cuando HU-004 detecta error → HU-005 se activa automáticamente

### CA2: Redacción Email ✓
Sistema genera email predefinido según tipo error detectado

### CA3: Envío Email ✓
Email enviado al estudiante + log registrado en Google Sheets

---

## 📋 8 Fases del Proyecto

### **FASE 1: Estructura y Documentación** (11 pts)
- T-001: Crear carpetas
- T-002: Ficha técnica
- T-003: Criterios aceptación
- T-004: Casos de prueba

### **FASE 2: Diseño e Implementación** (24 pts)
- T-005: Diseñar workflow
- T-006: Implementar en n8n
- T-007: Templates emails
- T-008: Integrar con HU-004
- T-009: Logging Sheets

### **FASE 3: Testing y Validación** (15 pts)
- T-010: Script pruebas
- T-011: Manejo errores
- T-012: Ejecutar pruebas
- T-013: Capturar evidencias

### **FASE 4: Documentación Final** (14 pts)
- T-014: README.md
- T-015: Resumen final
- T-016: Exportar JSON
- T-017: Validar integración

### **FASE 5: Control Versiones GitHub** (4 pts)
- T-018: Commit estructura
- T-019: Commit workflow
- T-020: Commit docs
- T-021: Commit tests

### **FASE 6: Gestión en Taiga** (5 pts)
- T-022: Crear tareas
- T-023: Wiki Sprint
- T-024: Actualizar tablero

### **FASE 7: Calidad y Validaciones** (5 pts)
- T-025: Validar CVEs
- T-026: Planning Poker
- T-027: DoD checklist

### **FASE 8: Entrega y Demo** (12 pts)
- T-028: Preparar demo
- T-029: Pruebas integración
- T-030: Commit final + PR

---

## 👥 Distribución de Trabajo

| Rol | Tareas | Puntos | Horas Aprox |
|-----|--------|--------|-------------|
| **Developer** | 15 tareas | 48 pts | 20-25 hrs |
| **Tester** | 10 tareas | 28 pts | 15-18 hrs |
| **Developer+Tester** | 4 tareas | 11 pts | 8-10 hrs |
| **Scrum Master** | 2 tareas | 3 pts | 5-7 hrs |

---

## 🔧 Componentes Técnicos

### Workflow n8n (HU-005.json)
```
1. IF-ValidacionDoc → Detecta error de HU-004
2. Function-RedactarEmail → Selecciona template según error
3. Email-Correccion → Envía email con SMTP
4. DB-Log → Registra en Google Sheets
5. Respond → Confirma envío
```

### 4 Templates de Email
1. **Formato incorrecto** → Solo se aceptan PDFs
2. **Tamaño excedido** → Máximo 10 MB
3. **Archivo corrupto** → No se puede leer el PDF
4. **Campos faltantes** → Información incompleta

### Integración con HU-004
```
HU-001 (Recepción) 
   ↓
HU-004 (Validación) 
   ↓ (si error)
HU-005 (Notificación) ← ESTE WORKFLOW
```

---

## 📅 Cronograma Sprint 2

### **Semana 1** (4-8 Nov)
- Lunes-Martes: Documentación inicial (FASE 1)
- Miércoles-Viernes: Diseño workflow (FASE 2 inicio)

### **Semana 2** (11-15 Nov)
- Lunes-Martes: Implementación (FASE 2 fin)
- Miércoles-Viernes: Testing (FASE 3)

### **Semana 3** (18-22 Nov)
- Lunes-Martes: Documentación final (FASE 4)
- Miércoles: Git + Taiga (FASE 5+6)
- Jueves-Viernes: Calidad + Demo (FASE 7+8)

**Entrega Sprint Review:** 22 de noviembre

---

## 🎯 Definition of Done

### Checklist (15 items)
- [ ] Workflow funcional en n8n
- [ ] 3 CA cumplidos
- [ ] 9+ casos prueba ejecutados
- [ ] Logs en Google Sheets
- [ ] 4 templates funcionando
- [ ] Integración HU-004 probada
- [ ] 5 documentos completos
- [ ] 5+ evidencias visuales
- [ ] Script test_hu05.sh
- [ ] 4+ commits GitHub
- [ ] Taiga actualizado
- [ ] Demo 7 min preparado
- [ ] Manejo errores documentado
- [ ] Nomenclatura estándares
- [ ] Sin credenciales hardcoded

---

## 🚀 Cómo Empezar (Quick Start)

### Paso 1: Preparación
```bash
# Crear rama de trabajo
git checkout -b feature/hu005-notificacion-correccion

# Crear estructura de carpetas
mkdir -p hu005/{docs,workflows,tests,registro_imagenes_hu-005}
```

### Paso 2: Documentación
- Copiar template de `hu001/docs/HU-01_FICHA_TECNICA.md`
- Adaptar para HU-005
- Definir 3 CA y casos de prueba

### Paso 3: Implementación
- Diseñar workflow en papel/diagrama
- Implementar en n8n
- Crear 4 templates de email
- Conectar con HU-004

### Paso 4: Testing
- Crear script `test_hu05.sh`
- Ejecutar pruebas
- Capturar evidencias
- Documentar resultados

### Paso 5: Entrega
- Completar documentación
- Hacer commits
- Actualizar Taiga
- Preparar demo
- Crear Pull Request

---

## 📊 Métricas de Éxito

### Técnicas
- ✅ 100% emails enviados correctamente
- ✅ Tiempo envío < 10 segundos
- ✅ 100% logs registrados
- ✅ 0% pérdida datos
- ✅ Templates correctos

### Calidad
- ✅ 100% casos prueba Pass
- ✅ 3+ casos por CA
- ✅ Documentación completa
- ✅ Nomenclatura estándares
- ✅ Integración funcional

### Proceso
- ✅ Taiga 100% actualizado
- ✅ 4+ commits convencionales
- ✅ PR creado y revisado
- ✅ Demo presentado
- ✅ DoD 100% cumplido

---

## 📚 Documentos Generados

### Para Desarrollo
1. **PLAN_HU-005.md** ← Este documento (completo)
2. **RESUMEN_EJECUTIVO_HU-005.md** ← Guía rápida
3. **TAREAS_TAIGA_HU-005.csv** ← Importar a Taiga

### Para Entregar (Sprint)
1. `HU-05_FICHA_TECNICA.md`
2. `HU-05_CASOS_PRUEBA.md`
3. `HU-05_RESULTADOS_PRUEBAS.md`
4. `HU-05_RESUMEN_FINAL.md`
5. `README.md`
6. `HU-005.json` (workflow)
7. `test_hu05.sh` (script pruebas)
8. Evidencias visuales (5+ capturas)

---

## 🔗 Enlaces Importantes

### Recursos del Proyecto
- 📂 Carpeta HU-001: `hu001/` (referencia completa)
- 📄 Especificaciones: `shared/specs/Proyecto-Gestor-Convalidaciones-Academicas.txt`
- 📖 Metodología: `shared/specs/sprint1.txt`
- 🔧 Workflow HU-001: `hu001/workflows/HU-001-MEJORADO.json`

### Herramientas
- **n8n:** http://localhost:5678
- **Taiga:** [URL del tablero]
- **GitHub:** [URL del repositorio]
- **Google Sheets:** [URL de la hoja]

---

## ⚠️ Puntos Críticos de Atención

### 🔴 Alta Prioridad
1. **Integración con HU-004:** Validar conexión entre workflows
2. **Templates Email:** Deben ser claros y accionables
3. **Logging:** Registrar TODOS los eventos sin fallar

### 🟡 Media Prioridad
4. **Manejo Errores:** SMTP, timeout, sin email estudiante
5. **Testing:** Ejecutar casos válidos, inválidos y borde
6. **Documentación:** Mantener actualizada mientras desarrollas

### 🟢 Baja Prioridad
7. **Evidencias Visuales:** Capturar al final cuando todo funcione
8. **Demo:** Preparar último día del sprint
9. **Pull Request:** Crear cuando DoD esté 100%

---

## 💡 Tips para el Éxito

### Durante Desarrollo
- ✅ Sigue el orden de las fases (hay dependencias)
- ✅ Documenta mientras codificas (no al final)
- ✅ Haz commits pequeños y frecuentes
- ✅ Prueba integración constantemente
- ✅ Actualiza Taiga diariamente

### Antes de Entregar
- ✅ Verifica DoD completo (15 items)
- ✅ Ejecuta todos los tests exitosamente
- ✅ Revisa que no haya credenciales en código
- ✅ Valida que workflow se pueda importar
- ✅ Prepara demo con tiempo (7 min máx)

### Comunicación Equipo
- ✅ Daily cada 2 días (15 min máx)
- ✅ Pide revisiones tempranas
- ✅ Reporta bloqueos inmediatamente
- ✅ Comparte progreso en Taiga
- ✅ Documenta decisiones importantes

---

## 📞 Soporte y Contacto

**Developer:** [Nombre] - [Email]  
**Tester:** [Nombre] - [Email]  
**Scrum Master:** [Nombre] - [Email]  
**Product Owner:** [Nombre] - [Email]

**Dudas Técnicas:** Revisar HU-001 completado como referencia  
**Dudas Metodología:** Consultar `sprint1.txt`  
**Dudas Taiga:** Contactar Scrum Master

---

## ✅ Próximos Pasos Inmediatos

### Esta Semana (Semana 1)
1. [ ] Asignar roles: Developer, Tester, SM
2. [ ] Crear rama en GitHub: `feature/hu005-notificacion-correccion`
3. [ ] Importar tareas a Taiga desde CSV
4. [ ] Realizar Planning Poker (T-026)
5. [ ] Iniciar FASE 1: Crear estructura (T-001)
6. [ ] Daily Scrum #1 (registrar en Taiga)

### Siguiente Semana (Semana 2)
7. [ ] Completar implementación workflow
8. [ ] Crear templates emails
9. [ ] Integrar con HU-004
10. [ ] Ejecutar primeros tests

### Última Semana (Semana 3)
11. [ ] Completar documentación
12. [ ] Ejecutar tests completos
13. [ ] Hacer commits finales
14. [ ] Preparar demo
15. [ ] Sprint Review (22 Nov)

---

**¡Éxito en el desarrollo del HU-005!** 🚀

---

**Documento:** Resumen Ejecutivo HU-005  
**Versión:** 1.0  
**Creado:** 9 de noviembre de 2025  
**Para:** Equipo de desarrollo Sprint 2  
**Estado:** ✅ Listo para inicio
