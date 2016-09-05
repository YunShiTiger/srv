service_ntpdate_install:
  pkg.installed:
    - name: ntpdate

time_sync_conf:
  cron.present:
    - name: /usr/sbin/ntpdate cn.pool.ntp.org &>/dev/null
    - minute: '*/5'
    - hour: '*'
    - daymonth: '*'
    - month: '*'
    - dayweek: '*'
    - require:
      - pkg: service_ntpdate_install
