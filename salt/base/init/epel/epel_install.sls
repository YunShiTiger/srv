epel_conf_add:
  pkg.installed:
    - sources:
      - epel-release: http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
