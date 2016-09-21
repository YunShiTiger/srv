{% set mysql_pkg_path = '/usr/local/src' %}
{% set mysql_pkg_name = 'mysql-5.5.32-linux2.6-x86_64' %}
{% set mysql_path = '/usr/local' %}
{% set mysql_name = 'mysql-5.5.32' %}
{% set mysql_user = 'mysql' %}
{% set mysql_user_id = '605' %}

mysql-user_add:
  user.present:
    - name: mysql
    - uid: {{ mysql_user_id }}
    - gid: {{ mysql_user_id }}
    - shell: /sbin/nologin
    - createhome: False
    - require:
      - group: mysql-group_add

mysql-group_add:
  group.present:
    - name: {{ mysql_user }}
    - gid: {{ mysql_user_id }}

mysql_pkg_scp:
  file.managed:
    - name: {{ mysql_pkg_path }}/{{ mysql_pkg_name }}.tar.gz
    - source: salt://modules/mysql/files/{{ mysql_pkg_name }}.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f  {{ mysql_pkg_path }}/{{ mysql_pkg_name }}.tar.gz

mysql_pkg_install:
  cmd.script:
    - source: salt://modules/mysql/scripts/mysql_install.sh
    - template: jinja
    - defaults:
      mysql_pkg_path: {{ mysql_pkg_path }}
      mysql_pkg_name: {{ mysql_pkg_name }}
      mysql_path: {{ mysql_path }}
      mysql_name: {{ mysql_name }}
      mysql_user: {{ mysql_user }}
    - unless: test -L {{ mysql_path }}/mysql

mysql_conf_path:
  file.append:
    - name: /etc/profile
    - text:
      - export MYSQL_HOME={{ mysql_path }}/mysql
      - export PATH=$MYSQL_HOME/bin:$PATH
    - require:
      - cmd: mysql_pkg_install

mysql_init_scp:
  file.managed:
    - name: /etc/init.d/mysqld
    - source: salt://modules/mysql/files/mysql.server
    - template: jinja
    - defaults:
      mysql_path: {{ mysql_path }}
    - user: root
    - group: root
    - mode: 755

mysql_conf_scp:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://modules/mysql/files/my.cnf
    - user: root
    - group: root
    - mode: 755
