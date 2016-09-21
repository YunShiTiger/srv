{% set redis_pkg_path = '/usr/local/src' %}
{% set redis_pkg_name = 'redis-3.2.1' %}
{% set redis_path = '/usr/local' %}
{% set redis_name = 'redis' %}

redis_pkg_scp:
  file.managed:
    - name: {{ redis_pkg_path }}/{{ redis_pkg_name }}.tar.gz
    - source: salt://modules/redis/files/{{ redis_pkg_name }}.tar.gz
    - user: root
    - group: root
    - mode: 644

redis_pkg_install:
  cmd.script:
    - source: salt://modules/redis/scripts/redis_install.sh
    - template: jinja
    - defaults:
      redis_pkg_path: {{ redis_pkg_path }}
      redis_pkg_name: {{ redis_pkg_name }}
      redis_path: {{ redis_path }}
      redis_name: {{ redis_name }}
    - unless: test -L {{ redis_path }}/{{ redis_name }}

#redis-agent_conf_scp:
#  file.managed:
#    - name: {{ redis_path }}/{{ redis_name }}/etc/redis_agentd.conf
#    - source: salt://modules/redis/files/redis_agentd.conf
#    - template: jinja
#    - defaults:
#      redis_path: {{ redis_path }}
#      redis_name: {{ redis_name }}
#    - user: root
#    - group: root
#    - mode: 644
#    - require:
#      - cmd: redis_pkg_install
#    - backup: minion
