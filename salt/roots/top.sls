base:
  'db':
    - postgres
    - redis.server
  'docker':
    - perfci.core
    - docker
    - perfci.worker
  'core':
    - perfci.rails
