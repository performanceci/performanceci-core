allow vagrant user to docker:
  group.present:
    - name: docker
    - addusers:
      - vagrant
    - watch_in:
      - service: docker-service
