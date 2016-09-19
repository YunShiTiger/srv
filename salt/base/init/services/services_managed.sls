services_managed:
  cmd.run:
    - name: chkconfig --list|grep "3:on"|awk '{print $1}'|grep -Ev "sshd|rsyslog|network|crond|sysstat|salt-minion|salt-master|zabbix-agentd" |sed -r 's#(.*)#chkconfig \1 off#g' |bash
    - unless: test -f /etc/rc.d/rc3.d/K92iptables

service_iptables_stop:
  service.running:
    - name: iptables
    - enable: False
    - dead: True

#sercie_selinux_stop:
#  cmd.run:
#    - name: setenforce 0
#    - unless: [ $(grep SELINUX=enforcing /etc/selinux/config |wc -l) -eq 0 ]
