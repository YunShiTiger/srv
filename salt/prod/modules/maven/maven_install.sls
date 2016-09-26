{% set maven_pkg_path = '/usr/local/src' %}
{% set maven_pkg_name = 'apache-maven-3.3.9' %}
{% set maven_path = '/usr/local' %}
{% set maven_name = 'maven' %}

maven_pkg_scp:
  file.managed:
    - name: {{ maven_pkg_path }}/{{ maven_pkg_name }}-bin.zip
    - source: salt://modules/maven/files/{{ maven_pkg_name }}-bin.zip
    - user: root
    - group: root
    - mode: 644
    - unless: test -f {{ maven_pkg_path }}/{{ maven_pkg_name }}-bin.zip

maven_pkg_install:
  cmd.script:
    - source: salt://modules/maven/scripts/maven_install.sh
    - template: jinja
    - defaults:
      maven_pkg_path: {{ maven_pkg_path }}
      maven_pkg_name: {{ maven_pkg_name }}
      maven_path: {{ maven_path }}
      maven_name: {{ maven_name }}
    - unless: test -L {{ maven_path }}/{{ maven_name }}

maven_conf_path:
  file.append:
    - name: /etc/profile
    - text:
      - export MAVEN_HOME={{ maven_path }}/{{ maven_name }}
      - export PATH=$MAVEN_HOME/bin:$PATH
    - require:
      - cmd: maven_pkg_install
