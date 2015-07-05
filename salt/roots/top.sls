base:
  '*':
    - core
  'db':
    - core.db
    - core.redis
  'docker':
    - core.ruby
    - docker
    - core.docker
  'core':
    - core.ruby
