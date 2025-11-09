# 🤝 Guía de Contribución

Gracias por contribuir al Sistema de Convalidaciones Académicas UNAB. Esta guía te ayudará a estructurar tu trabajo de forma consistente con el equipo.

## 🎯 Antes de Empezar

1. **Lee la documentación:**
   - [`README.md`](README.md) - Visión general del proyecto
   - [`DEVELOPERS.md`](DEVELOPERS.md) - Guía técnica completa
   - [`shared/specs/`](shared/specs/) - Especificaciones del proyecto

2. **Familiarízate con n8n:**
   - [Documentación oficial de n8n](https://docs.n8n.io/)
   - [Workflows de ejemplo](developers/lucas/hu001/workflows/)

3. **Configura tu entorno:**
   ```bash
   docker-compose up -d
   # Acceder a http://localhost:5678
   ```

## 📝 Proceso de Contribución

### 1. Asignación de Historia de Usuario (HU)

Cada desarrollador trabaja en su propia carpeta:

```bash
developers/
├── lucas/          # Ya existe (ejemplo)
├── maria/          # Nuevo desarrollador
└── pedro/          # Nuevo desarrollador
```

**Estructura para nueva HU:**

```bash
# Crear tu espacio de trabajo
mkdir -p developers/TU_NOMBRE/huXXX/{workflows,docs,tests}

# Copiar templates
cp developers/lucas/hu001/README.md developers/TU_NOMBRE/huXXX/
cp developers/lucas/hu001/CONFIG.md developers/TU_NOMBRE/huXXX/
```

### 2. Desarrollo

#### Estructura de Archivos

```
developers/TU_NOMBRE/huXXX/
├── README.md                    # ✅ Obligatorio - Guía de la HU
├── CONFIG.md                    # ✅ Obligatorio - Configuración
├── formulario-XXX.html          # Si aplica
│
├── workflows/                   # ✅ Obligatorio
│   └── flow_HUXX.json          # Workflow exportado de n8n
│
├── docs/                        # ✅ Obligatorio
│   ├── HU-XXX_FICHA_TECNICA.md
│   ├── HU-XXX_CASOS_PRUEBA.md
│   ├── HU-XXX_RESULTADOS_PRUEBAS.md
│   └── HU-XXX_RESUMEN_FINAL.md
│
└── tests/                       # ✅ Obligatorio
    └── test_huXXX.sh           # Script de tests
```

#### README.md de la HU (Template)

```markdown
# HU-XXX: [Título de la Historia]

**Desarrollador:** [Tu Nombre]
**Estado:** 🚧 En desarrollo / ✅ Completado
**Sprint:** [Número]
**Fecha:** [Fecha]

## 📋 Descripción
[Descripción breve de qué hace esta HU]

## 🎯 Objetivos
- [ ] Objetivo 1
- [ ] Objetivo 2

## 🚀 Guía de Uso
[Pasos para usar tu implementación]

## 🧪 Casos de Prueba
[Descripción de tests]

## 📊 Resultados
[Métricas y resultados]
```

### 3. Workflows de n8n

#### Exportar Workflow

1. En n8n UI: Abrir tu workflow
2. Click en menú "⋮" (3 puntos)
3. "Download" → Guardar como `flow_HUXX.json`
4. Mover a `developers/TU_NOMBRE/huXXX/workflows/`

#### Convenciones de Naming

```
flow_HU001.json          # Workflow principal de HU-001
flow_HU001_helper.json   # Workflow auxiliar
flow_HU001_cron.json     # Workflow programado
```

#### Estructura del Workflow

- **Comentarios:** Usar nodos "Sticky Note" para documentar secciones
- **Naming:** Nombres descriptivos en español para nodos
- **Credentials:** Referenciar, no hardcodear
- **Error Handling:** Siempre manejar errores con nodos IF

### 4. Testing

#### Script de Tests (Bash)

Template básico:

```bash
#!/bin/bash

echo "🧪 Iniciando pruebas HU-XXX"

WEBHOOK_URL="http://localhost:5678/webhook/tu-webhook"

# TC1: Caso válido
echo "📝 TC1: Caso válido completo"
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "campo1": "valor1",
    "campo2": "valor2"
  }'

# Agregar más tests...

echo "✅ Tests completados"
```

#### Casos de Prueba Requeridos

Cada HU debe probar:
- ✅ Caso válido completo
- ✅ Campos obligatorios faltantes
- ✅ Validaciones de formato
- ✅ Manejo de errores
- ✅ Edge cases específicos

### 5. Documentación

#### Archivos Obligatorios

1. **HU-XXX_FICHA_TECNICA.md**
   - Descripción técnica
   - Arquitectura
   - Tecnologías usadas
   - Endpoints/APIs

2. **HU-XXX_CASOS_PRUEBA.md**
   - Lista de casos de prueba
   - Inputs esperados
   - Outputs esperados
   - Criterios de aceptación

3. **HU-XXX_RESULTADOS_PRUEBAS.md**
   - Resultados de ejecución
   - Screenshots
   - Logs relevantes
   - Issues encontrados

4. **HU-XXX_RESUMEN_FINAL.md**
   - Resumen ejecutivo
   - Logros alcanzados
   - Problemas y soluciones
   - Próximos pasos

### 6. Git Workflow

#### Branches

```bash
# Crear branch desde main
git checkout main
git pull origin main
git checkout -b feature/huXXX-descripcion-breve

# Ejemplo:
git checkout -b feature/hu002-validacion-documentos
```

#### Commits

Usar [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Formato:
<tipo>(<scope>): <descripción>

# Tipos:
feat:     Nueva funcionalidad
fix:      Corrección de bug
docs:     Solo documentación
style:    Formato (sin cambio de lógica)
refactor: Refactorización
test:     Agregar/modificar tests
chore:    Tareas de mantenimiento

# Ejemplos:
git commit -m "feat(hu002): implementar validación de PDF"
git commit -m "fix(hu002): corregir manejo de errores en webhook"
git commit -m "docs(hu002): actualizar README con casos de uso"
git commit -m "test(hu002): agregar tests de validación"
```

#### Pull Requests

**Título del PR:**
```
[HU-XXX] Descripción breve y clara
```

**Template del PR:**

```markdown
## 📋 Descripción
[Qué implementa este PR]

## 🎯 Historia de Usuario
HU-XXX: [Título]

## ✅ Checklist
- [ ] Workflow implementado y funcional
- [ ] Tests automatizados pasando
- [ ] Documentación completa (README, docs/)
- [ ] Sin credenciales hardcodeadas
- [ ] .gitignore actualizado si es necesario
- [ ] Revisión de código por peer

## 🧪 Cómo Probar
1. Importar workflow desde `developers/NOMBRE/huXXX/workflows/`
2. Configurar credenciales [detallar cuáles]
3. Activar workflow
4. Ejecutar: `./tests/test_huXXX.sh`

## 📸 Screenshots
[Si aplica, agregar capturas]

## 🐛 Issues Conocidos
[Si hay alguno, listar]

## 📝 Notas Adicionales
[Cualquier información relevante]
```

### 7. Code Review

#### Checklist del Revisor

- [ ] Código claro y documentado
- [ ] Workflow sigue convenciones de naming
- [ ] Tests pasan exitosamente
- [ ] Documentación completa y actualizada
- [ ] No hay datos sensibles versionados
- [ ] Estructura de carpetas correcta
- [ ] README de la HU está completo

#### Proceso de Review

1. Revisor asignado revisa el PR
2. Deja comentarios si hay cambios necesarios
3. Desarrollador aplica cambios
4. Re-review si es necesario
5. Aprobación → Merge a `main`

## 🚫 Qué NO Hacer

### ❌ Nunca Versiones

- Credenciales o API keys
- Contraseñas
- `n8n/database.sqlite`
- `n8n/config` con datos reales
- Información personal de usuarios
- Tokens de acceso

### ❌ Nunca Hagas Commits Directos a `main`

Siempre usar branches y PRs.

### ❌ No Modifiques Carpetas de Otros Devs

Salvo que sea explícitamente necesario y coordinado.

### ❌ No Uses Hardcoded Values

Usa variables de entorno o configuración.

## ✅ Mejores Prácticas

### Workflows de n8n

- ✅ Nombres descriptivos en español
- ✅ Comentarios con Sticky Notes
- ✅ Manejo de errores en cada flujo
- ✅ Logs para debugging
- ✅ Validaciones tempranas

### Código y Scripts

- ✅ Comentarios claros
- ✅ Variables con nombres descriptivos
- ✅ Manejo de errores
- ✅ Outputs informativos

### Documentación

- ✅ README actualizado siempre
- ✅ Ejemplos de uso
- ✅ Diagramas si es complejo
- ✅ Links a recursos externos

### Tests

- ✅ Automatizados cuando sea posible
- ✅ Casos positivos y negativos
- ✅ Edge cases
- ✅ Outputs claros (pass/fail)

## 🆘 Ayuda y Soporte

### Recursos

- **Documentación del proyecto:** [`DEVELOPERS.md`](DEVELOPERS.md)
- **Especificaciones:** [`shared/specs/`](shared/specs/)
- **Ejemplo completo:** [`developers/lucas/hu001/`](developers/lucas/hu001/)

### Contacto

- **Issues:** [GitHub Issues](https://github.com/maudevdigital/Proyecto-n8n/issues)
- **Email:** l.maulnriquelme@uandresbello.edu
- **Slack/Teams:** Canal #proyecto-convalidaciones

### Preguntas Frecuentes

**P: ¿Dónde pongo archivos compartidos por todo el equipo?**  
R: En la carpeta `shared/` (docs, scripts, specs)

**P: ¿Puedo usar librerías externas en workflows?**  
R: Sí, documentar en CONFIG.md y README.md

**P: ¿Cómo sincronizo credenciales entre devs?**  
R: Documentar en CONFIG.md (sin valores reales), compartir por canal seguro

**P: Mi workflow funciona local pero no en otro ambiente**  
R: Verificar variables de entorno, URLs, credenciales

## 📋 Checklist Final Antes de PR

```markdown
- [ ] Branch creado desde `main` actualizado
- [ ] Estructura de carpetas correcta
- [ ] README.md de la HU completo
- [ ] CONFIG.md documentado
- [ ] Workflow exportado en workflows/
- [ ] Documentación técnica en docs/
- [ ] Tests en tests/ y funcionando
- [ ] Sin credenciales en código
- [ ] Commits siguiendo conventional commits
- [ ] PR con template completo
- [ ] Auto-revisión hecha
```

---

**¿Listo para contribuir?** 🚀

1. Lee esta guía completa
2. Revisa [`DEVELOPERS.md`](DEVELOPERS.md)
3. Mira el ejemplo en [`developers/lucas/hu001/`](developers/lucas/hu001/)
4. ¡Crea tu branch y empieza a desarrollar!

---

**Gracias por contribuir al proyecto** 💙
