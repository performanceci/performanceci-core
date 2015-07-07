redis package:
  pkg.installed:
    - name: redis-server

redis remote listen:
  file.replace:
    - name: /etc/redis/redis.conf
    - pattern: 'bind 127.0.0.1'
    - repl: 'bind 192.168.69.20'

redis service:
  service.running:
    - name: redis-server
    - enable: True
    - require:
      - pkg: redis package
    - watch:
      - file: redis remote listen
