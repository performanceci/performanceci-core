base:
  '*':
    - core
  'db':
    - core.db
    - core.redis
  'docker':
    - rails
    - docker
    - worker.docker
  'core':
    - rails
    - rails.db
    - rails.service
