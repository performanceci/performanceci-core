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

We should strive to provide a Vagrantfile meeting the minimum requirements to
run the application[s] for demonstration and development purposes. After a
developer has forked and/or cloned this repository from GitHub, she should be
able to `vagrant up` and have nearly everything needed to beging testing
and working.

We should strive to provide documentation on the remaining steps until they are
sufficiently automated.

We have provided some example application runner scripts which should be clear
given the provided documentation.

### ngrok

In order for you to test webhooks locally, you'll need a way for GitHub to
reach your development application. We have found [ngrok](https://ngrok.com)
to be a simple solution. You will want to run ngrok oh your host (not
your development vagrant box). Point it at the IP address of your vagrant box
and the default Rails WEBrick server port.

```bash
luser@lolcathost:~$ ~/Downloads/ngrok http 192.168.69.10:3000
```

Use the URL provided to set the environment variable for webhooks

```bash
luser@vagrant:~$ export WEBHOOK_URL=http://37674d.ngrok.com
```

### GitHub OAuth

You will need to [Register a new OAuth application](https://github.com/settings/applications/new)
to generate a new Client ID and Client Secret. For convenience, you may use
these to set environment variables for your deployment to pick up.

```bash
luser@vagrant:~$ export GITHUB_ID=015a6232ecb598df88f8
luser@vagrant:~$ export GITHUB_SECRET=f9633c56f2430d5b2beb4334d996b571dbdef9f1
```

### Example Startup

For now, we have provided some example startup scripts under the `scripts`
directory of the project. The only thing you should need to do is copy these
to some name of your own choosing, and update the three environment variables
described above.

```shell
WEBHOOL_URL
GITHUB_ID
GITHUB_SECRET
```

These three environment variables must be set for you to test or demo the
service locally. They must be set according to your own setup as described
above.

The minimum needed to get up from here, is to start the rails server and at
least one "docker" worker.

```shell
luser@lolcathost:performanceci-core$ vagrant ssh docker
luser@vagrant:~$ cd /vagrant/scripts
luser@vagrant:/vagrant/scripts$ ./run_docker_worker.sh
^D
luser@lolcathost:performanceci-core$ vagrant ssh core
luser@vagrant:~$ cd /vagrant/scripts
luser@vagrant:/vagrant/scripts$ ./run.sh
^D
```

Then just point your browser of choice at the ngrok URL you configured above.
You may log into the service with your GitHub account.

You will find log output in the VMs at `~/.docker.out` and `~/.core.out`
respectively.

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
