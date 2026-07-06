# Contribución

## Git Hooks

Este repositorio usa `pre-commit` para ejecutar validaciones locales antes de commits y pushes.

Instala `pre-commit` con Python:

```bash
pip install pre-commit
```

En distribuciones basadas en Arch, usa el paquete del sistema:

```bash
sudo pacman -S pre-commit
```

Activa los hooks en este repositorio:

```bash
pre-commit install
```

Ejecuta todos los hooks manualmente:

```bash
pre-commit run --all-files
```

## Pull Requests

Usa la plantilla de pull request del repositorio en `.github/pull_request_template.md`.

Los títulos de PR deben seguir el estilo Conventional Commits y estar escritos en inglés. El contenido del cuerpo del PR debe estar escrito en español.
