#!/bin/bash
. samurai-ide-web.rc
if [ $? -ne 0 ]; then
    echo "Error: samurai-ide-web.rc failed to load."
    exit 1
fi
me="$REPO_NAME/test.sh"
if [ ! -f "$$VENV_PYTHON" ]; then
    echo "Error: \"$VENV_PYTHON\" does not exist. Run ./install.sh first (to create the venv)."
    exit 1
fi
$VENV_PYTHON -m pip install django-nose

printf "* trying to install less..."
yarn add less
code=$?
if [ $code -eq 0 ]; then
    echo "OK"
else
    echo "FAILED (try running ./deps.sh first)"
fi

export DJANGO_SETTINGS_MODULE="mezzaninja.settings"
$VENV_PYTHON -m nose
code=$?
if [ $code -eq 0 ]; then
    echo "OK"
else
    echo "FAILED"
    if [ ! -f "./mezzaninja/settings/active.py" ]; then
        echo "* If you see \"No module named active\" above, try:"
        echo " ln -s `realpath ./mezzaninja/settings/dev.py` `realpath ./mezzaninja/settings/active.py`"
        echo "  # then try running $0 again."
    fi
    exit $code
fi
