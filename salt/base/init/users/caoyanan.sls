{% set user_name = 'caoyanan' %}
{% set user_id = '30001' %}

user_add_{{ user_name }}:
  user.present:
    - name: {{ user_name }}
    - password: {{ pillar.caoyanan }}
    - uid: {{ user_id }}
    - gid: {{ user_id }}
    - shell: /bin/bash
    - home: /home/{{ user_name }}
    - require:
      - group: group_add_{{ user_name }}

group_add_{{ user_name }}:
  group.present:
    - name: {{ user_name }}
    - gid: {{ user_id }}
