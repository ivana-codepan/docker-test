#!/bin/bash

set -e

source /opt/conda/etc/profile.d/conda.sh

conda activate cp_base

if [ -f /software/dh-datascience/setup.py ]; then
    echo "Installing an editable version of datasci"
    pip -q uninstall -y datasci
    pip -q install --no-cache-dir -e /software/dh-datascience
fi

echo "Installing editable versions of datascience projects"

# Obtain all datasci project repositories with a setup.py file in the software folder.
declare -a inst_rep=($(find /software/ds-* -name '*setup.py*' -printf "%h\n" | sort -u))
for repo in "${inst_rep[@]}"; do
    echo "${repo}"
    # --no-cache-dir : Do not use cache when installing.
    # -e : Install each package in editable mode.
    # -q : Only print warning, critical and error.
    pip -q install --no-cache-dir -e "${repo}"
done

exec "$@"
