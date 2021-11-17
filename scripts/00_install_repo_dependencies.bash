#!/bin/bash

SUDO="sudo"
PIP="pip3"
APT="apt"

REPO=`git rev-parse --show-toplevel`

echo "==> Installing repo dependencies using apt and pip"

$SUDO $APT update
DEBIAN_FRONTEND=noninteractive $SUDO $APT install -y git python3 python3-pip clang graphviz-dev build-essential tmux
$SUDO $PIP install virtualenv
$SUDO python3 -m venv "$REPO/scripts/python_venv"
source "$REPO/scripts/python_venv/bin/activate" && $PIP install -r "$REPO/scripts/requirements.txt"
