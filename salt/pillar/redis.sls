redis:
  bind: {{ grains['ip4_interfaces']['eth1'][0] }}
  tcp_backlog: 0
