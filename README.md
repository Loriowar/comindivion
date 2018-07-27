# Comindivion

In old times people kept in mind whole books, tales and stories. Nowaday most of us keep in mind tons of references to the multiple objects (events, places, books etc). So, main aim of this application - to extend our reference memory and provide a simple interface for filling, visualization and searching.

* [Inspiration](#inspiration)
* [Variants of data organization](#variants-of-data-organization)
* [Usage](#usage)
* [Current functions](#current-functions)
* [Future functions](#future-functions)
* [Install development environment](#install-development-environment)
* [Deploy](#deploy)
  * [Assembly of a package](#assembly-of-a-package)
  * [Testing of the assembled package](#testing-of-the-assembled-package)
  * [Deploy assembled package](#deploy-assembled-package)
  * [Systemd unit](#systemd-unit)
* [Integration with Let's Encrypt](#integration-with-lets-encrypt)
* [Integration with Google Analytics](#integration-with-google-analytics)

## Inspiration
Project inspired by [RDF (Resource Description Framework)](https://en.wikipedia.org/wiki/Resource_Description_Framework). Minimal amount of data in RDF is a [triple](https://en.wikipedia.org/wiki/Semantic_triple). Triple is a set of three entities that codifies a statement about semantic data in the form of subject–predicate–object expressions. For example, expression "Boris Chertok is author of "Rockets and People". Here "Boris Chertok" is a subject, "is author of" is a predicate and "Rockets and People" is an object.

## Variants of data organization
So, you can use different approaches to a data organization. If you prefer a standartized and science approach,then you can create complete vocabularies, [taxonomies](https://en.wikipedia.org/wiki/Taxonomy_(general)) and [ontologies](https://en.wikipedia.org/wiki/Ontology_(information_science)). Otherwise you can use a creative approach, i.e. directly migrate grapt from your imagination into the application. In this case you obtain some kind of visualization of objects with tags. Anyway, use this as a tool for extend and visualize your memory and mind.

## Usage
Usage of application is very simple. Needs to keep in mind a base structure of a data: subject-predicate-object. Moreover, needs to undarstand what in role of a subject or an object can be the same object. In described application this "same object" called MindObject. So, here is a simple algorithm of the application usage:
- firstly, create a list of the predicates;
- then, go to the interactive view;
- start a creation of nodes with custom positions and different relations;
- use a search over nodes title and content for recall any previously created object and for taking a look on its relations.

## Current functions
- One endless interactive mind map.
- Multiple selection and moving of nodes.
- Search over nodes.
- Grouping of nodes.
- Listing of similar nodes.
- Small tutorial in format of "How to...".

## Future functions
- Import data from a file to the application.
- Export all users data to the file.
- Async updating of the interactive view and an ability of a parallel edition of the graph network.
- API for an access to all user data.
- Sharing nodes and node groups between users.

And of course, feel free to offer any functions which can help yo achieve your personal aims.

## Install development environment
- install required version of Erlang to a local machine.
- Install `nodejs` and `npm`.
- Clone this repo.
- Go to directory with cloned project.
- Create a db-user for aplication in `psql` console:
  - `CREATE ROLE comindivion LOGIN PASSWORD 'password' SUPERUSER;`
- Configure DB and other parameters in `config/config.exs` and `config/dev.exs`.
- Run
  - `mix local.hex`;
  - `mix deps.get`;
  - `npm i`;
  - `mix ecto.create`;
  - `mix ecto.migrate`.
- Run the server and console: `iex -S mix phx.server`.
- Go to `localhost:4000` and check working of the application.

## Deploy
Assume what you have a local copy of the application and in the development mode anything works perfect.

### Assembly of a package
Go to root directory of the project and do follows things:
- get production dependencies: `mix deps.get --only prod`.
- Compile app on production environment: `MIX_ENV=prod mix compile`.
- Install all required js-packages: `npm i`.
- Prepare assets: `node node_modules/brunch/bin/brunch build -p`.
- Prepare static files: `MIX_ENV=prod mix phx.digest`.
- Build a tarball with a release: `MIX_ENV=prod mix release --verbose`.
- Read messages in console and if you see `==> Release successfully built!` go to the next step.

### Testing of the assembled package
- Fill all required env variables in `sys/env/list.template`. Variables must be actual for you local machine.
- Export previously filled env variables to you current env. Use `export`, `set` or anything else.
- Run `_build/prod/rel/comindivion/bin/comindivion console` and looks on messages in console.
- If no errors in console visit `localhost:4001` and check proper working of the built release.

### Deploy assembled package
Use [Edeliver](https://github.com/edeliver/edeliver) or do all actions manually:
- install required version of Erlang to a production server.
- Copy tarball from `_build/prod/rel/comindivion/releases/<VERSION>/comindivion.tar.gz` to a target host.
- Move the tarball to final location.
- Extract it by `tar -xzf comindivion.tar.gz`.
- Assign proper right on directory using `chmod`.
- Prepare analog of `sys/env/list.template` with all required data for production.
- Run application server by any preferable way (foreground, daemon, systemd etc), but don't foreget about usage of the env variables from the file described in the previous step.

### Systemd unit
Assume what you extract tarball with release to `/opt/webapp/comindivion/current`. Then systemd unit looks follows:
```bash
[Unit]
Description=Comindivion web application (erlang)
After=network.target
Requires=postgresql.service

[Service]
WorkingDirectory=/opt/webapp/comindivion/current
User=www-data
Group=www-data
Restart=on-failure
RestartSec=5
EnvironmentFile=/opt/webapp/comindivion/env.vars
ExecStart=/opt/webapp/comindivion/current/bin/comindivion foreground
ExecStop=/opt/webapp/comindivion/current/bin/comindivion stop

[Install]
WantedBy=multi-user.target
```

## Integration with Let's Encrypt
If you don't know what is Let's Encrypt, please, take a look at [this](https://en.wikipedia.org/wiki/Let%27s_Encrypt) and [this](https://letsencrypt.org/).

Application already has support of a [webroot](https://certbot.eff.org/docs/using.html#webroot) method of obtaining a certificate.

So, firstly, needs to create a symlink to the 'static' directory of the production installation. This directory located in `<PATH TO RELEASE>/lib/comindivion-<VERSION>/priv/static`. Symlink needs to simplify future updating of the certificate.

Assume, you put the required symlink to `/opt/webapp/comindivion/static`. In this case you can simply run:
```bash
sudo certbot certonly --webroot --webroot-path /opt/webapp/comindivion/static/ --renew-by-default -d <FULL_DOMAIN_NAME_OF_YOUR_PRODUCTION_SERVER>
```

After this you obtain fullchain and privkey for ssl.

Finally, you can configure you elixir application for using https. Or you can make a reverse-proxy with support of https and run your elixir app locally using simple http protocol. Anyway, here you better know your available resources and aims.

## Integration with Google Analytics
This is extremely simple. Set the env variable `GA_IDENTIFIER` for a production server. In case of the previously described
systemd unit, you can set this variable in `env.vars`.
