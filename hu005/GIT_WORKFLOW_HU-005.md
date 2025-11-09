# 🔧 Guía Rápida Git para HU-005

**Proyecto:** Convalidaciones Académicas UNAB  
**Sprint:** 2 | **HU:** 005  
**Rama:** `feature/hu005-notificacion-correccion`

---

## 🚀 SETUP INICIAL (Ejecutar HOY)

### 1. Verificar Estado Actual
```powershell
# Ver rama actual
git branch

# Ver estado de archivos
git status

# Ver últimos commits
git log --oneline -5
```

### 2. Crear Rama Feature HU-005
```powershell
# Asegurarse de estar en main/master actualizado
git checkout main
git pull origin main

# Crear y cambiar a nueva rama
git checkout -b feature/hu005-notificacion-correccion

# Verificar que estás en la rama correcta
git branch
# Debería mostrar: * feature/hu005-notificacion-correccion
```

---

## 📝 COMMIT INICIAL (Estructura + Documentación)

### Commit #1: Estructura y Planificación
```powershell
# Ver qué archivos se crearon
git status

# Agregar todos los archivos de hu005/
git add hu005/

# Verificar qué se agregará
git status

# Hacer commit con mensaje convencional
git commit -m "feat(hu005): crear estructura carpetas y documentación planificación

- Crear carpeta hu005/ con subcarpetas
- Agregar PLAN_HU-005.md (30 tareas en 8 fases)
- Agregar RESUMEN_EJECUTIVO_HU-005.md
- Agregar CHECKLIST_HU-005.md
- Agregar TAREAS_TAIGA_HU-005.csv
- Agregar README.md con guía completa
- Agregar ANALISIS_COMPLETO_HU-005.md
- Agregar GIT_WORKFLOW_HU-005.md

Sprint: 2
Story Points: 90
Tareas: T-001 estructura inicial"

# Push a GitHub
git push -u origin feature/hu005-notificacion-correccion
```

**✅ Resultado:** Rama creada en GitHub con commit inicial

---

## 📋 COMMITS DURANTE DESARROLLO (Por Fase)

### Commit #2: Documentación Técnica (FASE 1)
```powershell
# Después de completar T-002, T-003, T-004
git add hu005/docs/HU-05_FICHA_TECNICA.md
git add hu005/docs/HU-05_CASOS_PRUEBA.md

git commit -m "docs(hu005): agregar ficha técnica y casos de prueba

- Crear HU-05_FICHA_TECNICA.md con 3 CA en Given/When/Then
- Documentar inputs/outputs JSON esperados
- Crear HU-05_CASOS_PRUEBA.md con 9+ casos de prueba
- Incluir casos válidos, inválidos y borde

Tareas: T-002, T-003, T-004
CA: CA1, CA2, CA3 definidos"

git push origin feature/hu005-notificacion-correccion
```

### Commit #3: Implementación Workflow (FASE 2)
```powershell
# Después de completar T-006, T-007, T-008, T-009
git add hu005/workflows/HU-005.json

git commit -m "feat(hu005): implementar workflow notificación corrección documentación

- Crear workflow HU-005.json con nodos:
  * IF-ValidacionDoc (detecta error HU-004)
  * Function-RedactarEmail (4 templates)
  * Email-Correccion (envío SMTP)
  * DB-Log (registro Google Sheets)
- Integrar con rama error de HU-004
- Configurar logging completo
- Reutilizar credenciales de HU-001

Tareas: T-006, T-008, T-009
Nodos: 5 nodos con nomenclatura estándar"

git push origin feature/hu005-notificacion-correccion
```

### Commit #4: Templates Email (FASE 2)
```powershell
# Si templates están en archivos separados
git add hu005/workflows/templates/

git commit -m "feat(hu005): agregar 4 templates de email corrección

- Template formato_incorrecto.html (solo PDF)
- Template tamano_excedido.html (max 10MB)
- Template archivo_corrupto.html (no se puede leer)
- Template campos_faltantes.html (información incompleta)
- Incluir variables dinámicas en todos
- Agregar instrucciones corrección claras

Tareas: T-007
Templates: 4 templates funcionales"

git push origin feature/hu005-notificacion-correccion
```

### Commit #5: Scripts de Prueba (FASE 3)
```powershell
# Después de completar T-010
git add hu005/tests/test_hu05.sh

git commit -m "test(hu005): agregar script pruebas automatizadas test_hu05.sh

- Crear test_hu05.sh con 5 casos de prueba:
  * TC5.1: Email formato incorrecto
  * TC5.2: Email tamaño excedido
  * TC5.3: Email múltiples errores
  * TC5.4: Verificar envío email
  * TC5.5: Validar log registro
- Usar curl para llamadas webhook
- Validar responses HTTP y JSON
- Agregar permisos ejecución (chmod +x)

Tareas: T-010
Tests: 5 casos automatizados"

git push origin feature/hu005-notificacion-correccion
```

### Commit #6: Resultados Pruebas (FASE 3)
```powershell
# Después de completar T-012
git add hu005/docs/HU-05_RESULTADOS_PRUEBAS.md

git commit -m "docs(hu005): agregar resultados pruebas ejecutadas

- Documentar ejecución test_hu05.sh
- 9+ casos de prueba ejecutados: 100% Pass
- Validar métricas:
  * 100% emails enviados correctamente
  * Tiempos envío < 10 segundos
  * 100% logs registrados
  * Templates correctos según error
- Incluir evidencias y capturas

Tareas: T-012
Estado: Todos los tests OK ✓"

git push origin feature/hu005-notificacion-correccion
```

### Commit #7: Evidencias Visuales (FASE 3)
```powershell
# Después de completar T-013
git add hu005/registro_imagenes_hu-005/*.png

git commit -m "docs(hu005): agregar evidencias visuales del workflow

- Captura diagrama_workflow.png
- Captura nodos_configurados.png
- Captura ejemplo_email_enviado.png
- Captura logs_sheets.png
- Captura ejecucion_exitosa.png

Tareas: T-013
Evidencias: 5 capturas PNG"

git push origin feature/hu005-notificacion-correccion
```

### Commit #8: Documentación Final (FASE 4)
```powershell
# Después de completar T-014, T-015, T-016
git add hu005/README.md
git add hu005/docs/HU-05_RESUMEN_FINAL.md

git commit -m "docs(hu005): completar documentación final HU-005

- Actualizar README.md con toda la información
- Crear HU-05_RESUMEN_FINAL.md:
  * Entregables completados
  * Cumplimiento 3 CA al 100%
  * Métricas de calidad
  * Estado final: COMPLETADO
- Exportar workflow HU-005.json final
- Validar integración HU-001→004→005

Tareas: T-014, T-015, T-016, T-017
Estado: Documentación 100% completa"

git push origin feature/hu005-notificacion-correccion
```

### Commit #9: Commit Final (FASE 8)
```powershell
# Después de completar TODO (T-030)
git add hu005/

git commit -m "feat(hu005): completar HU-005 notificación corrección documentación

✅ COMPLETADO AL 100%

Resumen de Entregables:
- Workflow HU-005.json funcional e integrado
- 3 Criterios de Aceptación cumplidos
- 9+ casos de prueba ejecutados (100% Pass)
- 5 documentos técnicos completos
- 4 templates de email funcionando
- 5 evidencias visuales capturadas
- Script test_hu05.sh automatizado
- Logs en Google Sheets operando
- Integración HU-001→004→005 probada

Métricas:
- Story Points: 90/90 ✓
- Tareas: 30/30 ✓
- Tests Pass: 9/9 ✓
- DoD: 15/15 items ✓

Sprint: 2
Demo: Preparado para Sprint Review 22 Nov
Estado: LISTO PARA REVISIÓN ✅"

git push origin feature/hu005-notificacion-correccion
```

---

## 🔄 CREAR PULL REQUEST (FASE 8 - T-030)

### 1. En GitHub Web Interface
```
1. Ir a: https://github.com/TU_USUARIO/TU_REPO
2. Click en "Pull requests"
3. Click en "New pull request"
4. Base: main
5. Compare: feature/hu005-notificacion-correccion
6. Click "Create pull request"
```

### 2. Título del PR
```
feat(hu005): HU-005 Notificación Corrección Documentación - COMPLETADO
```

### 3. Descripción del PR (Template)
```markdown
## 🎯 Historia de Usuario
**Como** estudiante,  
**Quiero** recibir notificación automática si mi documentación es incorrecta,  
**Para** poder corregirla sin reiniciar el trámite.

## ✅ Trabajo Completado

### Implementación
- [x] Workflow HU-005.json funcional en n8n
- [x] 4 templates de email (formato, tamaño, corrupto, campos)
- [x] Integración con HU-004 (validación documentos)
- [x] Logging completo en Google Sheets
- [x] Nomenclatura estándares n8n

### Testing
- [x] Script test_hu05.sh automatizado
- [x] 9+ casos de prueba ejecutados (100% Pass)
- [x] Validación integración E2E completa
- [x] 5 evidencias visuales capturadas

### Documentación
- [x] HU-05_FICHA_TECNICA.md
- [x] HU-05_CASOS_PRUEBA.md
- [x] HU-05_RESULTADOS_PRUEBAS.md
- [x] HU-05_RESUMEN_FINAL.md
- [x] README.md completo

### Git & Taiga
- [x] 9 commits convencionales realizados
- [x] 30 tareas completadas en Taiga
- [x] Documentación subida a Wiki Sprint
- [x] Horas registradas correctamente

## 📊 Métricas Logradas

| Métrica | Objetivo | Logrado | Estado |
|---------|----------|---------|--------|
| Story Points | 90 pts | 90 pts | ✅ 100% |
| Tareas | 30 tareas | 30 tareas | ✅ 100% |
| Casos Prueba | 9+ casos | 12 casos | ✅ 133% |
| Tests Pass | 100% | 100% | ✅ Pass |
| Documentos | 5 docs | 5 docs | ✅ 100% |
| Commits | 4+ commits | 9 commits | ✅ 225% |
| DoD Items | 15 items | 15 items | ✅ 100% |

## 🎯 Criterios de Aceptación

### CA1: Detección de Rechazo ✅
- HU-005 se activa automáticamente cuando HU-004 detecta error
- Datos del error (tipo, motivo, ID) se capturan correctamente

### CA2: Redacción Email ✅
- Email generado automáticamente según tipo error
- 4 templates funcionando: formato, tamaño, corrupto, campos
- Incluye motivo, instrucciones y link de reenvío

### CA3: Envío Email ✅
- Email enviado exitosamente al estudiante
- Evento registrado en Google Sheets hoja "Logs"
- Confirmación de envío retornada

## 🔗 Enlaces

- **Taiga HU-005:** [Link a Taiga]
- **Demo Video:** [Link si existe]
- **Wiki Sprint:** [Link a documentación]
- **Workflow n8n:** http://localhost:5678 (importar HU-005.json)

## 👥 Revisores Solicitados

- @developer2 (Revisión técnica)
- @tester (Validación casos de prueba)
- @scrum-master (Verificación DoD)

## 📝 Notas Adicionales

- Reutiliza credenciales SMTP y Google Sheets de HU-001
- Requiere HU-004 implementado para integración completa
- Flujo completo: HU-001 → HU-004 → HU-005
- Demo preparado para Sprint Review 22 Nov

---

**Sprint:** 2  
**Fecha Completitud:** [Fecha]  
**Estado:** ✅ LISTO PARA REVISIÓN Y MERGE
```

### 4. Etiquetar PR
```
Labels: enhancement, documentation, sprint-2, hu-005
Milestone: Sprint 2
Assignees: @tu-usuario
Reviewers: @reviewer1, @reviewer2
```

---

## 🔍 COMANDOS ÚTILES DURANTE DESARROLLO

### Ver Estado Actual
```powershell
# Ver archivos modificados
git status

# Ver diferencias de archivos modificados
git diff

# Ver diferencias de archivos staged
git diff --staged

# Ver log de commits
git log --oneline --graph --all --decorate
```

### Deshacer Cambios (Si es necesario)
```powershell
# Deshacer cambios en archivo NO staged
git checkout -- archivo.md

# Quitar archivo de staging area (NO borra cambios)
git reset HEAD archivo.md

# Ver último commit
git show HEAD

# Modificar último commit (antes de push)
git commit --amend
```

### Sincronizar con Main
```powershell
# Si necesitas integrar cambios de main
git checkout main
git pull origin main
git checkout feature/hu005-notificacion-correccion
git merge main

# Resolver conflictos si existen
# Luego:
git add .
git commit -m "merge: integrar cambios de main"
git push origin feature/hu005-notificacion-correccion
```

### Ver Ramas
```powershell
# Ver ramas locales
git branch

# Ver ramas remotas
git branch -r

# Ver todas las ramas
git branch -a
```

---

## 📊 TRACKING DE COMMITS (Llenar Mientras Trabajas)

| # | Fecha | Fase | Tareas | Mensaje Commit | SHA |
|---|-------|------|--------|----------------|-----|
| 1 | ___/___ | FASE 1 | T-001 | feat(hu005): crear estructura | _______ |
| 2 | ___/___ | FASE 1 | T-002,003,004 | docs(hu005): ficha y casos | _______ |
| 3 | ___/___ | FASE 2 | T-006,008,009 | feat(hu005): implementar workflow | _______ |
| 4 | ___/___ | FASE 2 | T-007 | feat(hu005): templates email | _______ |
| 5 | ___/___ | FASE 3 | T-010 | test(hu005): script pruebas | _______ |
| 6 | ___/___ | FASE 3 | T-012 | docs(hu005): resultados pruebas | _______ |
| 7 | ___/___ | FASE 3 | T-013 | docs(hu005): evidencias visuales | _______ |
| 8 | ___/___ | FASE 4 | T-014,015,016 | docs(hu005): documentación final | _______ |
| 9 | ___/___ | FASE 8 | T-030 | feat(hu005): completar HU-005 | _______ |

**Total Commits:** ___/9+

---

## ✅ CHECKLIST PRE-COMMIT

Antes de cada commit, verificar:

- [ ] Código funciona sin errores
- [ ] Archivos relevantes agregados con `git add`
- [ ] Mensaje de commit sigue convención
- [ ] No hay credenciales hardcodeadas
- [ ] Archivos grandes no incluidos (usar .gitignore)
- [ ] Tests pasan (si aplica)

---

## 🚫 QUÉ NO VERSIONAR (Verificar .gitignore)

### Nunca hacer commit de:
```
# Credenciales
*.env
*secret*
*password*
client_secret*.json

# Datos sensibles de n8n
n8n/database.sqlite
n8n/config

# Archivos temporales
*.tmp
*.log
~$*
```

### Verificar antes de push:
```powershell
# Ver qué se va a pushear
git log origin/feature/hu005-notificacion-correccion..HEAD

# Ver archivos que se van a pushear
git diff --name-only origin/feature/hu005-notificacion-correccion
```

---

## 📞 AYUDA Y SOLUCIÓN DE PROBLEMAS

### Problema: "No se puede pushear"
```powershell
# Solución: Primero pull, luego push
git pull origin feature/hu005-notificacion-correccion
git push origin feature/hu005-notificacion-correccion
```

### Problema: "Merge conflict"
```powershell
# 1. Ver archivos en conflicto
git status

# 2. Abrir archivos y resolver manualmente
# Buscar: <<<<<<< HEAD y >>>>>>> branch

# 3. Después de resolver
git add archivo-resuelto.md
git commit -m "fix: resolver conflictos merge"
git push
```

### Problema: "Olvidé cambiar de rama"
```powershell
# Si NO hiciste commit aún
git stash
git checkout feature/hu005-notificacion-correccion
git stash pop

# Si YA hiciste commit
git log --oneline -1  # copiar SHA
git checkout feature/hu005-notificacion-correccion
git cherry-pick SHA_COPIADO
```

---

## 🎯 RESUMEN: 9 COMMITS PLANIFICADOS

1. **feat(hu005):** Estructura inicial ← YA LISTO
2. **docs(hu005):** Ficha técnica y casos prueba
3. **feat(hu005):** Implementar workflow
4. **feat(hu005):** Templates email
5. **test(hu005):** Script pruebas
6. **docs(hu005):** Resultados pruebas
7. **docs(hu005):** Evidencias visuales
8. **docs(hu005):** Documentación final
9. **feat(hu005):** Commit final completar HU-005

**Pull Request:** feat(hu005): HU-005 Notificación Corrección - COMPLETADO

---

**Documento:** Guía Git para HU-005  
**Versión:** 1.0  
**Uso:** Referencia durante desarrollo Sprint 2  
**Rama:** `feature/hu005-notificacion-correccion`

---

**¡Buenas prácticas Git durante todo el sprint!** 🚀
