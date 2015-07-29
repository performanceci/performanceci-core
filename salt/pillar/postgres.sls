postgres:
  conf_dir: /etc/postgresql/9.3/main
  users:
    perfci:
      createdb: True
  databases:
    perfci_development:
      owner: 'perfci'
  acls:
    - ['host', 'perfci_development', 'perfci', '192.168.69.0/24', 'trust']
  postgresconf: |
    listen_addresses = 'localhost,*'
