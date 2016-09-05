bashrc_conf_scp:
  file.managed:
    - name: /etc/bashrc
    - source: salt://init/bashrc/files/bashrc
    - user: root
    - group: root
    - mode: 644
    - backup: minion
