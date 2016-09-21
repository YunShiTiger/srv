{% set java_pkg_path = '/usr/local/src' %}
{% set java_pkg_name = 'jdk-8u74-linux-x64' %}
{% set java_path = '/usr/local' %}
{% set java_name = 'jdk1.8.0_74' %}

java_pkg_scp:
  file.managed:
    - name: {{ java_pkg_path }}/{{ java_pkg_name }}.tar.gz
    - source: salt://modules/java/files/{{ java_pkg_name }}.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f {{ java_pkg_path }}/{{ java_pkg_name }}.tar.gz

java_pkg_install:
  cmd.script:
    - source: salt://modules/java/scripts/java_install.sh
    - template: jinja
    - defaults:
      java_pkg_path: {{ java_pkg_path }}
      java_pkg_name: {{ java_pkg_name }}
      java_path: {{ java_path }}
      java_name: {{ java_name }}
    - unless: test -L {{ java_path }}/jdk

java_conf_path:
  file.append:
    - name: /etc/profile
    - text:
      - export JAVA_HOME={{ java_path }}/jdk
      - export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
      - export PATH=$JAVA_HOME/bin:$PATH
    - require:
      - cmd: java_pkg_install
