# samurai-ide-web
<https://github.com/poikilos/samurai-ide-web>

This branch is a mezzanine 5 website made from scratch by Jake "Poikilos" Gustafson for [sumurai-ide.org](https://sumurai-ide.org).

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
