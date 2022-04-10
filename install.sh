#!/bin/bash

INSTALLER=""
INSTALL_SRC=""
cat <<END

Starting $0...
END
if [ -f "$0" ]; then
    INSTALLER=`realpath "$0"`
    INSTALL_SRC=`dirname $INSTALLER`
fi
if [ ! -z "$INSTALL_SRC" ]; then
    echo "* using INSTALL_SRC \"$INSTALL_SRC\" instead of git"
    echo "  * since using INSTALLER \"$INSTALLER\""
else
    echo "* using git as the install source"
fi

. samurai-ide-web.rc
if [ $? -ne 0 ]; then
    echo "Error: samurai-ide-web.rc failed to load."
    exit 1
fi
me="$REPO_NAME/install.sh"

# if [ ! -f "`command -v less`" ]; then
# ^ NOT RELIABLE (less has a different meaning on linux)!
printf "* finding a node package manager..."
if [ -f "`command -v yarn`" ]; then
    NPM="yarn"
    NPM_INSTALL="$NPM add"
elif [ -f "`command -v yarnpkg`" ]; then
    NPM="yarnpkg"
    NPM_INSTALL="$NPM add"
elif [ -f "`command -v npm`" ]; then
    NPM="npm"
    NPM_INSTALL="$NPM install"
else
    echo "Error: less is required, but there is no npm nor yarn nor yarnpkg. Run deps.sh as root first."
    exit 1
fi
echo "OK (using $NPM)"
# fi


# if [ $UID -ne 0 ]; then
#     echo "This script must run as root or WWW_USER."
#     exit 1
# else
echo "* installing $REPO_NAME under \"$WEB_USER_HOME\"..."
# fi
UPDATE=false
if [ ! -d "$REPO_PATH" ]; then
    if [ -z "$INSTALL_SRC" ]; then
        echo "* installing $URL to $REPO_PATH..."
        git clone $REPO_URL "$REPO_PATH"
    else
        echo "* installing $INSTALL_SRC to $REPO_PATH..."
        rsync -rt $INSTALL_SRC/ "$REPO_PATH"
        # ^ ALSO happens below if UPDATE!
    fi
    if [ $? -ne 0 ]; then
        echo "  * 'git clone $REPO_URL \"$REPO_PATH\"' failed."
        exit 1
    else
        echo "  * OK"
    fi
else
    echo "* using existing $REPO_PATH"
    UPDATE=true
fi


printf "'cd $REPO_PATH'..."
cd $REPO_PATH
code=$?
if [ $code -eq 0 ]; then
    echo "OK"
else
    echo "FAILED"
    exit $code
fi
# NOTE: Do not set PYTHON_MAJOR_VERSION directly. Instead, set SYS_PYTHON (the RC file above will set PYTHON_MAJOR_VERSION).
#if [ "$PYTHON_MAJOR_VERSION" = "2" ]; then
    #echo "* WARNING: Switching to develop-python2 branch since PYTHON_MAJOR_VERSION=2"

    ## git switch master-python2
    ## ^ doesn't work on older versions of git
    ##   So see
    ##   <https://www.freecodecamp.org/news/git-checkout-remote-branch-tutorial/>:

    #git fetch origin

    ## git checkout -b develop-python2 origin/develop-python2
    ## ^ fails to run: See
    ##   [develop-python2 branch fails to run
    ##   #6](https://github.com/poikilos/samurai-ide-web/issues/6)

    #git checkout -b master-python2 origin/master-python2

#fi
if [ "@$UPDATE" = "@true" ]; then
    if [ -z "$INSTALL_SRC" ]; then
        git pull --verbose
    else
        echo "* updating $REPO_PATH from $INSTALL_SRC DESTRUCTIVELY..."
        rsync -rt --delete $INSTALL_SRC/ "$REPO_PATH"
        # ^ ALSO happens further up if not UPDATE!
        code=$?
        if [ $code -ne 0 ]; then echo "FAILED"; exit $code; else echo "OK"; fi
        #if [ $code -ne 0 ]; then
        #    echo "  FAILED"
        #    exit $code
        #else
        #    echo "  OK"
        #fi
    fi
fi

if [ -f "$REPO_PATH/yarn.lock" ]; then
    printf "* removing misplaced \"$REPO_PATH/yarn.lock\"..."
    rm "$REPO_PATH/yarn.lock"
    if [ $? -ne 0 ]; then echo "FAILED"; exit 1; else echo "OK"; fi
fi
if [ -f "$REPO_PATH/package.json" ]; then
    printf "* removing misplaced \"$REPO_PATH/package.json\"..."
    rm "$REPO_PATH/package.json"
    if [ $? -ne 0 ]; then echo "FAILED"; exit 1; else echo "OK"; fi
fi
if [ -d "$REPO_PATH/node_modules" ]; then
    printf "* removing misplaced \"$REPO_PATH/node_modules\"..."
    rm -rf "$REPO_PATH/node_modules"
    if [ $? -ne 0 ]; then echo "FAILED"; exit 1; else echo "OK"; fi
fi
# ^ prevent forcing the node_modules dir to prevent the error:
#      File "/home/owner/samurai-ide-web/mezzaninja/settings/base.py", line 407, in run_checkers
#        "".format(LESS_EXECUTABLE))
#    settings.base.ImproperlyConfigured: Less binary does not exist or is not executable: node_modules/less/bin/lessc"
YARN_LEFTOVERS="`find $REPO_PATH -name '.yarn*'`"
YARN_LEFTOVERS="$YARN_LEFTOVERS `find $REPO_PATH -name 'node_modules'`"
YARN_LEFTOVERS="$YARN_LEFTOVERS `find $REPO_PATH -name 'package.json'`"
YARN_LEFTOVERS="$YARN_LEFTOVERS `find $REPO_PATH -name 'yarn.lock'`"
YARN_LEFTOVERS=`echo $YARN_LEFTOVERS | xargs`
# ^ trim whitespace
if [ ! -z "$YARN_LEFTOVERS" ]; then
    echo "Error: no yarn leftovers should appear in \"$REPO_PATH\" but it contains: $YARN_LEFTOVERS"
    exit 1
fi

# mkvirtualenv samuraiweb
# ^ from ninja-ide-web readme, but not great

# touch $WEB_USER_HOME/.bashrc
# chown $WWW_USER:$WWW_USER $WEB_USER_HOME/.bashrc
# Based on <https://www.geeksforgeeks.org/using-mkvirtualenv-to-create-new-virtual-environment-python/>:
# echo "export WORKON_HOME=$WEB_USER_HOME/.virtualenvs" >> $WEB_USER_HOME/.bashrc
# echo "export PROJECT_HOME=$WEB_USER_HOME/Devel" >> $WEB_USER_HOME/.bashrc
# echo "source /usr/local/bin/virtualenvwrapper.sh" >> $WEB_USER_HOME/.bashrc
# ^ That is not great either, so do it a better way:
echo "This file was generated by the $me install script at \"$myPath\". The filename is a note to the administrator." | tee "$WEB_USER_HOME/This directory contains the .virtualenvs hidden directory"
printf "* 'mkdir -p \"$VENVS_DIR\"'..."
mkdir -p "$VENVS_DIR"
code=$?
if [ $code -eq 0 ]; then
    echo "OK"
else
    echo "FAILED"
    exit $code
fi

if [ ! -d "$VENV_DIR" ]; then

    if [ "$PYTHON_MAJOR_VERSION" = "2" ]; then
        virtualenv -h >& /dev/null
        code=$?
        if [ $code -ne 0 ]; then
            echo "Error: '$SYS_PYTHON -m venv h' failed. Try installing the $SYS_PYTHON-venv package first, such as via:"
            echo "  apt-get install python-virtualenv  #or possibly python2-virtualenv"
            exit $code
        fi
        # printf "* generating \"$VENV_DIR\"..."
        echo
        echo "* 'virtualenv --python=$SYS_PYTHON_PATH $VENV_DIR'..."
        virtualenv --python=$SYS_PYTHON_PATH $VENV_DIR
        code=$?
    else
        $SYS_PYTHON -m venv -h >& /dev/null
        code=$?
        if [ $code -ne 0 ]; then
            echo "Error: '$SYS_PYTHON -m venv h' failed. Try installing the $SYS_PYTHON-venv package first, such as via:"
            echo "  apt-get install $SYS_PYTHON-venv"
            exit $code
        fi
        # printf "* generating \"$VENV_DIR\"..."
        echo
        echo "* '$SYS_PYTHON -m venv $VENV_DIR'..."
        $SYS_PYTHON -m venv $VENV_DIR
        code=$?
    fi

    if [ $code -eq 0 ]; then
        # echo "OK"
        echo "* generated venv \"$VENV_DIR\""
    else
        # echo "FAILED"
        cat <<END
Error: venv is present for $WWW_USER, but creating a venv failed. If
the previous error starts with
"The virtual environment was not created successfully because ensurepip is not
available. . . ." then you maybe the python module is installed but not
the system package and dependencies. Try installing the $SYS_PYTHON-venv
system package such as via:

    sudo apt-get install -y $SYS_PYTHON-venv

as per <https://askubuntu.com/questions/879437/ensurepip-is-disabled-in-debian-ubuntu-for-the-system-python>
Then delete the failed venv:

    rm -rf $VENV_DIR

then try running install again.


END
        exit $code
    fi
else
    echo "* using \"$VENV_DIR\" as venv (virtual environment)"
fi

. $VENV_DIR/bin/activate
code=$?
if [ $code -ne 0 ]; then
    echo "Error: '. $VENV_DIR/bin/activate' failed."
    exit $code
fi

echo "* python in path in environment: `which python`"
echo "  * Python `python --version`"
echo "* python detected in environment: $VENV_PYTHON"
echo "  * Python `$VENV_PYTHON --version`"

echo "* upgrading pip and wheel"
$VENV_PYTHON -m pip install --upgrade pip wheel

printf "* generating \"$VENV_DIR/.project\"..."
pwd | tee $VENV_DIR/.project
code=$?
if [ $code -ne 0 ]; then echo "FAILED"; exit $code; else echo "OK"; fi
echo "  * contents: `cat $VENV_DIR/.project`"
printf "* installing requirements..."
$VENV_PYTHON -m pip install -r requirements/dev.txt
code=$?
if [ $code -ne 0 ]; then echo "FAILED"; exit $code; else echo "OK"; fi
$VENV_PYTHON -m pip install nose
printf "* 'cd mezzaninja' (from `pwd`)..."
cd mezzaninja
code=$?
if [ $code -ne 0 ]; then echo "FAILED"; exit $code; else echo "OK"; fi
# add2virtualenv .
# ^ requires virtualenvwrappr. Instead, do:
SITE_PACKAGES=`$VENV_PYTHON -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"`
echo
if [ "$PYTHON_MAJOR_VERSION" = "2" ]; then
    # echo "* You must export "
    echo "* generating $SITE_PACKAGES/mezzaninja.pth..."
    pwd | tee $SITE_PACKAGES/mezzaninja.pth
else
    echo "* generating $SITE_PACKAGES/mezzaninja.pth..."
    pwd | tee $SITE_PACKAGES/mezzaninja.pth
    # ^ The directory in the pth file gets appended to PYTHON_PATH automatically.
    # ^ doesn't seem to work in python2
fi

if [ "$PYTHON_MAJOR_VERSION" = "2" ]; then
    # pip install django_compressor==2.4
    echo "* running 'pip install django-appconf==1.0.2' for Python 2..."
    pip install django-appconf==1.0.2
    # ^ for python2 as per <https://stackoverflow.com/a/60984631/4541104>
fi
# ^ Avoid "ImportError: No module named django.core.management" on manage.py below.

tmpInst="$WEB_USER_HOME/install-more.tmp"
if [ -f "$tmpInst" ]; then
    rm $tmpInst
    # ^ only for root version of install script, so remove it
fi

export DJANGO_SETTINGS_MODULE="mezzaninja.settings"
# ln -s settings/dev.py settings/active.py  # FAILS due to relative path
echo "* installing `realpath settings/dev.py` as `pwd`/settings/active.py..."
rm settings/active.py
ln -s `realpath settings/dev.py` settings/active.py
echo "* installing less in \"`pwd`\"..."
# if [ ! -f "`command -v less`" ]; then
# ^ NOT RELIABLE (less has a different meaning on linux)!
    $NPM_INSTALL less
    # ^ $NPM_INSTALL may be "npm install", "yarn add", etc
#fi
code=$?
if [ $code -ne 0 ]; then exit $code; fi
LESS_BIN_DIR=node_modules/less/bin
if [ -d "$LESS_BIN_DIR" ]; then
    LESS_BIN_DIR=`realpath $LESS_BIN_DIR`
    echo "* adding directory $LESS_BIN_DIR to path..."
elif [ -d "../$LESS_BIN_DIR" ]; then
    LESS_BIN_DIR=`realpath ../$LESS_BIN_DIR`
    echo "* adding directory $LESS_BIN_DIR to path (from `pwd`/..)..."
else
    echo "Error: '$NPM_INSTALL less' did not result in a \"`pwd`/node_modules/less/bin\" nor ../$LESS_BIN_DIR directory."
    exit 1
fi
MANAGE_PY=./manage.py
TRY_MANAGE_PY="../website/ninja_web/manage.py"
#if [ -f "$TRY_MANAGE_PY" ]; then
#    echo "* using \"$TRY_MANAGE_PY\"..."
#    MANAGE_PY="$TRY_MANAGE_PY"
#else
#    echo "* missing \"$TRY_MANAGE_PY\".."
#    exit 1
#fi
MANAGE_PY_PATH=`realpath $MANAGE_PY`
export PATH="$PATH:$LESS_BIN_DIR"
echo "* migrating database..."
$VENV_PYTHON $MANAGE_PY syncdb  # --migrate
code=$?
if [ $code -ne 0 ]; then echo "FAILED"; exit $code; else echo "OK"; fi

echo "* Running '$VENV_PYTHON $MANAGE_PY runserver' in `pwd`..."
$VENV_PYTHON $MANAGE_PY runserver
code=$?
if [ $code -ne 0 ]; then echo "FAILED"; exit $code; else echo "OK"; fi
echo
# Create the service file
# - based on parsoid.service
# - For WorkingDirectory and Environment, see <http://0pointer.de/public/systemd-man/systemd.exec.html#Environment=>.
# - See also [Simple systemd unit for running a django app](https://gist.github.com/toast38coza/734c89775be9ddd69351)
echo "* generating \"$serverService\"..."
# ^ serverService should already be a full path.
cat > "$serverService" <<END
[Unit]
Description=$Description
Documentation=$Documentation
Wants=local-fs.target network.target
After=local-fs.target network.target

[Install]
WantedBy=multi-user.target

[Service]
Environment="DJANGO_SETTINGS_MODULE=mezzaninja.settings"
Type=simple
User=$WWW_USER
Group=$WEB_USER_GROUP
WorkingDirectory=$REPO_PATH/mezzninja
ExecStart=$VENV_PYTHON $MANAGE_PY runserver
KillMode=process
Restart=on-failure
PrivateTmp=true
StandardOutput=syslog

END


# To see any files that should be in .gitignore at this point if only above was done:
#   # git status  # or for every file:
#   git ls-files -m -o -d

cat <<END

* Next you should do the following as root:
  cp $serverService /etc/systemd/system/
  systemctl enable $SERVICE_NAME
  # If it doesn't work, try changing $MANAGE_PY to $MANAGE_PY_PATH
END
