rails package dependencies:
  pkg.installed:
    - pkgs:
      - ruby2.0
      - ruby2.0-dev
      - libxml2-dev
      - libxslt1-dev
      - libpq-dev
      - libsqlite3-dev
      - bundler

rails gem dependencies:
  cmd.wait:
    - name: bundle install
    - cwd: /vagrant
    - watch:
      - pkg: rails package dependencies
