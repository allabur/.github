# Configuración Completa de Prompts - Guía Paso a Paso

## 🎯 Lo Que Acabamos de Crear

He creado **6 prompts personalizados** específicamente para tu forma de trabajar:

1. **`/analyze-dataframe`** - Análisis exhaustivo de DataFrames
2. **`/document-function`** - Docstrings NumPy automáticos
3. **`/generate-pytest`** - Tests pytest completos
4. **`/create-latex-table`** - Tablas LaTeX para papers
5. **`/optimize-code`** - Optimización de rendimiento
6. **`/review-commit`** - Mensajes de commit convencionales

Más el prompt existente: 7. **`/ai-safety-review`** - Revisión de seguridad de prompts

## 📝 Paso 1: Copiar Configuración a settings.json

1. Abre tu `settings.json` en VS Code:

   - Cmd+Shift+P (Mac) o Ctrl+Shift+P (Windows)
   - Escribe "Preferences: Open User Settings (JSON)"

2. Encuentra la línea con `"chat.promptFilesRecommendations": {}`

3. Copia el contenido de `settings-snippet.json` (en este repo)

4. Pégalo reemplazando las llaves vacías `{}`

**Resultado esperado:**

```jsonc
"chat.promptFilesRecommendations": {
  "**/*.py": [
    ".github/prompts/document-function.prompt.md",
    // ... más prompts
  ],
  "**/*.ipynb": [
    ".github/prompts/analyze-dataframe.prompt.md",
    // ... más prompts
  ]
  // ... resto de configuración
}
```

## 🔧 Paso 2: Verificar Configuración de Prompts

Asegúrate de que estas líneas estén en tu `settings.json`:

```jsonc
{
  "chat.promptFiles": true, // ✅ Ya lo tienes
  "chat.promptFilesLocations": {
    "/Users/allabur/Library/CloudStorage/OneDrive-UPV/3_resources/software/vscode-copilot/config/prompts": true, // ✅ Ya lo tienes
    // Opcional: agregar la ruta de este repo para que funcione en todos los proyectos
    "/Users/allabur/dotfiles/.github/prompts": true
  }
}
```

## 🚀 Paso 3: Reiniciar VS Code

Cierra y reabre VS Code para que los cambios surtan efecto.

## ✅ Paso 4: Probar los Prompts

### Prueba 1: Análisis de DataFrame

```python
# 1. Crea o abre un notebook
# 2. Ejecuta:
import pandas as pd
df = pd.DataFrame({
    'age': [25, 30, None, 45],
    'salary': [50000, 60000, 55000, 75000]
})

# 3. Selecciona 'df'
# 4. Abre Copilot Chat (Cmd+I)
# 5. Escribe /analyze-dataframe
# 6. ¡Deberías ver un análisis completo!
```

### Prueba 2: Documentar Función

```python
# 1. Escribe una función sin docstring:
def calculate_discount(price, discount_percent):
    return price * (1 - discount_percent / 100)

# 2. Selecciona la función
# 3. Cmd+I → /document-function
# 4. ¡Deberías obtener docstring NumPy completo!
```

### Prueba 3: Generar Tests

```python
# 1. Usando la función de arriba
# 2. Selecciónala
# 3. Cmd+I → /generate-pytest
# 4. ¡Obtendrás tests con AAA pattern, fixtures, parametrización!
```

### Prueba 4: Tabla LaTeX

```python
# 1. En un notebook con resultados:
results = pd.DataFrame({
    'Metric': ['Accuracy', 'Precision', 'Recall'],
    'Value': [0.95, 0.92, 0.88]
})

# 2. Selecciona 'results'
# 3. Cmd+I → /create-latex-table
# 4. ¡Tabla booktabs lista para tu paper!
```

### Prueba 5: Commit Review

```bash
# 1. En terminal:
git add .

# 2. En VS Code, abre Source Control (Ctrl+Shift+G)
# 3. En el campo de mensaje de commit
# 4. Cmd+I → /review-commit
# 5. ¡Mensaje de commit convencional generado!
```

## 🎨 Personalización Avanzada

### Agregar Prompts Personalizados

1. **Crea nuevo archivo** en `.github/prompts/`:

```bash
touch .github/prompts/mi-prompt-custom.prompt.md
```

2. **Usa la plantilla**:

```markdown
---
description: "Descripción breve de lo que hace"
---

# Título del Prompt

Eres un experto en [dominio]. Tu tarea es [definir tarea].

## Requisitos

- Requisito 1
- Requisito 2

## Formato de Salida

[Formato esperado]

## Ejemplos

[Ejemplos de uso]
```

3. **Agrégalo a recommendations**:

```jsonc
"**/*.py": [
  ".github/prompts/mi-prompt-custom.prompt.md"
]
```

### Modificar Prompts Existentes

Simplemente edita el archivo `.prompt.md` correspondiente en `.github/prompts/`. Los cambios se aplican inmediatamente (puede requerir reiniciar VS Code).

## 🔍 Solución de Problemas

### Problema: Los prompts no aparecen

**Solución:**

1. Verifica que `"chat.promptFiles": true`
2. Comprueba rutas en `"chat.promptFilesLocations"`
3. Reinicia VS Code (Cmd+Q y volver a abrir)
4. Verifica que los archivos tengan extensión `.prompt.md`

### Problema: Las sugerencias automáticas no funcionan

**Solución:**

1. Verifica que copiaste correctamente `promptFilesRecommendations`
2. Comprueba que las rutas en los arrays sean correctas
3. Prueba con rutas absolutas si las relativas no funcionan
4. Reinicia VS Code

### Problema: El prompt no genera lo esperado

**Solución:**

1. Revisa el prompt en `.github/prompts/nombre.prompt.md`
2. Asegúrate de seleccionar el código relevante antes de invocar
3. Prueba con ejemplos más simples primero
4. Modifica el prompt para hacerlo más específico

## 📊 Uso en Tu Flujo de Trabajo CHUM

### Para Análisis de Datos

```
1. Cargar datos de CHUM
2. /analyze-dataframe → Identificar problemas de calidad
3. Aplicar limpieza recomendada
4. Análisis estadístico
5. /create-latex-table → Exportar resultados para paper
```

### Para Desarrollo de Paquete

```
1. Escribir función de análisis
2. /document-function → Agregar docstring
3. /generate-pytest → Crear tests
4. /optimize-code → Si es lento
5. /review-commit → Commit con mensaje apropiado
```

### Para Papers

```
1. Generar resultados en notebook
2. /analyze-dataframe → Validar datos
3. /create-latex-table → Crear tablas
4. Copiar LaTeX a paper
5. Repetir para cada tabla/figura
```

## 🎓 Recursos Adicionales

- **[Quick Reference](docs/prompts-quick-reference.md)**: Cheat sheet de comandos
- **[Full Configuration](docs/prompt-recommendations-config.md)**: Configuración completa explicada
- **[Prompts README](prompts/README.md)**: Documentación detallada de cada prompt
- **[Copilot Instructions](copilot-instructions.md)**: Instrucciones generales actualizadas

## 💡 Consejos Pro

1. **Combina prompts**: `/document-function` → `/generate-pytest` → `/optimize-code`
2. **Itera**: Usa el mismo prompt múltiples veces con diferentes selecciones
3. **Ajusta**: Modifica los prompts en `.github/prompts/` según tus necesidades
4. **Comparte**: Estos prompts están en tu repo `.github`, aplican a todos tus proyectos
5. **Experimenta**: Crea prompts específicos para análisis CHUM

## 🆘 Ayuda

Si algo no funciona:

1. Revisa esta guía paso a paso
2. Verifica la sección "Solución de Problemas"
3. Comprueba los archivos de documentación en `docs/`
4. Revisa los ejemplos en `prompts/README.md`

---

**¡Disfruta de tus nuevos prompts! 🎉**

Ahora tienes herramientas potentes para:

- ✅ Analizar DataFrames automáticamente
- ✅ Documentar código con docstrings NumPy
- ✅ Generar tests completos con pytest
- ✅ Crear tablas LaTeX para papers
- ✅ Optimizar código lento
- ✅ Escribir commits convencionales

Todo adaptado específicamente a tu flujo de trabajo con Python, Jupyter, análisis de datos y publicaciones académicas.
