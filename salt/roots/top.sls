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
    - worker.service
  'core':
    - rails
    - rails.db
    - rails.service
