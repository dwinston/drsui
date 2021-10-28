DrsUI is intended to be a browser UI for a [data repository service (DRS)](https://ga4gh.github.io/data-repository-service-schemas/preview/release/drs-1.0.0/docs/).

In particular, it aims to facilitate creation of DrsObject resources as desired by the [National Microbiome Data Collaborative](https://microbiomedata.org/) (NMDC) [Runtime API](https://github.com/microbiomedata/nmdc-runtime/) ([interactive OpenAPI docs](https://api.dev.microbiomedata.org/docs#/objects)), as the upsteam DRS API specification only describes read-only endpoints.

## development

### tooling

Development is currently being done in VSCode using the [Elm tooling](https://marketplace.visualstudio.com/items?itemName=Elmtooling.elm-ls-vscode) plugin.

### setup

Install [modd](https://github.com/cortesi/modd) and [devd](https://github.com/cortesi/devd).

```bash
npm install
modd
```

This will open a dev server on port 9000 and assume you have an API server running on port 8000.
