{% set libevent_pkg_path = '/usr/local/src' %}
{% set libevent_pkg_name = 'libevent-2.0.22-stable' %}
{% set libevent_path = '/usr/local' %}
{% set libevent_name = 'libevent' %}

libevent_pkg_scp:
  file.managed:
    - name: {{ libevent_pkg_path }}/{{ libevent_pkg_name }}.tar.gz
    - source: salt://modules/libevent/files/{{ libevent_pkg_name }}.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f {{ libevent_pkg_path }}/{{ libevent_pkg_name }}.tar.gz

libevent_pkg_install:
  cmd.script:
    - source: salt://modules/libevent/scripts/libevent_install.sh
    - template: jinja
    - defaults:
      libevent_pkg_path: {{ libevent_pkg_path }}
      libevent_pkg_name: {{ libevent_pkg_name }}
      libevent_path: {{ libevent_path }}
      libevent_name: {{ libevent_name }}
    - unless: test -L {{ libevent_path }}/{{libevent_name }}
