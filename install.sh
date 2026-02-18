#!/bin/bash

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

SYMLINK_FILES=(.aliases .zshrc_dotfiles)

MARKER="# --- dotfiles managed ---"

create_symlinks() {
    for name in "${SYMLINK_FILES[@]}"; do
        src="$SCRIPT_DIR/$name"
        dest="$HOME/$name"
        if [ -e "$src" ]; then
            echo "Linking $name → $dest"
            ln -sf "$src" "$dest"
        fi
    done
}

# Append a source line to an rc file if it isn't already present.
# This preserves whatever the cloud environment wrote into the file.
append_source_line() {
    local rc_file="$1"
    local source_target="$2"

    if [ ! -f "$rc_file" ]; then
        touch "$rc_file"
    fi

    if ! grep -qF "$MARKER" "$rc_file" 2>/dev/null; then
        printf '\n%s\n[ -f "%s" ] && source "%s"\n' \
            "$MARKER" "$source_target" "$source_target" >> "$rc_file"
        echo "Appended source line for $source_target → $rc_file"
    else
        echo "Source line already present in $rc_file, skipping"
    fi
}

create_symlinks

append_source_line "$HOME/.zshrc" "$HOME/.zshrc_dotfiles"

mkdir -p "$HOME/bin"

echo "Dotfiles installed ✅"
