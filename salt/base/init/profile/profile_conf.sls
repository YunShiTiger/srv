profile_conf_scp:
  file.managed:
    - name: /etc/profile
    - source: salt://init/profile/files/profile
    - user: root
    - group: root
    - mode: 644
    - backup: minion
