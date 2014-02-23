# PerformanceCI

This is a project to add application performance testing into your continuous
delivery pipeline. We built this over a hackathon weekend and decided to release
it to the public as open source.

## Deployment

Here is our current deployment stack

### Ubuntu (13.10)

[Ubuntu](http://www.ubuntu.com/)

We have included a simple [bootstrap](scripts/bootstrap.sh) script
which should get most of dependencies out of the way. This script currently
assumes a stack based on the latest Ubuntu (13.10).

### Ruby on Rails

[RoR](http://rubyonrails.org/)

This is just a simple Ruby on Rails application.

### Docker

[Docker](https://www.docker.io/)

The project relies on Docker to manage standing up the web applications to be
tested.

### Redis

[Redis](http://redis.io/)

The project current requires a Redis server running on the same host as the
main rails application.

### Resque

[Resque](https://github.com/resque/resque)

The project uses some resque workers to collect performance statistics on the
applications to be tested.

## License

[LICENCE](LICENSE)

This project is made available under the terms of the GNU Affero General Public
License (AGPL).
