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

## Install
Install by cloning the repo then running:
```
python3 setup.py install
./install.sh
# ^ Ignore node.js errors unless "LESS" is implemented or node becomes necessary for other reasons.
```

You must have Python 2.8 to use the latest DJANGO since that uses the `:=` operator.

You can install it as python3.8 using the `altinstall` as desribed below:

```
sudo apt update
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev liblzma-dev
curl -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz
tar -xf Python-3.8.2.tar.xz
cd Python-3.8.2
./configure --enable-optimizations --enable-loadable-sqlite-extensions \
    --enable-shared
# ^ one commenter says to add --enable-shared (builds libpython)
make -j `nproc`
sudo make altinstall


```
-from <https://stackoverflow.com/a/62831268> which says the steps are from <https://linuxize.com/post/how-to-install-python-3-8-on-debian-10/>.

### Move to another server
- Do all install steps then copy the following to the server:
  - samurai/local_settings.py
  - media/
  - the db file
- Adjust samurai/local_settings.py:
  - Set ALLOWED_HOSTS to match your server's domain (not IP address usually, unless you want to allow that).
  - ensure `DEBUG = false`.
- Change the port by adding a port number to the end of the generated service file's Exec line (after `runserver`)


### Run
Create a service as described in the install.sh file. You can also read
install.sh and see how it is generated to generate your own. Ensure
that it runs: `python manage.py runserver` and that the
WorkingDirectory is set to the repo path.

