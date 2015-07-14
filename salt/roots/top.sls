base:
  '*':
    - core
  'db':
    - core.db
    - core.redis
  'docker':
    - rails
    - docker
    - core.docker
  'core':
    - rails
