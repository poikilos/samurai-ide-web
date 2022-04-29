# Documentation
This documentation is for website administrators.

## Website Administration

### Galleries and Images
A gallery is not an automatic list--it is a curated list. Even though there is a media library folder called gallery, that is only for organizing pictures administratively. All of the following points still apply regardless of the folder name:
- Delete an image from the specific page as desired, including a "Gallery" type page. The removed image(s) will still be in the system though, unless deleted from the media library.
- If you delete an image from the media library, any pages that still use the image, including a gallery, may have placeholder images ("A gallery is not an automatic list"). The thumbnail file will remain in "media/uploads/$gallery_name/.thumbnails" where $gallery_name is the name of the gallery.

### Home
The "Home" page is a special page not edited using the admin interface.

The default content of Home is (after converted to markdown for the purposes of this document):

> Welcome to your new Mezzanine powered website. Here are some quick links to get you started:
> - [Log in to the admin interface](http://127.0.0.1:8000/admin/)
> - [Creating custom page types](http://mezzanine.jupo.org/docs/content-architecture.html)
> - [Modifying HTML templates](http://mezzanine.jupo.org/docs/frequently-asked-questions.html#templates)
> - [Changing this homepage](http://mezzanine.jupo.org/docs/frequently-asked-questions.html#why-isn-t-the-homepage-a-page-object-i-can-edit-via-the-admin)
> - [Other frequently asked questions](http://mezzanine.jupo.org/docs/frequently-asked-questions.html)
> - [Full list of settings](http://mezzanine.jupo.org/docs/configuration.html#default-settings)
> - [Deploying to a production server](http://mezzanine.jupo.org/docs/deployment.html)

To change it you must get the templates

## Install
Create and switch to a new user:
```
sudo useradd -m -d /var/www/samurai samurai
sudo passwd samurai
# Enter a strong password.
sudo -u samurai bash
cd
```

You must have Python 2.8 to use the latest DJANGO since that uses the `:=` operator.

You can install it as python3.8 using the `altinstall` as desribed below:

Based on <https://stackoverflow.com/a/62831268> which says the steps are from <https://linuxize.com/post/how-to-install-python-3-8-on-debian-10/>:

```
sudo apt update
sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev liblzma-dev
curl -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz
tar -xf Python-3.8.2.tar.xz
cd Python-3.8.2
./configure --enable-optimizations --enable-loadable-sqlite-extensions \
    --enable-shared
# ^ one commenter says to add --enable-shared (builds libpython)
make -j `nproc`
sudo make altinstall
sudo ldconfig
# ^ ldconfig prevents an error related to --enable-shared: "python3.8: error while loading shared libraries: libpython3.8.so.1.0: cannot open shared object file: No such file or directory"

```

Install by cloning the repo then running setup.py:
```
git clone https://github.com/samurai-ide/samurai-ide-web.git /var/www/samurai/samurai-ide-web
cd /var/www/samurai/samurai-ide-web
python3 setup.py install
./install.sh
# ^ Ignore node.js errors unless "LESS" is implemented or node becomes necessary for other reasons.
```


### Move to another server
(or, copy settings and data from a dev machine to a server)
- Do all install steps then copy the following to the server (since none of these files should be committed to the repo):
  - samurai/local_settings.py
  - media/
  - the db file
- Adjust samurai/local_settings.py:
  - Set ALLOWED_HOSTS to match your server's domain (not IP address usually, unless you want to allow that).
  - ensure `DEBUG = false`.
- Change the port by adding a port number to the end of the generated service file's Exec line (after `runserver`)

### Collect templates
(Use this section only if starting from scratch rather than moving to another server;
However, you can run the `collectstatic` subcommand after any update of mezzanine)

Install the static data and templates:
```
WWW_USER=samurai
sudo -u $WWW_USER bash -
VENV_DIR=$HOME/.virtualenvs/samurai-ide-web
WWW_APP_DIR=$HOME/samurai-ide-web
# rsync -rt $VENV_DIR/lib/python3.8/site-packages/Django-4.0.4-py3.8.egg/django/contrib/admin/static $WWW_APP_DIR
# rsync -rt $VENV_DIR/lib/python3.8/site-packages/Mezzanine-9999.dev0-py3.8.egg/mezzanine/core/static $WWW_APP_DIR
# rsync -rt $VENV_DIR/lib/python3.8/site-packages/grappelli_safe-1.1.1-py3.8.egg/grappelli_safe/static $WWW_APP_DIR
# and many more:
# find /var/www/samurai/.virtualenvs/samurai-ide-web/lib -name "static" -exec rsync -rtv "{}" $WWW_APP_DIR \;
# so as per <https://stackoverflow.com/questions/48613720/mezzanine-static-files-not-serving-from-static-root>:
cd $WWW_APP_DIR
. $VENV_DIR/bin/activate
# As per the usual DJANGO way of doing things which mezzanine people usually assume you already knew
# (according to <https://stackoverflow.com/a/48614890>):
python manage.py collectstatic
python manage.py collecttemplates

# Then download the templates to your favorite folder so you can edit and later re-upload them:
rsync -rtv samurai-ide.org:/var/www/samurai/samurai-ide-web/templates ~/Nextcloud/www/samurai-more
```

- Then edit the collected templates (instead of the ones in the site packages) to override templates.
  - Do not edit static, because they will be overwritten each time `collectstatic` is called.

Some of this information may be derived from:
- [How to use Mezzanine on PythonAnywhere](https://help.pythonanywhere.com/pages/HowtouseMezzanineonPythonAnywhere/#configuring-static-files)
  (some of the steps are not specific to PythonAnywhere)


### Configure
Make sure you only change settings in local_settings.py, not settings.py. Even so, the env line for uwsgi.ini is:
`env = DJANGO_SETTINGS_MODULE=samurai.settings`.

Set up a valid /var/www/samurai/uwsgi.ini such as:
```
[uwsgi]
; from <https://stackoverflow.com/a/60377761>:
uid = samurai
guid = samurai

; from <https://stackoverflow.com/a/70718198>:
base = /var/www/samurai/samurai-ide-web
project = samurai-ide-web
socket = /run/samurai/samurai-ide-web.sock
; virtualenv = /var/www/.virtualenvs/samurai-ide-web
; ^ --venv or --virtualenv is same as -H.

; from <https://stackoverflow.com/a/54010292>:
pythonpath = /var/www/samurai/.virtualenvs/samurai-ide-web/lib/python3.8/site-packages

chdir = /var/www/samurai/samurai-ide-web
wsgi-file = /var/www/samurai/samurai-ide-web/samurai/wsgi.py
; pythonpath = /var/www/samurai/samurai-ide-web
env = DJANGO_SETTINGS_MODULE=samurai.settings
; Pure uwsgi parameters, nothing mezzanine or even wsgi related down there
master = true
chmod-socket = 666
worker = 1
processes = 1
enable-threads = true
```

#### SSL
Note that, before requesting certificates requiring an ACME challenge such as free ones from letsencrypt:
- You must comment the certificates from /etc/nginx/sites-enabled/samurai-ide.org.conf (or /etc/nginx/conf.d/samurai-ide.org.conf or any other path if you have a custom configuration).
  - NGINX will not load at all if there are missing files that are explicitly included.
- You must ensure that the non-SSL site loads properly, since the ACME challenge requires serving a temporary file for verification purposes.

Install go-acme [lego](https://github.com/go-acme/lego) to help automate the cert renewal process.

After installing go-acme lego, request certs such as via (only run this command after making the changes listed below it):
```
lego --http --http.webroot /var/www/tmp --pem --path /var/letse/USERNAME -m x@example.com -a -d contoso.com renew --days 14
```
- where USERNAME is any name you want, but is a nickname related to your (the domain owner's) letsencrypt account (it doesn't matter much, except that it will store cert files for all domains so separating the certs by your letsencrypt account could prevent confusion later)
- where x@example.com is your valid e-mail address that you use to identify your account on letsencrypt
- where contoso.com is your valid domain being served insecurely by NGINX so that you can pass the ACME challenge

After the lego command succeeds, uncomment all of the ssl lines in the samurai-ide.org.conf file for NGINX.

Reload NGINX and check the status:
```
sudo systemctl reload nginx
sudo systemctl status nginx
```

If the status command shows an error, see more details such as via:
```
sudo journalctl -xe -u nginx
```
- If you can't see the entire error message, scroll right using the right arrow key.
- press 'q' to quit.
- Correct the error(s) and keep repeating these steps starting from "Reload NGINX and check the status" until there are no errors.


## Run

For development you can run:
`~/.virtualenvs/samurai-ide-web/bin/python manage.py runserver`

For production use, run using the uwsgi command such as:
```
ExecStart=/var/www/samurai/.virtualenvs/samurai-ide-web/bin/uwsgi --ini /var/www/samurai/uwsgi.ini --wsgi-file /var/www/samurai/samurai-ide-web/samurai/wsgi.py --pidfile=/run/samurai/samurai-ide-web.pid
ExecReload=/var/www/samurai/.virtualenvs/samurai-ide-web/bin/uwsgi --reload --pidfile=/run/samurai/samurai-ide-web.pid
ExecStop=/var/www/samurai/.virtualenvs/samurai-ide-web/bin/uwsgi --stop --pidfile=/run/samurai/samurai-ide-web.pid
```

or test the full server such as via:
```
sudo mkdir /run/$USER
sudo chown -R $USER:`id $USER -G -n` /run/$USER
$HOME/.virtualenvs/samurai-ide-web/bin/uwsgi --ini $HOME/uwsgi.ini --wsgi-file $HOME/samurai-ide-web/samurai/wsgi.py --pidfile=/run/$USER/samurai-ide-web.pid
```
Create a service as described in the install.sh file. You can also read
install.sh and see how it is generated to generate your own.
- WorkingDirectory must be set to the repo path.

### uwsgi
The uwsgi tool runs the Python web service using a socket so that NGINX can use it.

If you are in a venv already, specifying a "venv" in wsgi.ini (or using the equivalent -H or --virtualenv or --venv option) will cause it to fail with:
"ModuleNotFoundError: No module named 'encodings'"
- To solve this, remove the venv or virtualenv option from wsgi.ini

### Test URLs
http://samurai-ide.org/media/uploads/gallery/Long%20Beach,%20USA.jpg
http://samurai-ide.org/static/css/bootstrap-theme.css
