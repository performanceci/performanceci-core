{% from "perfci/map.jinja" import perfci with context %}
include:
  - .core

rails db migrate:
  cmd.wait:
    - name: bundle exec rake db:migrate
    - cwd: {{perfci.work_dir}}
    {%- if perfci.env is mapping %}
    - env:
      {%- for k,v in perfci.env.items() %}
      - {{k}}: {{v}}
      {%- endfor %}
    {%- endif %}
    - watch:
      - cmd: bundle install

rails server:
  cmd.run:
    - name: "nohup bundle exec rails server > {{perfci.work_dir}}/log/rails.log 2> {{perfci.work_dir}}/log/rails.err < /dev/null &"
    - cwd: {{perfci.work_dir}}
    - unless: pgrep -fa rails
    {%- if perfci.env is mapping %}
    - env:
      {%- for k,v in perfci.env.items() %}
      - {{k}}: {{v}}
      {%- endfor %}
    {%- endif %}
