# First Time Repo Setup
You never have to run this again because all of the relevant data from
these operations gets pushed to the repo (or possibly generated).

This is only for reference in regards to the origin of the files in the
project as a historical reference.

In the install command below, less wasn't initially necessary because of
the rewrite (though it may be needed on the server eventually).
Therefore, the vm gets installed anyway.

Below, the command `mezzanine-project samurai` creates a
project folder, samurai. The samurai folder is
equivalent to mezzninja, probably, but we are using a MUCH newer
version of mezzanine (and mezzanine 5's install process is changed to
be like a django site, whatever that means, according to some post
somewhere).

```
./install.sh
# ^ Ignore errors, but only on the dev machine, not on the server.
. "$HOME/.virtualenvs/samurai-ide-web/bin/activate"
if [ $? -ne 0 ]; then echo "Error: '. \"$HOME/.virtualenvs/samurai-ide-web/bin/activate\"' failed. Re-run install.sh first."; exit 1; fi
cd "$HOME/tmp"
if [ -d "$HOME/tmp/samurai" ]; then
    rm -rf "$HOME/tmp/samurai"
fi

# See <https://mezzanine.readthedocs.io/en/latest/overview.html#installation>
# pip install mezzanine
# ^ Version 5.1.3 errors out when trying to save an edited page.
mkdir -p ~/Downloads/git/stephenmcd
git clone https://github.com/stephenmcd/mezzanine ~/Downloads/git/stephenmcd/mezzanine
cd ~/Downloads/git/stephenmcd/mezzanine
python setup.py install
cd "$HOME/tmp"
mezzanine-project samurai
cd samurai
python manage.py createdb --noinput
python manage.py runserver
```

All of the edits made to the database and gallery do not affect the repo.
- See Poikilos' ~/Nextcloud/www
- See Poikilos' dev laptop ~/git/samurai-ide-web for ignored files:
  - samurai/local_settings.py
  - media
  - the db file
- Adjust ALLOWED_HOSTS in samurai/local_settings.py to match your server's domain (not IP address usually, unless you want to allow that).
