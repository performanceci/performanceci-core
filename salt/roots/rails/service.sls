rails server:
  cmd.run:
    - name: 'nohup bundle exec rails server 2>&1 < /dev/null >> /vagrant/log/rails_server.log'
    - cwd: /vagrant
    - unless: pgrep -fa rails
    - env:
      - DB_HOST: 192.168.69.20
      - REDIS_HOST: 192.168.69.20
      - SERVER_HOST: 192.168.69.20
      - GITHUB_ID: {{salt['pillar.get']('rails:github:id', '')}}
      - GITHUB_SECRET: {{salt['pillar.get']('rails:github:secret', '')}}
      - WEBHOOK_URL: {{salt['pillar.get']('rails:webhook:url', '')}}
