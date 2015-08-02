{% from "perfci/map.jinja" import perfci with context %}
include:
  - .init

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
    - cwd: {{perfci.work_dir}}
    - watch:
      - pkg: rails package dependencies

