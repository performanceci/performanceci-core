base:
  '*':
    - core
  'db':
    - postgres
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
