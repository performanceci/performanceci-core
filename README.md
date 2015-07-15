# PerformanceCI

This is a project to add application performance testing into your continuous
delivery pipeline. We built this over a hackathon weekend and decided to release
it to the public as open source.

## Development

### Salt

We are providing some example salt states to help manage a development
environment. The environment provided is a standalone/masterless setup for
simplicity. This has lead to a convention of salt formula dependency management
via git subtrees/remotes. While this requires a bit of extra effort from a new
developer, we believe this overhead is acceptable.

```bash
luser@lolcathost:perfocmanceci-core $ git remote add docker-formula https://github.com/saltstack-formulas/docker-formula.git
luser@lolcathost:perfocmanceci-core $ git subtree add --prefix salt/formulas/docker-formula docker-formula master --squash
```

### Vagrant

We have attempred to provide a Vagrantfile meeting the minimum requirements to
run the application[s] for demonstration and development purposes. After a
developer has forked and/or cloned this repository from GitHub, she should be
able to `vagrant up` and have nearly everything needed to beging testing
and working.

### ngrok

In order for you to test webhooks locally, you'll need a way for GitHub to
reach your development application. We have found [ngrok](https://ngrok.com)
to be a simple solution. You will want to run ngrok oh your host (not
your development vagrant box). Point it at the IP address of your vagrant box
and the default Rails WEBrick server port.

```bash
luser@lolcathost:~$ ~/Downloads/ngrok http 192.168.69.10:3000
```

### GitHub OAuth

You will need to [Register a new OAuth application](https://github.com/settings/applications/new)
to generate a new Client ID and Client Secret. You will use these to set pillar
data for your deployment.

### Salt

We will use pillar data as the simplest source for setting the necessary
environment variables to get your application up and running. For reference,
the following environment variable will need to be set for you to successfully
test the full suite.

```shell
WEBHOOL_URL
GITHUB_ID
GITHUB_SECRET
```

We will expose these as pillar data in `salt/pillar/rails.sls` which you will
find in this repository. The example we provide should look like this:

```yaml
rails:
  github:
    id: e25ce854ac3bd4d21641
    secret: aec6e45fbed7a749203ebb52b33aaa08bf7c9073
  webhook:
    url: https://a3010de7.ngrok.io
```

Update those values with the ones as described above, `vagrant up`, and go get
some coffee or tea.

Then just point your browser of choice at the ngrok URL you configured above.
You may log into the service with your GitHub account.

You will find log output in under the  `logs` directory.

## Deployment

Here is our current deployment stack

### Ubuntu 14.04.2 LTS (Trusty Tahr)

[Ubuntu](http://releases.ubuntu.com/trusty/)

We have included some simple [salt states](salt/roots/) to ensure a development
host includes the necessary dependencies. At this time, these may be considered
a starting point for production deployments. These states currently assume
a stack based on the latest Long Term Support Ubuntu (14.04.2).

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
