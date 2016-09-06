resolv_conf_scp:
  file.managed:
    - name: /etc/resolv.conf
    - source: salt://init/resolv/files/resolv.conf
    - user: root
    - group: root
    - mode: 644
    - backup: minion
