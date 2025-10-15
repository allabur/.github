# 📖 Índice de Documentación - Prompts de Copilot

## 🚀 Por Dónde Empezar

```
┌─────────────────────────────────────────────────────────┐
│  1. Lee SUMMARY.md (este archivo está arriba ⬆️)        │
│     → Entender qué se creó y por qué                   │
│                                                         │
│  2. Sigue SETUP-GUIDE.md                               │
│     → Configurar en 5 minutos                          │
│                                                         │
│  3. Usa prompts-quick-reference.md                     │
│     → Cheat sheet para uso diario                      │
└─────────────────────────────────────────────────────────┘
```

## 📄 Documentos por Propósito

### Para Configurar (Primera Vez)

1. **[SUMMARY.md](SUMMARY.md)**

   - ✨ **LEE PRIMERO**: Qué se creó y beneficios
   - Tiempo: 3 minutos

2. **[SETUP-GUIDE.md](SETUP-GUIDE.md)**

   - 🔧 Guía paso a paso para configurar
   - Incluye troubleshooting
   - Tiempo: 5 minutos de setup

3. **[settings-snippet.json](../settings-snippet.json)**
   - 📋 Copia y pega en tu settings.json
   - Configuración lista para usar

### Para Usar Diariamente

4. **[prompts-quick-reference.md](prompts-quick-reference.md)**

   - ⚡ Cheat sheet rápido
   - Lista de comandos y uso
   - **Guárdalo en favoritos**

5. **[prompts/README.md](../prompts/README.md)**
   - 📚 Documentación completa de cada prompt
   - Ejemplos detallados
   - Casos de uso

### Para Personalizar

6. **[prompt-recommendations-config.md](prompt-recommendations-config.md)**

   - ⚙️ Configuración avanzada
   - Cómo agregar patrones personalizados
   - Múltiples ubicaciones

7. **Archivos `.prompt.md` en [../prompts/](../prompts/)**
   - 🎨 Editar prompts existentes
   - Crear nuevos prompts
   - Usar como plantilla

### Referencias Generales

8. **[../copilot-instructions.md](../copilot-instructions.md)**

   - 📖 Instrucciones generales de Copilot
   - Incluye nueva sección de prompts
   - Tech stack y workflows

9. **[../README.md](../README.md)**
   - 🏠 README principal del repo
   - Arquitectura completa
   - Todos los recursos

## 🎯 Flujos de Lectura Recomendados

### Si Tienes 5 Minutos (Setup Rápido)

```
1. SUMMARY.md (página 1)
2. SETUP-GUIDE.md (sección "Paso 1-3")
3. settings-snippet.json (copiar y pegar)
4. ¡Probar un prompt!
```

### Si Tienes 15 Minutos (Entender Todo)

```
1. SUMMARY.md (completo)
2. SETUP-GUIDE.md (completo)
3. prompts-quick-reference.md (completo)
4. Probar todos los prompts
```

### Si Quieres Personalizar

```
1. SETUP-GUIDE.md (completo)
2. prompt-recommendations-config.md
3. prompts/README.md (sección "Creating Custom Prompts")
4. Editar un .prompt.md de ejemplo
```

### Si Solo Quieres Recordar Comandos

```
→ prompts-quick-reference.md
(imprime o guarda en favoritos)
```

## 📁 Estructura de Archivos

```
.github/
├── docs/
│   ├── INDEX.md                          ← Estás aquí
│   ├── SUMMARY.md                        ← Resumen ejecutivo
│   ├── SETUP-GUIDE.md                    ← Guía de configuración
│   ├── prompts-quick-reference.md        ← Cheat sheet
│   └── prompt-recommendations-config.md  ← Config avanzada
│
├── prompts/
│   ├── README.md                         ← Doc de prompts
│   ├── analyze-dataframe.prompt.md
│   ├── document-function.prompt.md
│   ├── generate-pytest.prompt.md
│   ├── create-latex-table.prompt.md
│   ├── optimize-code.prompt.md
│   ├── review-commit.prompt.md
│   └── ai-prompt-engineering-safety-review.prompt.md
│
├── settings-snippet.json                 ← Copiar a settings
├── copilot-instructions.md               ← Instrucciones generales
└── README.md                             ← README principal
```

## 🔍 Buscar Información Específica

### "¿Cómo uso los prompts?"

→ [prompts-quick-reference.md](prompts-quick-reference.md) → Sección "Usage"

### "¿Cómo configuro las sugerencias automáticas?"

→ [SETUP-GUIDE.md](SETUP-GUIDE.md) → Sección "Paso 1"

### "¿Qué hace cada prompt exactamente?"

→ [prompts/README.md](../prompts/README.md) → Sección "Available Prompts"

### "¿Cómo creo mi propio prompt?"

→ [prompts/README.md](../prompts/README.md) → Sección "Creating Custom Prompts"

### "¿Por qué no funcionan los prompts?"

→ [SETUP-GUIDE.md](SETUP-GUIDE.md) → Sección "Solución de Problemas"

### "¿Qué prompts usar para mi caso de uso?"

→ [SUMMARY.md](SUMMARY.md) → Sección "Casos de Uso Para Ti"

### "¿Cómo modifico la configuración avanzada?"

→ [prompt-recommendations-config.md](prompt-recommendations-config.md)

## ✅ Checklist de Setup

Marca conforme completes:

- [ ] Leído SUMMARY.md
- [ ] Seguido SETUP-GUIDE.md
- [ ] Copiado settings-snippet.json a settings.json
- [ ] Reiniciado VS Code
- [ ] Probado `/analyze-dataframe`
- [ ] Probado `/document-function`
- [ ] Probado `/generate-pytest`
- [ ] Guardado prompts-quick-reference.md en favoritos
- [ ] Explorado prompts/README.md
- [ ] Creado mi primer prompt personalizado (opcional)

## 🎓 Recursos Externos

- [VS Code Prompt Files Docs](https://aka.ms/vscode-instructions-docs)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [NumPy Docstring Guide](https://numpydoc.readthedocs.io/)
- [Pytest Documentation](https://docs.pytest.org/)
- [LaTeX booktabs Package](https://ctan.org/pkg/booktabs)

## 💬 Feedback y Mejoras

¿Encontraste algo confuso? ¿Falta información?

1. Edita el documento correspondiente
2. Agrega tu caso de uso específico
3. Mejora los ejemplos con tus datos
4. Commit con `/review-commit` 😉

## 🎯 Objetivo Final

Después de leer estos documentos deberías poder:

✅ Usar los 6 prompts principales sin pensar
✅ Configurar sugerencias automáticas para tu contexto
✅ Crear tus propios prompts personalizados
✅ Integrarlos en tu flujo de trabajo CHUM
✅ Ahorrar horas de trabajo repetitivo

---

**🚀 Acción Inmediata**: Abre [SUMMARY.md](SUMMARY.md) y dedica 3 minutos a leerlo.

Luego sigue con [SETUP-GUIDE.md](SETUP-GUIDE.md) para configurar todo en 5 minutos.

**En total: 8 minutos de lectura/setup → Horas ahorradas cada semana** ⚡
