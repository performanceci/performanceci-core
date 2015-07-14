seed the db:
  cmd.wait:
    - name: bundle exec rake db:seed
    - cwd: /vagrant
    - env:
      - DB_HOST: 192.168.69.20
    - watch:
      - cmd: bundle install

rails db migrate:
  cmd.wait:
    - name: bundle exec rake db:migrate
    - cwd: /vagrant
    - env:
      - DB_HOST: 192.168.69.20
    - watch:
      - cmd: seed the db
