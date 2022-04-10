# samurai-ide-web v3.0

## Project status
The mezzanine5 branch will start from scratch but try to mimic the original using a new version of DJANGO and mezzanine (See "Old Branches" for details). Mimicking the old branches should help port the features from them to the mezzanine5 branch. If porting the updated DJANGO and mezzanine templates back to the old branches becomes a more viable solution, the default branch will be set back to one of them (See <https://github.com/poikilos/samurai-ide-web> to see which branch is default and use that one).

### Old Branches
Old branches (all branches other than mezzanine5) have been ported to Python 3 but they don't work due to changes in dependencies.
Even using older versions of the primary dependencies, branches based on the original ninja-ide-web branches seem to be a lost cause since:
- Many recent versions of the secondary dependencies (the automatically-calculated dependencies not listed in the requirements/* files) are incompatible with DJANGO or mezzanine. The requirements/* files only list versions for the primary dependencies, not the secondary dependencies. One would think that the primary dependencies would pull the correct versions of secondary dependencies, but they don't (apparently, as there are errors deep within the dependency tree).
  - If trying to use Python 2 to solve the issue, newer versions of secondary dependencies appearing (the most probable cause) means they are not compatible with Python 2. Furthermore, installing pip at all is difficult (pip for python2 isn't even in Devuan Chimera repositories [Chimera is based on Debian 10 Buster]).
- The project does not translate well to newer versions of DJANGO and mezzanine (It differs too much from the templates in newer versions of them).


## Website for Samurai-IDE
The 3rd version of the website is developed alongside Samurai-IDE 3.

### User-submitted content

Any help is welcome for creating new issues and taking care of free issues. You'll understand that we cannot let you add a dancing Jesus or a Mr X photo to our awesome samurai site for the simple reason that **we** are the ones that want to add that kind of staff to the site.

If you really really REALLY want to help us, just get to our site (https://samurai-ide.org) and donate what your heart says.

### Get your own copy of the site (for development or learning):
(The site still has several parts named "ninja" but the images have been changed to samurai.)

    # clone the thing
    git clone git@github.com:poikilos/samurai-ide-web.git

    # create a virtualenv for it
    cd samurai-ide-web
    mkvirtualenv samuraiweb
    pwd >> $WORKON_HOME/samuraiweb/.project

    # install all requirements
    sudo apt-get install gcc libpq-dev -y
    sudo apt-get install python-dev  python-pip -y
    sudo apt-get install python3-dev python3-pip python3-venv python3-wheel -y
    # ^ See <https://stackoverflow.com/a/59596814/4541104> (avoid
    #   error: "The virtual environment was not created successfully because ensurepip is not
    #   available")
    pip install -r requirements/dev.txt
    # pip install nose
    # ^ For tests, you must have nose in the venv not use the system's
    #   nose (which can't access the django in the venv).

    # prepare it
    cd mezzaninja
    add2virtualenv .
    export DJANGO_SETTINGS_MODULE="mezzaninja.settings"
    ln -s `realpath settings/dev.py` settings/active.py
    # cp settings/dev.py settings/active.py
    # ./manage.py syncdb --migrate
    # ^ fails (no such option --migrate) though was in ninja-ide-web documentation
    ./manage.py syncdb
    ./manage.py runserver

#### Note
Currently there are a lot of files & code deprecated that belongs to previous version of site. After completing the refactoring those files won't exist anymore.

### You want to tune up the CSS?

The Samurai-IDE website is being developed using LESS precompiler. If you want to style and don't get crazy in the process then you better learn it once for all and be happy the rest of your life.

It's simple:

1) get the latest version of less

    `npm install less`

2) add the path where Less was installed to your PATH env.

    `export PATH="$PATH:node_modules/less/bin"`

3) Done. Was simple or what?


### Run tests
Requires
- Do the "You want to tune up the CSS" steps above.
- Do the optional step to install nose in the install steps further up.

Use the one from the venv such as:
~/.virtualenvs/samurai-ide-web/bin/nosetests
