base:
  '*':
    - core
  'db':
    - postgres
    - redis.server
  'docker':
    - rails
    - docker
    - worker.docker
    - worker.service
  'core':
    - rails
    - rails.db
    - rails.service
