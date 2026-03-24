#!/usr/bin/env bash
npm install -g bash-language-server typescript-language-server vscode-langservers-extracted
nodenv rehash

# Prefer basedpyright
# Maybe we should install with pipx
#pip3 install -U jedi-language-server ruff
brew install basedpyright
