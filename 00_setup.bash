#!/bin/bash

bash scripts/00_install_repo_dependencies.bash
bash scripts/01_init_submodules.bash
bash scripts/02_build_fuzzers.bash
bash scripts/03_patch_fuzzers.bash
bash scripts/04_build_and_instrument_target.bash
