#!/bin/bash
path="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
exitcode=0

linkfile() {
    filename="$path/$1"
    destination="$HOME/$2"

    mkdir -p $(dirname "$destination")

    if [ -e "$destination" ]; then
        echo "[WARNING] conflict: $destination already exists, skipping"
        exitcode=1
    else
        ln -s "$filename" "$destination"
        echo "[LINK] $filename -> $destination"
    fi
}

linkfile zshrc .zshrc
linkfile zshenv .zshenv
linkfile vimfiles .vim

if [ -f "$HOME/.config" ]; then
    echo "[ERROR] $HOME/.config is a file, should be a dir"
    exit 1
fi

[ ! -e $HOME/.config ] && mkdir -p $HOME/.config

pushd $path/config >/dev/null

for dir in *; do
    linkfile "config/$dir" ".config/$dir"
done

popd >/dev/null

exit $exitcode
