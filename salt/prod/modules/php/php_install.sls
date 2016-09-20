{% set php_pkg_path = '/usr/local/src' %}
{% set php_pkg_name = 'php-5.5.32' %}
{% set php_path = '/usr/local' %}
{% set php_name = 'php' %}
{% set php_user = 'php' %}
{% set php_user_id = '603' %}

include:
  - modules.libiconv.init

php_user_add:
  user.present:
    - name: {{ php_user }}
    - uid: {{ php_user_id }}
    - gid: {{ php_user_id }}
    - shell: /sbin/nologin
    - createhome: False
    - require:
      - group: php_group_add

php_group_add:
  group.present:
    - name: {{ php_user }}
    - gid: {{ php_user_id }}

php_pkg_scp:
  file.managed:
    - name: {{ php_pkg_path }}/{{ php_pkg_name }}.tar.gz
    - source: salt://modules/php/files/{{ php_pkg_name }}.tar.gz
    - user: root
    - group: root
    - mode: 644

php_pkg_install:
  cmd.script:
    - source: salt://modules/php/scripts/php_install.sh
    - template: jinja
    - defaults:
      php_pkg_path: {{ php_pkg_path }}
      php_pkg_name: {{ php_pkg_name }}
      php_path: {{ php_path }}
      php_name: {{ php_name }}
      php_user: {{ php_user }}
    - unless: test -L {{ php_path }}/{{ php_name}}
