# Scripts de Utilidad

Scripts para automatizar el setup del entorno de desarrollo y gestión de proyectos.

## Disponibles

### vscode-setup.sh

Script para sincronizar instrucciones personalizadas de GitHub Copilot desde el repositorio dotfiles a VS Code.

#### ¿Qué Hace?

Crea **symlinks individuales** de todos los archivos desde estas carpetas:

- `.github/instructions/` - Instrucciones de código, testing, CI/CD, etc.
- `.github/prompts/` - Prompts reutilizables para tareas específicas
- `.github/chatmodes/` - Modos de chat especializados

Hacia el directorio de VS Code:

- **macOS**: `~/Library/Application Support/Code/User/prompts/`
- **Linux**: `~/.config/Code/User/prompts/`
- **Windows**: `%APPDATA%/Code/User/prompts/`

#### Ventajas de Symlinks

✅ **Sincronización automática**: Al modificar un archivo en el repo, el cambio aparece inmediatamente en VS Code  
✅ **Gestión centralizada**: Un solo lugar para todas las instrucciones  
✅ **Control de versiones**: Todos los cambios tracked en Git  
✅ **Backups automáticos**: El script respalda archivos existentes antes de sobrescribirlos

#### Uso

**Instalación Inicial:**

```bash
cd /Users/allabur/dotfiles/.github

# Ver qué haría sin ejecutar
./vscode-setup.sh --dry-run --verbose

# Ejecutar (aplica cambios inmediatamente)
./vscode-setup.sh --verbose

# O ejecutar sin mensajes de confirmación
./vscode-setup.sh -y
```

**Opciones:**

```
-n, --dry-run    Mostrar acciones sin ejecutar cambios
-y, --yes        No pedir confirmación (útil para scripts)
-v, --verbose    Mostrar salida detallada
-h, --help       Mostrar ayuda
```

---

### migrate-to-uv.sh

Migra proyectos Python desde conda/mamba/pip/Poetry hacia el gestor de paquetes **uv**.

#### ¿Qué Hace?

- Detecta configuración existente (environment.yml, requirements.txt, Poetry)
- Crea o actualiza pyproject.toml siguiendo PEP 621
- Migra dependencias a uv
- Instala y fija versión de Python
- Actualiza .gitignore
- Proporciona recomendaciones de limpieza

#### Migraciones Soportadas

- **conda/mamba** (environment.yml) → uv
- **pip** (requirements.txt + requirements-dev.txt) → uv
- **Poetry** (pyproject.toml) → uv (con ajustes manuales)

#### Uso

**Comandos básicos:**

```bash
# Vista previa sin hacer cambios
./migrate-to-uv.sh --dry-run

# Migrar manteniendo archivos antiguos como backup
./migrate-to-uv.sh --keep-old

# Migrar con Python 3.13
./migrate-to-uv.sh --python 3.13

# Migración completa instalando uv
./migrate-to-uv.sh --install-uv --python 3.13
```

**Opciones:**

```
--dry-run       Mostrar lo que se haría sin aplicar cambios
--keep-old      Mantener archivos antiguos (renombrar con extensión .old)
--python VER    Especificar versión de Python (default: 3.13)
--install-uv    Instalar uv si no está presente
--help          Mostrar mensaje de ayuda
```

#### Requisitos Previos

- Git repository recomendado (para fácil rollback)
- uv instalado o usar flag `--install-uv`

#### Ejemplo Completo

```bash
# 1. Clonar o navegar a tu proyecto
cd /path/to/my-project

# 2. Ver qué cambiaría el script
../dotfiles/.github/scripts/migrate-to-uv.sh --dry-run --python 3.13

# 3. Ejecutar migración manteniendo backups
../dotfiles/.github/scripts/migrate-to-uv.sh --keep-old --python 3.13

# 4. Verificar que todo funciona
uv run python --version
uv run pytest

# 5. Limpiar archivos antiguos (si todo está bien)
rm *.old

# 6. Commit
git add pyproject.toml uv.lock .gitignore
git commit -m "chore: migrate to uv package manager"
```

---

## VS Code Setup Script (Continuación)

### Variable de Entorno

```bash
# Sobrescribir ubicación de VS Code User
export VSCODE_USER_DIR="$HOME/.config/Code-Insiders/User"
./vscode-setup.sh
```

## Resultado

Después de ejecutar, tendrás todos los archivos accesibles en VS Code:

```
~/Library/Application Support/Code/User/prompts/
├── my-ci-cd.instructions.md → .github/instructions/my-ci-cd.instructions.md
├── my-code.instructions.md → .github/instructions/my-code.instructions.md
├── analyze-dataframe.prompt.md → .github/prompts/analyze-dataframe.prompt.md
├── document-function.prompt.md → .github/prompts/document-function.prompt.md
├── 4.1-Beast.chatmode.md → .github/chatmodes/4.1-Beast.chatmode.md
└── ...
```

## Comportamiento

### Primera Ejecución

- Crea la carpeta `prompts/` si no existe
- Crea symlinks de todos los archivos encontrados

### Ejecuciones Posteriores

- **Symlink existente apuntando al mismo archivo**: No hace nada (ya está correcto)
- **Symlink apuntando a otro archivo**: Lo reemplaza con el correcto
- **Archivo/carpeta real existente**: Hace backup (`.bak.timestamp`) y crea symlink

### Gestión de Conflictos

Si hay archivos existentes con el mismo nombre, el script:

1. Crea un backup: `archivo.md.bak.1729123456`
2. Crea el symlink al archivo del repo
3. Informa en el resumen

## Agregar Nuevos Archivos

1. Agrega tu archivo en `.github/instructions/`, `.github/prompts/` o `.github/chatmodes/`
2. Ejecuta el script de nuevo: `./vscode-setup.sh -v`
3. El nuevo archivo aparecerá automáticamente en VS Code

## Troubleshooting

### El script no encuentra VS Code

```bash
# Especifica manualmente la ubicación
export VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
./vscode-setup.sh -v
```

### Los cambios no aparecen en VS Code

1. Verifica que los symlinks se crearon: `ls -la ~/Library/Application\ Support/Code/User/prompts/`
2. Recarga VS Code: `Cmd+Shift+P` → "Developer: Reload Window"

### Revertir cambios

```bash
# Los backups están en la carpeta prompts/
ls -la ~/Library/Application\ Support/Code/User/prompts/*.bak.*

# Restaurar un archivo
cd ~/Library/Application\ Support/Code/User/prompts/
rm archivo.md
mv archivo.md.bak.1729123456 archivo.md
```

## Automatización

Para ejecutar automáticamente después de cada `git pull`:

```bash
# .git/hooks/post-merge
#!/bin/bash
.github/vscode-setup.sh -y
```

O agregar a tu script de instalación de dotfiles:

```bash
# install.sh
.github/vscode-setup.sh -y
```
