{% set memcached_pkg_path = '/usr/local/src' %}
{% set memcached_pkg_name = 'memcached-1.4.29' %}
{% set memcached_path = '/usr/local' %}
{% set memcached_name = 'memcached' %}

include:
  - modules.libevent.init

memcached_pkg_scp:
  file.managed:
    - name: {{ memcached_pkg_path }}/{{ memcached_pkg_name }}.tar.gz
    - source: salt://modules/memcached/files/{{ memcached_pkg_name }}.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f {{ memcached_pkg_path }}/{{ memcached_pkg_name }}.tar.gz

memcached_pkg_install:
  cmd.script:
    - source: salt://modules/memcached/scripts/memcached_install.sh
    - template: jinja
    - defaults:
      memcached_pkg_path: {{ memcached_pkg_path }}
      memcached_pkg_name: {{ memcached_pkg_name }}
      memcached_path: {{ memcached_path }}
      memcached_name: {{ memcached_name }}
    - unless: test -L {{ memcached_path }}/{{ memcached_name }}

#memcached-agent_conf_scp:
#  file.managed:
#    - name: {{ memcached_path }}/{{ memcached_name }}/etc/memcached_agentd.conf
#    - source: salt://modules/memcached/files/memcached_agentd.conf
#    - template: jinja
#    - defaults:
#      memcached_path: {{ memcached_path }}
#      memcached_name: {{ memcached_name }}
#    - user: root
#    - group: root
#    - mode: 644
#    - require:
#      - cmd: memcached_pkg_install
#    - backup: minion
