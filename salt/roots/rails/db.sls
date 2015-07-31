rails db migrate:
  cmd.wait:
    - name: bundle exec rake db:migrate
    - cwd: {{salt['pillar.get']('perfci:work_dir', '/vagrant')}}
    - env:
      - DB_HOST: {{salt['pillar.get']('perfci:db_host', 'localhost')}}
    - watch:
      - cmd: bundle install
