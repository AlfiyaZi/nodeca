## Application Structure

```
.
├─ models/
│   └─ *.js
├─ stores/
│   └─ *.js
├─ views/<controller_name>/           # sub-dir per controller
│   ├─ _*.jade                        # partials.js
│   └─ *.jade
├─ config/
│   ├─ settings/
│   │   └─ *.yml                      # settings definitions
│   ├─ locales/
│   │   └─ <lang>.yml                 # language translataions e.g. ru.yml
│   └─ defaults.yml                   # application config
├─ client/<namespace>/.../*.js        # client-only parts of API tree
├─ server/<namespace>/.../*.js        # server-only parts of API tree (controllers)
├─ shared/<namespace>/.../*.js        # server and client parts of API tree
├─ filters/<namespace>/.../*.js       # server api tree filters (validators, etc)
├─ helpers/<namespace>/.../*.js       # api tree helpers
├─ public/
│   └─ <namespace>/*                  # static files + stylus templates
└─ index.js
```

#### Server API tree filters (filters/{namespace}/\*.js)

``` javascript
// file: filters/forums/posts.js

var filters = module.exports = {create: {}};

filters.create.before = [
  function validateRequest(next) {
     var env = this;
     // validate request and if valid, next(). Otherwise
     next(new Error('Invalid params'));
  }
];

filters.create.after = [
  function mangleResultData(next) {
    // we can modify some data after nodeca.server.forums.create() finished
    // it's work...
    next();
  }
];
```

## Assets-Manager Post-Work Files structure

```
.
└─ assets/
    ├─ <namespace>/
    │   ├─ client.js        # development: nodeca.client.<namespace>
    │   ├─ server.js        # development: nodeca.server.<namespace>
    │   ├─ shared.js        # development: nodeca.shared.<namespace>
    │   ├─ i18n.js          # development: nodeca.i18n.<namespace>
    │   ├─ templates.js     # development: nodeca.templates.<namespace>
    │   ├─ bundle.js        # production: contains all above
    │   └─ public/          # assets from public/ static files copied as is
    │       ├─ *.*          # development: CSS, JS, images, any files
    │       ├─ bundle.js    # production: compiled/concatenated js files
    │       └─ bundle.css   # production: compiled/concatenated css files
    └─ manifest.json
```


## Client to Server communication protocol

Structure of RPC is presented in YAML for readability purposes only

#### Request

- **version**   _(String)_ Mandatory. version nodeca protocol, Example: "1.0"
- **action**    _(String)_ Mandatory. API tree action to call
- **args**      _(Array)_ Optional. Method 
``` yaml
--- # structure
version : <str>     # 
action  : <str>     # 
params  : <map>     # Parameters of request
format  : <str>     # (optional) Desired format of response
...
--- # example
version: "1.0"
action: "forums.posts.save"
params:
  title: "C'mon let's release something"
  body: >
    Some really big body...
format: "json"
...
```

#### Response

``` yaml
--- # structure
version : <str>     # version of nodeca protocol
code    : <int>     # result code
data    : <mixed>   # (optional) response data
...
--- # example
version: "1.0"
code: 0
...
```

Response codes are fixed and can be:

    0   OK
    400 CLIENT ERROR
    401 VERSION MISMATCH
    500 SERVER ERROR


## Client Config

This
```
{
  "i18n": // i18n | tpl
  {
    "<namespace>":
    {
      "url": "/foobar/aha.cbmd5sum.js",
      "md5": "cbmd5sum"
    }
  }
}
```

## Server-side view helpers

- `assetUrl(name)`
- `javascripts([namespace = 'all'])`
- `stylesheets([namespace = 'all'])`
