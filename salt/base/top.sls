base:
  '*':
    - init.init

prod:
  '*':
    - modules.zabbix.init
  'roles:webserver':
    - match: grain
    - modules.tomcat.init
