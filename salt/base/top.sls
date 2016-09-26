base:
  #'*':
  #  - init.init

prod:
  '*':
    - modules.zabbix.init

  #'roles:webserver':
  #  - match: grain
  #  - modules.tomcat.init

  #'roles:java':
  #  - match: grain
  #  - modules.java.init
