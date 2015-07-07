pg package:
  pkg.installed:
    - name: postgresql-9.3

pg config:
  file.managed:
    - name: /etc/postgresql/9.3/main/pg_hba.conf
    - source: salt://core/files/pg_hba.conf

pg service:
  service.running:
    - name: postgresql
    - enable: True
    - require:
      - pkg: pg package
    - watch:
      - file: pg config

pg dev db:
  postgres_user.present:
    - name: perfci
    - createdb: True
  postgres_database.present:
    - name: perfci_development
    - owner: perfci
    - require:
      - file: pg config
