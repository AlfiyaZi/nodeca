API Tree
========

Most resources are mapped to API Tree structure `nodeca`. It can be different
on server and client. Also, some methods are specially converted to transparent
remote calls.

Full structure:

```
nodeca

  # main core :) . server & client

  client                  # client methods
  server                  # server methods (on client - async mappers)
  shared                  # available on both client & server,
                          # mostly for helpers

  # server only

  model                   # server models (universal, implementation independent
  hooks                   # hooks for app init phases & models init
    init                  # init hooks
    models                # models hooks
  permissions             # access rules
  filters                 # hooks for server modules (mostly to attach access rules)
  settings                # settings accessor (get/set, not tree)
  config                  # parsed config file.
  logger                  # logger instance

  # server & client, dynamic data

  runtime                 # `dynamic` structures
    version               # "1.0.0"
    bundle                # info about namespaces from static builder
    router                # router instance, filled with routes from config

    # server-specific

    main_app              # main application (the one that started the process)
    apps                  # array of { name, absolute_path } for each loaded app 
    views                 # compiled views
    mongoose              # mongoose instanse (it's not part of nlib, depends on application)
    redis                 # redis instanse (also depends on application)
    assets                # assets-related data
      environment         # Mincer.Environmant instanse
      manifest            # Mincer manifest of assets
    i18n                  # translator (BabelFish) instance

    # client-specific

    debug                 #
    user_id               #
    theme_id              #
    language              #
```


bundle
------

Collection of CRCs for loadable resources.  It helps to properly cache
static data in local store, and refresh those on server upgrade.

``` javascript
{
  phrases: {
    forum:    "crc1"
    blogs:    "crc2"
    groups:   "crc3"
    admin:    "crc4"
  }
  templates: {
    forum:    "crc5"
    blogs:    "crc6"
    groups:   "crc7"
    admin:    "crc8"
  }
}
```


config
------

```
  applications
  i18n
  theme_schemas
  setting_schemas
  router
    map
    direct_invocators
    redirects
    mount
  settings
  locales
  themes_whitelist
  themes_blacklist
  database
  listen
```


Cookies
=======

Some information should be kept secure. It's placed to http-only/ssl-only
cookies. Default prefix is `bb_`.

```
  bb_cid            # unique identifier to track settings for guests,
                    # without login

  bb_uid            # [http-only, ssl-only] member id
  bb_pass           # [http-only, ssl-only] hash of `remembered` password
  bb_session        # [http-only] session id (uuid-like)

  bb_theme          # (?) current theme
```

Local Store
===========

Local store is used to cache templates & languages - that minimize page load
time. Key name format:

```
  <namespace>_phrases       # serialised phrases resource
  <namespace>_phrases_crc   # phrase resource crc
  <namespace>_templates     # serialized templates resource
  <namespace>_templates_crc # templates resource crc
```

(?) preferables storage type is LocalStorage. But you ca use other one. See
details here http://stackoverflow.com/questions/1194784/which-browsers-support-html5-offline-storage .
