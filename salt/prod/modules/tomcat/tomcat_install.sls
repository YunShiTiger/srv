{% set tomcat_pkg_path = '/usr/local/src' %}
{% set tomcat_pkg_name = 'apache-tomcat-8.0.32' %}
{% set tomcat_path = '/usr/local' %}
{% set tomcat_name = 'tomcat' %}

include:
  - modules.java.init

tomcat_pkg_scp:
  file.managed:
    - name: {{ tomcat_pkg_path }}/{{ tomcat_pkg_name }}.tar.gz
    - source: salt://modules/tomcat/files/{{ tomcat_pkg_name }}.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f {{ tomcat_pkg_path }}/{{ tomcat_pkg_name }}.tar.gz

tomcat_pkg_install:
  cmd.script:
    - source: salt://modules/tomcat/scripts/tomcat_install.sh
    - template: jinja
    - defaults:
      tomcat_pkg_path: {{ tomcat_pkg_path }}
      tomcat_pkg_name: {{ tomcat_pkg_name }}
      tomcat_path: {{ tomcat_path }}
      tomcat_name: {{ tomcat_name }}
    - unless: test -L {{ tomcat_path }}/{{tomcat_name }}
