sshd_conf_scp:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://init/sshd/files/sshd_config
    - user: root
    - group: root
    - mode: 644
    - backup: minion

service_sshd_restart:
  service.running:
    - name: sshd
    - enable: True
    - reload: True
