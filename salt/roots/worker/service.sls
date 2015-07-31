{%- set work_dir = salt['pillar.get']('perfci:work_dir', '/vagrant') %}
{%- set db_host = salt['pillar.get']('perfci:db_host', 'localhost') %}
{%- set redis_host = salt['pillar.get']('perfci:redis_host', 'localhost') %}
{%- set target_host = salt['pillar.get']('perfci:target_host', 'localhost') %}
resque worker service:
  cmd.run:
    - name: 'nohup bundle exec rake resque:work > {{work_dir}}/log/resque.log 2> {{work_dir}}/log/resque.err < /dev/null &'
    - cwd: {{work_dir}}
    - unless: pgrep -fa resque
    - env:
      - DB_HOST: {{db_host}}
      - REDIS_HOST: {{redis_host}}
      - SERVER_HOST: {{target_host}}
      - DOCKER_URL: 'unix:///run/docker.sock'
      - RAILS_ENV: {{salt['pillar.get']('perfci:rails_env', 'development')}}
      - QUEUE: docker
