# 🎓 Sistema de Gestión de Convalidaciones Académicas - UNAB# 🎓 Gestor de Convalidaciones Académicas - UNAB# 🎓 Gestor de Convalidaciones Académicas - UNAB# HU-01: Recepción de Solicitud de Convalidación



[![n8n](https://img.shields.io/badge/n8n-1.113.3-FF6D5A?logo=n8n)](https://n8n.io)

[![License](https://img.shields.io/badge/license-Academic-blue)](LICENSE)

[![Status](https://img.shields.io/badge/status-Active-success)](https://github.com/maudevdigital/Proyecto-n8n)Sistema automatizado para la recepción, validación y procesamiento de solicitudes de convalidación académica utilizando n8n.



Sistema automatizado de workflows para la gestión completa del proceso de convalidaciones académicas en la Universidad Andrés Bello, construido sobre n8n.



## 📋 Visión General## 📋 Historia de Usuario 01 (HU-01)Sistema automatizado para la recepción, validación y procesamiento de solicitudes de convalidación académica utilizando n8n.## 📋 Descripción



Plataforma que automatiza el ciclo completo de convalidaciones académicas:

- Recepción de solicitudes via formularios web

- Validación automática de requisitos y documentos**Como** estudiante de la UNAB  Sistema automatizado para recibir, validar y procesar solicitudes de convalidación de asignaturas de estudiantes universitarios.

- Almacenamiento en Google Sheets

- Notificaciones por email**Quiero** enviar mi solicitud de convalidación a través de un formulario web  

- Seguimiento de estados

- Generación de reportes**Para que** sea recibida, validada y registrada automáticamente en el sistema## 📋 Historia de Usuario 01 (HU-01)



## 🚀 Inicio Rápido (5 minutos)



### Prerrequisitos## 🚀 Inicio Rápido## 🎯 Historia de Usuario



- Docker y Docker Compose

- Python 3.x (para servidor de formularios)

- Cuenta de Google Cloud (para Sheets API)### 1. Iniciar n8n**Como** estudiante de la UNAB  **Como** estudiante universitario,    



### Setup Básico



```bash```bash**Quiero** enviar mi solicitud de convalidación a través de un formulario web  **Quiero** un formulario web para ingresar mis datos y adjuntar documentos de respaldo,    

# 1. Clonar repositorio

git clone https://github.com/maudevdigital/Proyecto-n8n.gitdocker-compose up -d

cd Proyecto-n8n

```**Para que** sea recibida, validada y registrada automáticamente en el sistema**Para** iniciar el proceso de convalidación de forma digital y centralizada.

# 2. Iniciar n8n

docker-compose up -d



# 3. Acceder a n8nn8n estará disponible en: http://localhost:5678

open http://localhost:5678



# 4. Crear cuenta en n8n (primera vez)

# Seguir wizard de setup en el navegador### 2. Importar el Workflow## 🚀 Inicio Rápido## ✅ Criterios de Aceptación

```



**n8n estará corriendo en:** http://localhost:5678

1. Accede a n8n (http://localhost:5678)

### Configurar Primera HU

2. Ve a: Menú → Import from File

```bash

# Ver ejemplo completo de HU-0013. Selecciona: `flow_HU01.json`### 1. Iniciar n8n### Escenario 1 – Envío exitoso con todos los datos  

cd developers/lucas/hu001

cat README.md4. Configura las credenciales necesarias



# Importar workflow5. Activa el workflow✅ **IMPLEMENTADO**

# En n8n UI: Menú → Import from File → Seleccionar workflows/flow_HU01.json

```



## 📁 Estructura del Proyecto### 3. Iniciar el Servidor del Formulario```bash- Todos los campos completados correctamente



```

Proyecto-n8n/

│```bashdocker-compose up -d- Documento PDF adjunto

├── 📖 README.md                       # Este archivo

├── 👨‍💻 DEVELOPERS.md                   # Guía para desarrolladorespython3 -m http.server 8080

├── 🐳 docker-compose.yml              # Configuración de n8n

├── 🚫 .gitignore                      # Archivos excluidos``````- Sistema registra en Google Sheets

│

├── 👥 developers/                     # Carpeta por desarrollador

│   └── lucas/                         # Espacio de Lucas

│       └── hu001/                     # Historia de Usuario 001Formulario disponible en: http://localhost:8080/formulario-convalidacion-unab.html- Envía email de confirmación

│           ├── README.md              # Guía específica de HU-001

│           ├── CONFIG.md              # Configuración

│           ├── formulario-convalidacion-unab.html

│           ├── workflows/             # Workflows de n8n (.json)### 4. Ejecutar Pruebasn8n estará disponible en: http://localhost:5678

│           ├── docs/                  # Documentación técnica

│           └── tests/                 # Scripts de prueba

│

├── 📚 shared/                         # Recursos compartidos```bash### Escenario 2 – Intento de envío sin adjuntar documento  

│   ├── docs/                          # Documentación general

│   │   └── CONFIGURACION_APIS.md     # Guía de APIs./test_hu01.sh

│   ├── specs/                         # Especificaciones

│   │   ├── Proyecto-Gestor-Convalidaciones-Academicas.txt```### 2. Importar el Workflow✅ **IMPLEMENTADO**

│   │   └── sprint1.txt

│   └── scripts/                       # Scripts utilitarios

│

├── 💾 n8n/                            # Datos persistentes (NO versionar)## 📁 Estructura del Proyecto- Formulario muestra mensaje de error

│   ├── database.sqlite                # Base de datos de n8n

│   ├── config                         # Configuración

│   ├── binaryData/                    # Archivos binarios

│   └── nodes/                         # Nodos personalizados```1. Accede a n8n (http://localhost:5678)- No se procesa la solicitud

│

└── 📋 Archivos legacy/                # (Se moverán a estructura nueva)Proyecto-n8n/

    ├── flow_HU01.json

    ├── formulario-convalidacion-unab.html├── docker-compose.yml                                # Configuración de n8n2. Ve a: Menú → Import from File

    ├── test_hu01.sh

    └── HU-01_*.md├── flow_HU01.json                                    # Workflow de n8n para HU-01

```

├── formulario-convalidacion-unab.html               # Formulario web UNAB3. Selecciona: `flow_HU01.json`### Escenario 3 – Intento de envío con formato incorrecto  

## 🎯 Historias de Usuario Implementadas

├── test_hu01.sh                                      # Script de pruebas automatizadas

### ✅ HU-001: Recepción de Solicitud de Convalidación

**Desarrollador:** Lucas Maulén  ├── README.md                                         # Este archivo4. Configura las credenciales necesarias✅ **IMPLEMENTADO**

**Estado:** Completado  

**Sprint:** 1│



Sistema completo de recepción de solicitudes:├── Proyecto-Gestor-Convalidaciones-Academicas.txt   # 📄 Especificaciones del proyecto5. Activa el workflow- Sistema rechaza archivos no-PDF

- Formulario web con validación client-side

- Webhook n8n para procesamiento├── sprint1.txt                                       # 📄 Contexto del Sprint 1

- Almacenamiento en Google Sheets

- Email de confirmación automático│- Notifica que solo se aceptan PDFs

- Logging de operaciones

├── HU-01_FICHA_TECNICA.md                           # Especificación técnica

**📂 Ver:** [`developers/lucas/hu001/`](developers/lucas/hu001/)

├── HU-01_CASOS_PRUEBA.md                            # Casos de prueba### 3. Iniciar el Servidor del Formulario

---

├── HU-01_RESULTADOS_PRUEBAS.md                      # Resultados de pruebas

### 🚧 HU-002: Validación de Documentos

**Desarrollador:** [Pendiente]  ├── HU-01_RESUMEN_FINAL.md                           # Resumen ejecutivo## 🏗️ Arquitectura del Sistema

**Estado:** Planificado  

**Sprint:** 2│



*(Descripción pendiente)*└── n8n/                                              # Datos persistentes de n8n```bash



---    ├── database.sqlite                               # Base de datos (workflows, credenciales)



### 📅 HU-003: Dashboard de Seguimiento    ├── binaryData/                                   # Archivos binariospython3 -m http.server 8080### Flujo Completo:

**Desarrollador:** [Pendiente]  

**Estado:** Backlog      ├── nodes/                                        # Nodos personalizados

**Sprint:** TBD

    ├── config                                        # Configuración```1. **Formulario Web** → Estudiante ingresa datos

*(Descripción pendiente)*

    └── CONFIGURACION_APIS.md                        # Guía de configuración de APIs

## 🛠️ Stack Tecnológico

```2. **Validación Cliente** → JavaScript valida PDF y campos

| Componente | Tecnología | Versión |

|------------|------------|---------|

| **Orchestration** | n8n | 1.113.3 |

| **Database** | SQLite | 3.x |## 📄 Archivos de ContextoFormulario disponible en: http://localhost:8080/formulario-convalidacion-unab.html3. **Webhook n8n** → Recibe datos vía POST

| **Storage** | Google Sheets API | v4 |

| **Email** | SMTP (Gmail/Ethereal) | - |

| **Frontend** | HTML5 + Vanilla JS | - |

| **Runtime** | Docker | 24.x |### `Proyecto-Gestor-Convalidaciones-Academicas.txt`4. **Validación Servidor** → n8n valida campos obligatorios

| **Testing** | Bash Scripts + curl | - |

Especificaciones generales del proyecto, incluyendo:

## 🔧 Configuración

- Objetivo del sistema### 4. Ejecutar Pruebas5. **Google Sheets** → Guarda en hoja "Solicitudes"

### Variables de Entorno (docker-compose.yml)

- Alcance del proyecto

```yaml

N8N_HOST: localhost- Historias de usuario planificadas6. **Google Sheets** → Registra log en hoja "Logs"

N8N_PORT: 5678

N8N_PROTOCOL: http- Requisitos funcionales

WEBHOOK_URL: http://localhost:5678/

GENERIC_TIMEZONE: America/Santiago```bash7. **Email SMTP** → Envía confirmación al estudiante

```

### `sprint1.txt`

### APIs Requeridas

Documentación específica del Sprint 1:./test_hu01.sh8. **Respuesta JSON** → Retorna resultado al formulario

1. **Google Sheets API** - Almacenamiento de datos

2. **Google Drive API** - Gestión de documentos (futuro)- HU-01: Recepción de Solicitud

3. **SMTP** - Notificaciones por email

- Criterios de aceptación```

Ver guía completa: [`shared/docs/CONFIGURACION_APIS.md`](shared/docs/CONFIGURACION_APIS.md)

- Definición de terminado

## 🧪 Testing

- Detalles de implementación## 📁 Archivos del Proyecto

Cada HU incluye tests automatizados:



```bash

# Ejemplo: Tests de HU-001## ⚙️ Configuración## 📁 Estructura del Proyecto

cd developers/lucas/hu001/tests

chmod +x test_hu01.sh

./test_hu01.sh

```### Credenciales Necesarias### `/developer/lucas/`



## 👥 Equipo de Desarrollo



### Desarrolladores Activos#### 1. Google Sheets API (OAuth2)``````



- **Lucas Maulén Riquelme** - HU-001- Ver guía completa en: `n8n/CONFIGURACION_APIS.md`

  - Email: l.maulnriquelme@uandresbello.edu

  - Carpeta: `developers/lucas/`- Crear proyecto en Google Cloud ConsoleProyecto-n8n/├── flow_HU01.json                      # Flujo completo de n8n



### Agregar Nuevo Desarrollador- Habilitar APIs: Google Sheets + Google Drive



1. Crear carpeta: `developers/TU_NOMBRE/`- Configurar OAuth2 y agregar usuario de prueba├── docker-compose.yml                    # Configuración de n8n├── formulario-convalidacion-unab.html  # Formulario web con colores UNAB

2. Leer guía: [`DEVELOPERS.md`](DEVELOPERS.md)

3. Copiar template de HU desde `developers/lucas/hu001/`

4. Seguir convenciones de commits y PRs

#### 2. SMTP para Emails├── flow_HU01.json                        # Workflow de n8n para HU-01├── test_hu01.sh                        # Script de pruebas automatizadas

## 📚 Documentación

- **Opción 1 (Producción):** Gmail con App Password

- **👨‍💻 [Guía para Desarrolladores](DEVELOPERS.md)** - Setup, convenciones, workflow

- **📖 [Especificaciones del Proyecto](shared/specs/)** - Requerimientos y alcance- **Opción 2 (Testing):** Ethereal Email├── formulario-convalidacion-unab.html   # Formulario web UNAB├── sprint1.txt                         # Documentación Sprint 1

- **🔧 [Configuración de APIs](shared/docs/CONFIGURACION_APIS.md)** - Setup de Google Cloud

- **📝 HU Específicas** - Ver README en cada carpeta `developers/*/huXXX/`- Configurar credenciales en n8n



## 🚦 Comandos Comunes├── test_hu01.sh                          # Script de pruebas automatizadas├── Proyecto-Gestor-Convalidaciones-Academicas.txt  # Especificaciones



```bash### Webhook

# Gestión de n8n

docker-compose up -d          # Iniciar n8n├── README.md                             # Este archivo└── README.md                           # Este archivo

docker-compose down           # Detener n8n

docker-compose restart        # Reiniciar n8n- **URL de Producción:** `http://localhost:5678/webhook/solicitud-convalidacion`

docker-compose logs -f n8n    # Ver logs en tiempo real

- **Método:** POST│```

# Desarrollo

cd developers/TU_NOMBRE/huXXX/     # Navegar a tu HU- **Content-Type:** application/json

python3 -m http.server 8080        # Servidor para formularios

./tests/test_huXXX.sh              # Ejecutar tests├── HU-01_FICHA_TECNICA.md               # Especificación técnica



# Git## 🧪 Casos de Prueba

git checkout -b feature/huXXX-descripcion    # Nueva branch

git add developers/TU_NOMBRE/                # Agregar tus cambios├── HU-01_CASOS_PRUEBA.md                # Casos de prueba## 🚀 Cómo Usar

git commit -m "feat(huXXX): descripción"     # Commit

git push origin feature/huXXX-descripcion    # PushEl script `test_hu01.sh` ejecuta automáticamente:

```

├── HU-01_RESULTADOS_PRUEBAS.md          # Resultados de pruebas

## 🔒 Seguridad y Buenas Prácticas

- ✅ **TC1.1:** Solicitud válida completa

### ❌ NO Versionar

- ✅ **TC1.2:** Campo obligatorio faltante├── HU-01_RESUMEN_FINAL.md               # Resumen ejecutivo### 1. Importar el Flujo en n8n

- Credenciales de APIs

- Contraseñas o API keys- ✅ **TC1.3:** Múltiples campos faltantes

- `n8n/database.sqlite`

- `n8n/config` con credenciales- ✅ **TC5.1:** Caracteres especiales en nombres│```bash

- Archivos personales con datos reales

- ✅ **TC2.1:** Verificación de email de confirmación

### ✅ SÍ Versionar

└── n8n/                                  # Datos persistentes de n8n# En n8n, ir a: Import from File

- Workflows de n8n (.json exportados)

- DocumentaciónVer detalles en: `HU-01_CASOS_PRUEBA.md`

- Scripts de tests

- Código fuente (HTML, JS, etc.)    ├── database.sqlite                   # Base de datos (workflows, credenciales)# Seleccionar: flow_HU01.json



Ver: [`.gitignore`](.gitignore)## 📊 Funcionalidad Implementada



## 🐛 Troubleshooting    ├── binaryData/                       # Archivos binarios```



### n8n no inicia### Flujo de Trabajo (Workflow)



```bash    ├── nodes/                            # Nodos personalizados

docker-compose down

docker-compose up -d1. **Recepción:** Webhook recibe solicitud POST

docker-compose logs n8n

```2. **Validación:** Verifica campos obligatorios y formato PDF    ├── config                            # Configuración### 2. Configurar Credenciales



### Webhook no responde3. **Registro:** Almacena en Google Sheets (hoja "Solicitudes")



1. Verificar que n8n está corriendo: `curl http://localhost:5678/healthz`4. **Logging:** Registra evento en Google Sheets (hoja "Logs")    └── CONFIGURACION_APIS.md            # Guía de configuración de APIs

2. Verificar que workflow está **activo** (toggle en n8n UI)

3. Revisar logs de ejecución en n8n5. **Notificación:** Envía email de confirmación al estudiante



### Más ayuda6. **Respuesta:** Retorna JSON con resultado```#### Google Sheets OAuth2:



- Ver: [`DEVELOPERS.md - Debugging`](DEVELOPERS.md#-debugging)

- Issues: [GitHub Issues](https://github.com/maudevdigital/Proyecto-n8n/issues)

### Campos Validados1. Settings > Credentials > Google Sheets OAuth2 API

## 📈 Roadmap



### Sprint 1 (Actual) ✅

- [x] HU-001: Recepción de solicitudes- Nombre completo del estudiante## ⚙️ Configuración2. Configurar Client ID y Client Secret

- [x] Setup de infraestructura

- [x] Documentación inicial- RUT (formato chileno)



### Sprint 2 (Próximo) 🚧- Email institucional3. Autorizar acceso

- [ ] HU-002: Validación de documentos

- [ ] HU-003: Almacenamiento en Drive- Carrera actual

- [ ] Mejoras en formularios

- Asignatura a convalidar### Credenciales Necesarias

### Sprint 3+ (Futuro) 📅

- [ ] Dashboard de seguimiento- Institución de origen

- [ ] Sistema de notificaciones

- [ ] Reportes automáticos- Certificado de notas (PDF)#### SMTP (Ethereal Email para pruebas):

- [ ] Integración con sistemas UNAB



## 🤝 Contribuir

## 🔒 Persistencia de Datos#### 1. Google Sheets API (OAuth2)1. Ir a: https://ethereal.email/create

1. Fork el repositorio

2. Crear branch: `feature/huXXX-nombre`

3. Seguir estructura en `developers/TU_NOMBRE/`

4. Documentar todo en README.mdLos datos de n8n (workflows, credenciales, ejecuciones) se almacenan en:- Ver guía completa en: `n8n/CONFIGURACION_APIS.md`2. Copiar credenciales generadas

5. Crear Pull Request

```

Ver guía completa: [`DEVELOPERS.md`](DEVELOPERS.md)

./n8n/database.sqlite- Crear proyecto en Google Cloud Console3. Configurar en n8n

## 📄 Licencia

```

Proyecto académico - Universidad Andrés Bello (UNAB)  

© 2025 UNAB - Todos los derechos reservados- Habilitar APIs: Google Sheets + Google Drive



---**Importante:** Esta carpeta garantiza que tu configuración persista entre reinicios.



## 📞 Contacto- Configurar OAuth2 y agregar usuario de prueba### 3. Levantar Formulario Web



**Proyecto:** Sistema de Convalidaciones UNAB  ## 📝 Documentación Adicional

**Institución:** Universidad Andrés Bello  

**Repositorio:** https://github.com/maudevdigital/Proyecto-n8n```bash



**Coordinador del Proyecto:**  - **Ficha Técnica:** `HU-01_FICHA_TECNICA.md`

Lucas Maulén Riquelme - l.maulnriquelme@uandresbello.edu

- **Casos de Prueba:** `HU-01_CASOS_PRUEBA.md`#### 2. SMTP para Emailscd /workspaces/Proyecto-n8n/developer/lucas

---

- **Resultados:** `HU-01_RESULTADOS_PRUEBAS.md`

<p align="center">

  <img src="https://img.shields.io/badge/Made%20with-n8n-FF6D5A?style=for-the-badge&logo=n8n" alt="Made with n8n"/>- **Resumen Final:** `HU-01_RESUMEN_FINAL.md`- **Opción 1 (Producción):** Gmail con App Passwordpython3 -m http.server 8080

  <img src="https://img.shields.io/badge/UNAB-2025-E30613?style=for-the-badge" alt="UNAB 2025"/>

</p>- **Configuración APIs:** `n8n/CONFIGURACION_APIS.md`


- **Opción 2 (Testing):** Ethereal Email# Acceder a: http://localhost:8080/formulario-convalidacion-unab.html

## 🛠️ Comandos Útiles

- Configurar credenciales en n8n```

```bash

# Iniciar n8n

docker-compose up -d

### Webhook### 4. Ejecutar Pruebas

# Detener n8n

docker-compose down```bash



# Ver logs de n8n- **URL de Producción:** `http://localhost:5678/webhook/solicitud-convalidacion`chmod +x test_hu01.sh

docker-compose logs -f

- **Método:** POST./test_hu01.sh

# Reiniciar n8n

docker-compose restart- **Content-Type:** application/json```



# Ejecutar pruebas

./test_hu01.sh

## 🧪 Casos de Prueba## 🧪 Casos de Prueba

# Servidor para formulario

python3 -m http.server 8080

```

El script `test_hu01.sh` ejecuta automáticamente:### TC1.1 - Caso Válido Completo

## 👥 Equipo

**Input:**

**Desarrollador:** Lucas Maulén Riquelme  

**Email:** l.maulnriquelme@uandresbello.edu  - ✅ **TC1.1:** Solicitud válida completa```json

**Institución:** Universidad Andrés Bello (UNAB)

- ✅ **TC1.2:** Campo obligatorio faltante{

## 📄 Licencia

- ✅ **TC1.3:** Múltiples campos faltantes  "nombre": "María Elena Rodríguez",

Proyecto académico - UNAB 2025

- ✅ **TC5.1:** Caracteres especiales en nombres  "rut": "20.111.222-3",

- ✅ **TC2.1:** Verificación de email de confirmación  "carrera": "Psicología",

  "asignatura": "Estadística Aplicada",

Ver detalles en: `HU-01_CASOS_PRUEBA.md`  "institucionOrigen": "Universidad de Santiago",

  "documentos": "certificado_maria.pdf",

## 📊 Funcionalidad Implementada  "email": "maria.elena@test.com"

}

### Flujo de Trabajo (Workflow)```

**Output:** HTTP 200 - Solicitud registrada

1. **Recepción:** Webhook recibe solicitud POST

2. **Validación:** Verifica campos obligatorios y formato PDF### TC1.2 - Campo Obligatorio Faltante

3. **Registro:** Almacena en Google Sheets (hoja "Solicitudes")**Input:** Sin campo `rut`

4. **Logging:** Registra evento en Google Sheets (hoja "Logs")**Output:** HTTP 200 - Error de validación

5. **Notificación:** Envía email de confirmación al estudiante

6. **Respuesta:** Retorna JSON con resultado### TC1.3 - Múltiples Campos Faltantes

**Input:** Solo nombre y carrera

### Campos Validados**Output:** HTTP 200 - Lista de campos faltantes



- Nombre completo del estudiante### TC2.1 - Verificación de Email

- RUT (formato chileno)**Input:** Solicitud válida con email

- Email institucional**Output:** Email de confirmación enviado

- Carrera actual

- Asignatura a convalidar### TC5.1 - Caracteres Especiales

- Institución de origen**Input:** Nombres con tildes, ñ, guiones

- Certificado de notas (PDF)**Output:** HTTP 200 - Procesa correctamente



## 🔒 Persistencia de Datos## 📊 Estructura Google Sheets



Los datos de n8n (workflows, credenciales, ejecuciones) se almacenan en:### Hoja "Solicitudes"

```| ID | Fecha | Estudiante | RUT | Carrera | Asignatura | InstitucionOrigen | Estado |

./n8n/database.sqlite|----|-------|------------|-----|---------|------------|-------------------|--------|

```

### Hoja "Logs"

**Importante:** Esta carpeta garantiza que tu configuración persista entre reinicios.| Timestamp | ID | Status | Details |

|-----------|----|---------| --------|

## 📝 Documentación Adicional

## 🎨 Colores UNAB

- **Ficha Técnica:** `HU-01_FICHA_TECNICA.md`- Rojo Principal: `#E30613`

- **Casos de Prueba:** `HU-01_CASOS_PRUEBA.md`- Rojo Oscuro: `#8B0000`

- **Resultados:** `HU-01_RESULTADOS_PRUEBAS.md`- Gris Oscuro: `#333333`

- **Resumen Final:** `HU-01_RESUMEN_FINAL.md`- Gris Claro: `#666666`

- **Configuración APIs:** `n8n/CONFIGURACION_APIS.md`

## 📧 Configuración Email

## 🛠️ Comandos Útiles

### Ethereal Email (Pruebas)

```bash- Host: smtp.ethereal.email

# Iniciar n8n- Port: 587

docker-compose up -d- SSL/TLS: Desactivado

- Ver emails: https://ethereal.email/messages

# Detener n8n

docker-compose down### Gmail (Producción)

- Host: smtp.gmail.com

# Ver logs de n8n- Port: 587

docker-compose logs -f- SSL/TLS: STARTTLS

- Requiere: App Password

# Reiniciar n8n

docker-compose restart## 🔧 Tecnologías Utilizadas

- **n8n**: Orquestación y automatización

# Ejecutar pruebas- **Google Sheets API**: Almacenamiento de datos

./test_hu01.sh- **SMTP/Ethereal**: Envío de emails

- **HTML/CSS/JavaScript**: Formulario web

# Servidor para formulario- **Python HTTP Server**: Servidor local

python3 -m http.server 8080

```## 📈 Métricas de Éxito

- ✅ 100% de solicitudes válidas procesadas

## 👥 Equipo- ✅ Tiempo de respuesta < 8 segundos

- ✅ 0% pérdida de datos

**Desarrollador:** Lucas Maulén Riquelme  - ✅ Email confirmación enviado en < 10 segundos

**Email:** l.maulnriquelme@uandresbello.edu  - ✅ Validación de PDF funcionando

**Institución:** Universidad Andrés Bello (UNAB)- ✅ Detección de campos faltantes



## 📄 Licencia## 🐛 Solución de Problemas



Proyecto académico - UNAB 2025### Error: "Unable to sign without access token"

**Solución:** Reconectar credencial OAuth2 de Google Sheets

### Error: "Sheet with ID not found"
**Solución:** Usar Sheet ID numérico (0 para primera hoja)

### Email no se ve bien
**Solución:** Activar modo "Expression" en campo Text del nodo Email

## 👨‍💻 Desarrollador
- **Nombre:** Lucas Maulen
- **Email:** lucasmaulenr@gmail.com
- **Proyecto:** Sistema de Convalidaciones Académicas UNAB
- **Sprint:** 1
- **Fecha:** Octubre 2025

## 📝 Notas Adicionales
- El formulario valida PDF del lado del cliente y del servidor
- Los datos se guardan en Google Sheets en tiempo real
- El sistema envía confirmación por email automáticamente
- Todos los criterios de aceptación están cumplidos
- El flujo está completamente funcional y probado

---
**Versión:** 1.0  
**Última actualización:** 18 de octubre de 2025
