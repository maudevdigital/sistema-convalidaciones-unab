# 📧 HU-005: Notificación al Estudiante para Corrección de Documentación

**Desarrollador:** [Asignar]  
**Tester:** [Asignar]  
**Estado:** 📝 Planificado  
**Sprint:** 2  
**Fecha:** Noviembre 2025

---

## 📋 Descripción

Sistema automatizado para **notificar automáticamente a estudiantes** cuando su documentación enviada es rechazada por HU-004 (Verificación de documentos), permitiendo corrección sin reiniciar el trámite completo.

---

## 🎯 Historia de Usuario

**Como** estudiante de la UNAB,  
**Quiero** recibir una notificación automática si la documentación que envié es incorrecta,  
**Para** poder corregir y enviar mi solicitud sin tener que iniciar el trámite desde cero.

---

## 🔄 Flujo de Activación

```
HU-001 (Recepción) 
   ↓
HU-004 (Validación Documentos) 
   ↓ (SI ERROR)
HU-005 (Notificación Corrección) ← ESTE WORKFLOW
   ↓
[Estudiante corrige y reenvía]
   ↓
HU-001 (Nueva solicitud)
```

---

## ✅ Criterios de Aceptación

### CA1: Detección de Rechazo de Documentación
- **Given:** Una solicitud ha fallado la validación de documentos en HU-004
- **When:** El sistema detecta el error de validación
- **Then:** Se activa automáticamente el flujo de notificación HU-005
- **And:** Se capturan los detalles del error (tipo, motivo, ID solicitud)

### CA2: Redacción Automática del Email de Corrección
- **Given:** Se ha detectado un error de validación de documentos
- **When:** El sistema procesa el tipo de error (formato, tamaño, corrupción)
- **Then:** Se genera automáticamente un email con template predefinido según tipo error
- **And:** El email incluye: motivo rechazo, instrucciones corrección, link reenvío

### CA3: Envío de Email al Estudiante
- **Given:** El email de corrección ha sido generado correctamente
- **When:** El sistema procede al envío
- **Then:** El email se envía a la dirección proporcionada por el estudiante
- **And:** Se registra el evento en Google Sheets hoja "Logs"
- **And:** Se retorna confirmación de envío exitoso

---

## 📁 Estructura de Archivos

```
hu005/
├── README.md                          # Este archivo
├── PLAN_HU-005.md                     # Plan completo 30 tareas
├── RESUMEN_EJECUTIVO_HU-005.md        # Guía rápida
├── CHECKLIST_HU-005.md                # Control de avance
├── TAREAS_TAIGA_HU-005.csv            # Importar a Taiga
│
├── workflows/                          # Workflows de n8n
│   └── HU-005.json                    # Workflow principal (por crear)
│
├── docs/                               # Documentación técnica
│   ├── HU-05_FICHA_TECNICA.md         # (por crear)
│   ├── HU-05_CASOS_PRUEBA.md          # (por crear)
│   ├── HU-05_RESULTADOS_PRUEBAS.md    # (por crear)
│   └── HU-05_RESUMEN_FINAL.md         # (por crear)
│
├── tests/                              # Scripts de prueba
│   └── test_hu05.sh                   # (por crear)
│
└── registro_imagenes_hu-005/          # Evidencias visuales
    ├── diagrama_workflow.png          # (por crear)
    ├── nodos_configurados.png         # (por crear)
    ├── ejemplo_email_enviado.png      # (por crear)
    ├── logs_sheets.png                # (por crear)
    └── ejecucion_exitosa.png          # (por crear)
```

---

## 🚀 Guía de Uso Rápida

### 1. Revisar Documentación de Planificación

```bash
# Leer plan completo (30 tareas detalladas)
cat PLAN_HU-005.md

# Leer resumen ejecutivo (referencia rápida)
cat RESUMEN_EJECUTIVO_HU-005.md

# Usar checklist para control de avance
cat CHECKLIST_HU-005.md
```

### 2. Importar Tareas a Taiga

```bash
# El archivo CSV está listo para importar
# En Taiga: Backlog → Import → Seleccionar TAREAS_TAIGA_HU-005.csv
```

### 3. Crear Rama de Trabajo en GitHub

```bash
# Crear rama feature
git checkout -b feature/hu005-notificacion-correccion

# Verificar rama actual
git branch
```

### 4. Crear Estructura de Carpetas

```bash
# Crear subcarpetas faltantes
mkdir -p workflows docs tests registro_imagenes_hu-005

# Crear archivos .gitkeep para versionar carpetas vacías
touch workflows/.gitkeep
touch docs/.gitkeep
touch tests/.gitkeep
touch registro_imagenes_hu-005/.gitkeep
```

### 5. Comenzar Desarrollo

Seguir el orden de las **8 FASES** del plan:
1. **FASE 1:** Estructura y Documentación (T-001 a T-004)
2. **FASE 2:** Diseño e Implementación (T-005 a T-009)
3. **FASE 3:** Testing y Validación (T-010 a T-013)
4. **FASE 4:** Documentación Final (T-014 a T-017)
5. **FASE 5:** Control Versiones GitHub (T-018 a T-021)
6. **FASE 6:** Gestión en Taiga (T-022 a T-024)
7. **FASE 7:** Calidad y Validaciones (T-025 a T-027)
8. **FASE 8:** Entrega y Demo (T-028 a T-030)

---

## 📊 Resumen del Proyecto

| Aspecto | Detalle |
|---------|---------|
| **Total Tareas** | 30 tareas organizadas en 8 fases |
| **Story Points** | 90 puntos Fibonacci |
| **Horas Estimadas** | 48-60 horas totales |
| **Duración Sprint** | 3 semanas (4-22 Nov) |
| **Criterios Aceptación** | 3 CA en formato Given/When/Then |
| **Casos de Prueba** | Mínimo 9 (3 por CA) |
| **Templates Email** | 4 templates predefinidos |
| **Commits Esperados** | 4+ commits convencionales |
| **Entrega Final** | 22 de noviembre (Sprint Review) |

---

## 🔧 Componentes Técnicos

### Workflow n8n (HU-005.json)

```
1. IF-ValidacionDoc
   ↓ (Si error de HU-004)
2. Function-RedactarEmail
   ↓
3. Email-Correccion (SMTP)
   ↓
4. DB-Log (Google Sheets)
   ↓
5. Respond (Confirmación)
```

### 4 Templates de Email

1. **Formato Incorrecto**
   - Motivo: Solo se aceptan archivos PDF
   - Acción: Convertir a PDF y reenviar

2. **Tamaño Excedido**
   - Motivo: Archivo supera 10 MB
   - Acción: Comprimir PDF y reenviar

3. **Archivo Corrupto**
   - Motivo: No se puede leer el PDF
   - Acción: Verificar integridad y reenviar

4. **Campos Faltantes**
   - Motivo: Información incompleta
   - Acción: Completar todos los campos

---

## 🧪 Casos de Prueba (Mínimo)

### Por CA1: Detección de Rechazo
- **TC5.1.1:** Validación falla → HU-005 se activa ✓
- **TC5.1.2:** Datos error pasan correctamente ✓
- **TC5.1.3:** ID solicitud se captura ✓

### Por CA2: Redacción Email
- **TC5.2.1:** Email formato incorrecto generado ✓
- **TC5.2.2:** Email tamaño excedido generado ✓
- **TC5.2.3:** Email múltiples errores consolidado ✓

### Por CA3: Envío Email
- **TC5.3.1:** Email enviado exitosamente ✓
- **TC5.3.2:** Log registrado en Sheets ✓
- **TC5.3.3:** Confirmación retornada ✓

---

## ⚙️ Configuración Requerida

### Credenciales (Reutilizar de HU-001)

#### SMTP Email
- **Producción:** Gmail con App Password
  - Host: `smtp.gmail.com`
  - Port: `587` (STARTTLS) o `465` (SSL)
  - User: `tu-email@gmail.com`
  - Password: [Contraseña de aplicación de 16 caracteres]

- **Testing:** Ethereal Email
  - Host: `smtp.ethereal.email`
  - Port: `587`
  - Crear cuenta: https://ethereal.email/create

#### Google Sheets API
- OAuth2 configurado en HU-001
- Hoja "Logs" ya existe
- Reutilizar misma credencial

---

## 📈 Métricas de Éxito

### Técnicas
- ✅ 100% de emails de error enviados correctamente
- ✅ Tiempo envío < 10 segundos
- ✅ 100% de eventos registrados en logs
- ✅ 0% pérdida de datos entre workflows
- ✅ Templates correctos según tipo error

### Calidad
- ✅ 100% casos de prueba ejecutados (Pass)
- ✅ Cobertura mínima 3 casos por CA
- ✅ Documentación 100% completa
- ✅ Nomenclatura estándares cumplida
- ✅ Integración HU-001→HU-004→HU-005 funcional

### Proceso
- ✅ 100% tareas en Taiga actualizadas
- ✅ 4+ commits realizados con mensajes convencionales
- ✅ Pull Request creado y revisado
- ✅ Demo preparado y presentado
- ✅ DoD 100% completado

---

## 🐛 Problemas Comunes y Soluciones

### Error: "SMTP Connection Failed"
**Causa:** Credenciales incorrectas o firewall bloqueando  
**Solución:** Verificar credenciales SMTP, probar con Ethereal primero

### Error: "No se recibe email"
**Causa:** Email estudiante inválido o spam  
**Solución:** Verificar email en logs, revisar carpeta spam

### Error: "No se registra en Logs"
**Causa:** Credencial Google Sheets no configurada  
**Solución:** Reutilizar credencial de HU-001, verificar permisos

### Workflow no se conecta con HU-004
**Causa:** Nombres de variables no coinciden  
**Solución:** Verificar outputs de HU-004 y inputs de HU-005

---

## 👥 Asignaciones Recomendadas

### Developer Principal (20-25 hrs)
- Responsable: T-001, T-002, T-005, T-006, T-008, T-009, T-014, T-016, T-018, T-019, T-025, T-030
- Foco: Implementación workflow, integración, commits

### Tester (15-18 hrs)
- Responsable: T-003, T-004, T-010, T-011, T-012, T-021, T-029
- Foco: Casos prueba, validación, scripts automatizados

### Developer + Tester (8-10 hrs)
- Responsable: T-007, T-013, T-015, T-017, T-020, T-028
- Foco: Templates, evidencias, demo

### Scrum Master (5-7 hrs)
- Responsable: T-022, T-023, T-024, T-026, T-027
- Foco: Gestión Taiga, facilitación equipo

---

## 📚 Referencias y Recursos

### Documentos del Proyecto
- ✅ `PLAN_HU-005.md` - Plan completo 30 tareas
- ✅ `RESUMEN_EJECUTIVO_HU-005.md` - Guía rápida
- ✅ `CHECKLIST_HU-005.md` - Control de avance
- ✅ `TAREAS_TAIGA_HU-005.csv` - Importar a Taiga

### Referencias HU-001 (Template)
- 📂 `../hu001/README.md` - Estructura completada
- 📂 `../hu001/docs/HU-01_FICHA_TECNICA.md` - Template ficha
- 📂 `../hu001/workflows/HU-001-MEJORADO.json` - Workflow referencia
- 📂 `../hu001/tests/test_hu01.sh` - Script pruebas referencia

### Especificaciones Generales
- 📄 `../shared/specs/Proyecto-Gestor-Convalidaciones-Academicas.txt`
- 📄 `../shared/specs/sprint1.txt`

### Herramientas
- **n8n:** http://localhost:5678
- **Taiga:** [URL del proyecto]
- **GitHub:** [URL del repositorio]
- **Google Sheets:** [URL de la hoja]

---

## 🔄 Próximos Pasos Después de HU-005

1. **HU-006:** Almacenamiento de documentos válidos en Google Drive
2. **HU-007:** Notificación a Dirección de Carrera
3. **HU-008:** Sistema de seguimiento de estados
4. **Integración:** Unir todos workflows en flujo maestro
5. **Testing E2E:** Pruebas completas del sistema

---

## ✅ Definition of Done (DoD)

### Checklist Final (15 items)
- [ ] Workflow funcional en n8n
- [ ] 3 CA cumplidos y documentados
- [ ] 9+ casos prueba ejecutados exitosamente
- [ ] Logs registrados en Google Sheets
- [ ] 4 templates email funcionando
- [ ] Integración HU-004 probada
- [ ] 5 documentos completos
- [ ] 5+ evidencias visuales
- [ ] Script test_hu05.sh funcional
- [ ] 4+ commits GitHub
- [ ] Taiga actualizado 100%
- [ ] Demo 7 min preparado
- [ ] Manejo errores documentado
- [ ] Nomenclatura estándares
- [ ] Sin credenciales hardcoded

---

## 📞 Contacto y Soporte

**Developer:** [Nombre] - [Email]  
**Tester:** [Nombre] - [Email]  
**Scrum Master:** [Nombre] - [Email]  
**Product Owner:** [Nombre] - [Email]

**Repositorio GitHub:** [URL]  
**Tablero Taiga:** [URL]  
**Wiki Sprint:** [URL]

---

## 💡 Tips para el Éxito

### Antes de Empezar
1. ✅ Leer completamente `PLAN_HU-005.md`
2. ✅ Importar tareas a Taiga desde CSV
3. ✅ Asignar roles claramente
4. ✅ Crear rama en GitHub
5. ✅ Revisar HU-001 como referencia

### Durante Desarrollo
1. ✅ Seguir orden de fases (dependencias)
2. ✅ Documentar mientras codificas
3. ✅ Commits pequeños y frecuentes
4. ✅ Probar integración constantemente
5. ✅ Actualizar Taiga diariamente

### Antes de Entregar
1. ✅ Verificar DoD completo (15 items)
2. ✅ Ejecutar todos los tests
3. ✅ Validar sin credenciales en código
4. ✅ Workflow se puede importar
5. ✅ Demo preparado (7 min máx)

---

## 📅 Cronograma Sprint 2

### Semana 1 (4-8 Nov)
- **Lunes-Martes:** FASE 1 - Documentación inicial
- **Miércoles-Viernes:** FASE 2 inicio - Diseño workflow

### Semana 2 (11-15 Nov)
- **Lunes-Martes:** FASE 2 fin - Implementación
- **Miércoles-Viernes:** FASE 3 - Testing completo

### Semana 3 (18-22 Nov)
- **Lunes-Martes:** FASE 4 - Documentación final
- **Miércoles:** FASE 5+6 - Git + Taiga
- **Jueves-Viernes:** FASE 7+8 - Calidad + Demo

**Entrega Sprint Review:** 22 de noviembre

---

## 📝 Notas Finales

Este HU está **completamente planificado** con:
- ✅ 30 tareas detalladas en 8 fases
- ✅ Plan completo de 90 puntos
- ✅ Resumen ejecutivo para referencia rápida
- ✅ Checklist de control de avance
- ✅ CSV listo para importar a Taiga
- ✅ Basado en éxito de HU-001

**¡Todo está listo para comenzar el desarrollo!** 🚀

Sigue el `PLAN_HU-005.md` paso a paso y tendrás éxito garantizado.

---

**Última actualización:** 9 de noviembre de 2025  
**Versión:** 1.0  
**Estado:** ✅ Listo para inicio Sprint 2

---

**¡Éxito en el desarrollo del HU-005!** 🎯
