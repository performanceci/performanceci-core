{%- set work_dir = salt['pillar.get']('perfci:work_dir', '/vagrant') %}
{%- set db_host = salt['pillar.get']('perfci:db_host', 'localhost') %}
{%- set redis_host = salt['pillar.get']('perfci:redis_host', 'localhost') %}
{%- set target_host = salt['pillar.get']('perfci:target_host', 'localhost') %}
rails server:
  cmd.run:
    - name: "nohup bundle exec rails server > {{work_dir}}/log/rails.log 2> {{work_dir}}/log/rails.err < /dev/null &"
    - cwd: {{work_dir}}
    - unless: pgrep -fa rails
    - env:
      - DB_HOST: {{db_host}}
      - REDIS_HOST: {{redis_host}}
      - SERVER_HOST: {{target_host}}
      - RAILS_ENV: {{salt['pillar.get']('perfci:rails_env', 'development')}}
      - GITHUB_ID: {{salt['pillar.get']('rails:github:id', '')}}
      - GITHUB_SECRET: {{salt['pillar.get']('rails:github:secret', '')}}
      - WEBHOOK_URL: {{salt['pillar.get']('rails:webhook:url', '')}}
