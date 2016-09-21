{% set zabbix_pkg_path = '/usr/local/src' %}
{% set zabbix_pkg_name = 'zabbix-3.0.4' %}
{% set zabbix_path = '/usr/local' %}
{% set zabbix_name = 'zabbix-agent' %}
{% set zabbix_server_ip  = '192.168.56.132' %}
{% set zabbix_user  = 'zabbix' %}
{% set zabbix_user_id  = '601' %}

zabbix-user_add:
  user.present:
    - name: {{ zabbix_user }}
    - uid: {{ zabbix_user_id }}
    - gid: {{ zabbix_user_id }}
    - shell: /sbin/nologin
    - createhome: False
    - require:
      - group: zabbix-group_add

zabbix-group_add:
  group.present:
    - name: {{ zabbix_user }}
    - gid: {{ zabbix_user_id }}

zabbix_pkg_scp:
  file.managed:
    - name: {{ zabbix_pkg_path }}/{{ zabbix_pkg_name }}.tar.gz
    - source: salt://modules/zabbix/files/{{ zabbix_pkg_name }}.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f {{ zabbix_pkg_path }}/{{ zabbix_pkg_name }}.tar.gz

zabbix_pkg_install:
  cmd.script:
    - source: salt://modules/zabbix/scripts/zabbix-agent_install.sh
    - template: jinja
    - defaults:
      zabbix_pkg_path: {{ zabbix_pkg_path }}
      zabbix_pkg_name: {{ zabbix_pkg_name }}
      zabbix_path: {{ zabbix_path }}
      zabbix_name: {{ zabbix_name }}
    - unless: test -L {{ zabbix_path }}/{{ zabbix_name }}

zabbix-agent_conf_scp:
  file.managed:
    - name: {{ zabbix_path }}/{{ zabbix_name }}/etc/zabbix_agentd.conf
    - source: salt://modules/zabbix/files/zabbix_agentd.conf
    - template: jinja
    - defaults:
      zabbix_server_ip: {{ zabbix_server_ip }}
      zabbix_path: {{ zabbix_path }}
      zabbix_name: {{ zabbix_name }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: zabbix_pkg_install
    - backup: minion

zabbix_init_scp:
  file.managed:
    - name: /etc/init.d/zabbix-agentd
    - source: salt://modules/zabbix/files/zabbix-agentd
    - template: jinja
    - user: root
    - group: root
    - mode: 755
    - defaults:
      zabbix_path: {{ zabbix_path }}
      zabbix_name: {{ zabbix_name }}
    - unless: test -f /etc/init.d/zabbix

zabbix_service_start:
  service.running:
    - name: zabbix-agentd
    - enable: True
    - reload: True
