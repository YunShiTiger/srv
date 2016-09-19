base:
  '*':
    - init.init

prod:
  'roles:mysql':
    - match: grain
    - modules.mysql.init
