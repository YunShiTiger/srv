{% set libiconv_pkg_path = '/usr/local/src' %}
{% set libiconv_pkg_name = 'libiconv-1.14' %}
{% set libiconv_path = '/usr/local' %}
{% set libiconv_name = 'libiconv' %}

include:
  - modules.java.init

libiconv_pkg_scp:
  file.managed:
    - name: {{ libiconv_pkg_path }}/{{ libiconv_pkg_name }}.tar.gz
    - source: salt://modules/libiconv/files/{{ libiconv_pkg_name }}.tar.gz
    - user: root
    - group: root
    - mode: 644

libiconv_pkg_install:
  cmd.script:
    - source: salt://modules/libiconv/scripts/libiconv_install.sh
    - template: jinja
    - defaults:
      libiconv_pkg_path: {{ libiconv_pkg_path }}
      libiconv_pkg_name: {{ libiconv_pkg_name }}
      libiconv_path: {{ libiconv_path }}
      libiconv_name: {{ libiconv_name }}
    - unless: test -L {{ libiconv_path }}/{{libiconv_name }}
