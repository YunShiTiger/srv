base:
  '*':
    - init.init

prod:
  '*':
    - modules.zabbix.init
