{% from "perfci/map.jinja" import perfci with context %}

{%- if salt['grains.get']('virtual', '') == 'VirtualBox' %}
allow vagrant user to docker:
  group.present:
    - name: docker
    - addusers:
      - vagrant
    - watch_in:
      - service: docker-service
{% endif %}

resque worker service:
  cmd.run:
    - name: 'nohup bundle exec rake resque:work > {{perfci.work_dir}}/log/resque.log 2> {{perfci.work_dir}}/log/resque.err < /dev/null &'
    - cwd: {{perfci.work_dir}}
    - unless: pgrep -fa resque
    {%- if perfci.env is mapping %}
    - env:
      {%- for k, v in perfci.env.items() %}
      - {{k}}: {{v}}
      {%- endfor %}
    {%- endif %}
