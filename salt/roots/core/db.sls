pg package:
  pkg.installed:
    - name: postgresql-9.3

pg client auth:
  file.managed:
    - name: /etc/postgresql/9.3/main/pg_hba.conf
    - source: salt://core/files/pg_hba.conf

pg remote listen:
  file.append:
    - name: /etc/postgresql/9.3/main/postgresql.conf
    - text: "listen_addresses = '192.168.69.20'"

pg service:
  service.running:
    - name: postgresql
    - enable: True
    - require:
      - pkg: pg package
    - watch:
      - file: pg client auth
      - file: pg remote listen

pg dev db:
  postgres_user.present:
    - name: perfci
    - createdb: True
  postgres_database.present:
    - name: perfci_development
    - owner: perfci
    - require:
      - file: pg client auth
      - file: pg remote listen
