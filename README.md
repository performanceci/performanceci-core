[![Stories in Ready](https://badge.waffle.io/performanceci/performanceci-core.png?label=ready&title=Ready)](https://waffle.io/performanceci/performanceci-core)
# PerformanceCI

This is a project to add application performance testing into your continuous
delivery pipeline. We built this over a hackathon weekend and decided to release
it to the public as open source.

## Stack

The main web UI is provided by [NGiNX](http://nginx.org) for serving static
content and routing requests to [uwsgi](http://uwsgi-docs.readthedocs.org/en/latest/#)
as the process manager and application server to a [Ruby on Rails](http://rubyonrails.org)
web framework backed by [PostgreSQL](http://www.postgresql.org) relational
database and [redis](http://redis.io) in-memory data store. Task workers are
provided by [resque](https://github.com/resque/resque) which generally tend
to interact with a [Docker API](https://github.com/swipely/docker-api).
Performance tests are currently provided by [vegeta](https://github.com/tsenart/vegeta)

## Development

### ngrok

In order for you to test webhooks locally, you'll need a way for GitHub to
reach your development application. We have found [ngrok](https://ngrok.com)
to be a simple solution. You will want to run ngrok oh your host and point it
at the IP address of your Docker VM. Our docker-compose setup includes an
NGiNX proxy accepting requests on port 80. You might invoke ngrok like so:

```bash
luser@lolcathost:~$ ngrok http $(docker-machine ip perfci):80
```

### GitHub OAuth

You will need to [Register a new OAuth application](https://github.com/settings/applications/new)
to generate a new Client ID and Client Secret. You will use these to set
environment variable for development or production deployments.

### Docker Compose

We currently rely on [Docker Compose](https://docs.docker.com/compose/) for
quickly standing up a development environment. We have provided a
[`docker-compose.yml`](docker-compose.yml) which should be driven by
environment variables. We have provided a sample set of environment variables
in a file, [`.env.example`](.env.example). You should copy this to `.env` and
modify according to your environment.

At minimum, you will need to set the following environment variables in your
`.env` file specific to your environment based on the previous steps.

```shell
WEBHOOK_URL
GITHUB_ID
GITHUB_SECRET
```

At this point, you should be able to stand up a development stack with
something like:

```shell
luser@lolcathost:~$ docker-compose up
```

You may periodically want to run migrations on your database with something
like this:

```shell
luser@lolcathost:~$ docker exec perfci-999-99-service bundle exec rake db:migrate
```

## License

[LICENCE](LICENSE)

This project is made available under the terms of the GNU Affero General Public
License (AGPL).
