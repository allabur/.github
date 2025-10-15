#!/usr/bin/env bash
set -euo pipefail

# Directorio del script y repo (parent de .github)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Carpetas fuente (dentro de .github/) cuyos archivos se enlazarán
SRC_DIRS=("instructions" "prompts" "chatmodes")
# Carpeta destino en VSCode User (se crearán symlinks de archivos individuales aquí)
DEST_DIR="prompts"

# Detectar VSCode User data dir (override con VSCODE_USER_DIR)
detect_vscode_user_dir() {
    if [ -n "${VSCODE_USER_DIR-}" ]; then
        echo "$VSCODE_USER_DIR"
        return
    fi
    case "$(uname -s)" in
    Darwin)
        echo "$HOME/Library/Application Support/Code/User"
        ;;
    Linux)
        echo "$HOME/.config/Code/User"
        ;;
    # Git Bash / MSYS / WSL: usar APPDATA si existe
    MINGW* | MSYS* | CYGWIN* | Linux*)
        if [ -n "${APPDATA-}" ]; then
            echo "$APPDATA/Code/User"
        else
            # Fallback a WSL/Linux path
            echo "$HOME/.config/Code/User"
        fi
        ;;
    *)
        echo "$HOME/.config/Code/User"
        ;;
    esac
}

print_usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Creates symlinks of all files from .github/{instructions,prompts,chatmodes}
into VSCode User/prompts directory for GitHub Copilot custom instructions.

Options:
  -n, --dry-run    Show actions without making changes
  -y, --yes        Don't ask for confirmation
  -v, --verbose    Verbose output
  -h, --help       Show this help
Env:
  VSCODE_USER_DIR  Override auto-detected VS Code User directory
EOF
}

DRY_RUN=0
ASSUME_YES=0
VERBOSE=0

while [ $# -gt 0 ]; do
    case "$1" in
    -n | --dry-run)
        DRY_RUN=1
        shift
        ;;
    -y | --yes)
        ASSUME_YES=1
        shift
        ;;
    -v | --verbose)
        VERBOSE=1
        shift
        ;;
    -h | --help)
        print_usage
        exit 0
        ;;
    *)
        echo "Unknown arg: $1"
        print_usage
        exit 2
        ;;
    esac
done

VSCODE_USER_DIR="$(detect_vscode_user_dir)"
DEST_BASE="$VSCODE_USER_DIR/$DEST_DIR"

if [ "$VERBOSE" -eq 1 ]; then
    printf "Repo root: %s\n" "$REPO_ROOT"
    printf "VSCode User dir: %s\n" "$VSCODE_USER_DIR"
fi

if [ ! -d "$DEST_BASE" ]; then
    if [ "$DRY_RUN" -eq 0 ]; then
        printf "Creating destination dir: %s\n" "$DEST_BASE"
        mkdir -p "$DEST_BASE"
    else
        printf "[dry-run] Would create: %s\n" "$DEST_BASE"
    fi
fi

actions=()

# Iterar sobre cada carpeta fuente
for dir_name in "${SRC_DIRS[@]}"; do
    SRC_DIR="$REPO_ROOT/.github/$dir_name"

    if [ ! -d "$SRC_DIR" ]; then
        [ "$VERBOSE" -eq 1 ] && printf "Skipping missing source directory: %s\n" "$SRC_DIR"
        continue
    fi

    # Iterar sobre cada archivo en la carpeta fuente
    for src_file in "$SRC_DIR"/*; do
        # Saltar si no existen archivos (glob no expandido)
        [ -e "$src_file" ] || continue

        filename="$(basename "$src_file")"
        dest_file="$DEST_BASE/$filename"

        [ "$VERBOSE" -eq 1 ] && printf "Processing: %s -> %s\n" "$src_file" "$dest_file"

        if [ -L "$dest_file" ]; then
            # Symlink existente
            current_target="$(readlink "$dest_file")"
            if [ "$current_target" = "$src_file" ]; then
                [ "$VERBOSE" -eq 1 ] && printf "  Already linked correctly\n"
                continue
            fi

            if [ "$DRY_RUN" -eq 1 ]; then
                actions+=("[dry-run] Replace symlink $dest_file -> $src_file (was -> $current_target)")
            else
                [ "$VERBOSE" -eq 1 ] && printf "  Replacing symlink\n"
                rm "$dest_file"
                ln -s "$src_file" "$dest_file"
                actions+=("Replaced symlink $filename -> $src_file")
            fi

        elif [ -e "$dest_file" ]; then
            # Archivo/directorio existente que no es symlink: hacer backup
            backup="${dest_file}.bak.$(date +%s)"
            if [ "$DRY_RUN" -eq 1 ]; then
                actions+=("[dry-run] Backup $filename -> $(basename "$backup") ; ln -s $src_file")
            else
                [ "$VERBOSE" -eq 1 ] && printf "  Backing up existing file\n"
                mv "$dest_file" "$backup"
                ln -s "$src_file" "$dest_file"
                actions+=("Backed up $filename -> $(basename "$backup") ; symlinked -> $src_file")
            fi

        else
            # No existe: crear symlink
            if [ "$DRY_RUN" -eq 1 ]; then
                actions+=("[dry-run] Create symlink $filename -> $src_file")
            else
                ln -s "$src_file" "$dest_file"
                actions+=("Created symlink $filename -> $src_file")
            fi
        fi
    done
done

# Confirm summary
printf "\nSummary:\n"
if [ "${#actions[@]}" -eq 0 ]; then
    printf "No actions performed. All symlinks already correct.\n"
else
    for a in "${actions[@]}"; do
        printf " - %s\n" "$a"
    done
fi

if [ "$DRY_RUN" -eq 0 ] && [ "$ASSUME_YES" -eq 0 ] && [ "${#actions[@]}" -gt 0 ]; then
    printf "\nChanges have been applied successfully.\n"
fi

exit 0
