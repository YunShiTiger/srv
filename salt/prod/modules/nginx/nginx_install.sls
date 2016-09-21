{% set nginx_pkg_path = '/usr/local/src' %}
{% set nginx_pkg_name = 'nginx-1.10.1' %}
{% set nginx_path = '/usr/local' %}
{% set nginx_name = 'nginx' %}
{% set nginx_user = 'nginx' %}
{% set nginx_user_id = '602' %}

include:
  - modules.libiconv.init

nginx_user_add:
  user.present:
    - name: {{ nginx_user }}
    - uid: {{ nginx_user_id }}
    - gid: {{ nginx_user_id }}
    - shell: /sbin/nologin
    - createhome: False
    - require:
      - group: nginx_group_add

nginx_group_add:
  group.present:
    - name: {{ nginx_user }}
    - gid: {{ nginx_user_id }}

nginx_pkg_scp:
  file.managed:
    - name: {{ nginx_pkg_path }}/{{ nginx_pkg_name }}.tar.gz
    - source: salt://modules/nginx/files/{{ nginx_pkg_name }}.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f {{ nginx_pkg_path }}/{{ nginx_pkg_name }}.tar.gz

nginx_pkg_install:
  cmd.script:
    - source: salt://modules/nginx/scripts/nginx_install.sh
    - template: jinja
    - defaults:
      nginx_pkg_path: {{ nginx_pkg_path }}
      nginx_pkg_name: {{ nginx_pkg_name }}
      nginx_path: {{ nginx_path }}
      nginx_name: {{ nginx_name }}
      nginx_user: {{ nginx_user }}
    - unless: test -L {{ nginx_path }}/{{ nginx_name}}

nginx_init_scp:
  file.managed:
    - name: /etc/init.d/nginx
    - source: salt://modules/nginx/files/init.d.nginx
    - template: jinja
    - user: root
    - group: root
    - mode: 755
    - defaults:
      nginx_path: {{ nginx_path }}
      nginx_name: {{ nginx_name }}
    - unless: test -f /etc/init.d/nginx

#nginx_conf_scp:
#  file.managed:
#    - name: {{ nginx_path }}/{{ nginx_name }}/conf/nginx.conf
#    - source: salt://modules/nginx/files/nginx.conf
#    - template: jinja
#    - user: root
#    - group: root
#    - mode: 644
#    - defaults:
#      nginx_user: {{ nginx_user }}
