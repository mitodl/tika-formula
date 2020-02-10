{% from "tika/map.jinja" import tika with context %}
{% set heap_max = (salt.grains.get('mem_total') // 1.5) | int %}

include:
  - .service

install_tika_dependencies:
  pkg.installed:
    - pkgs: {{ tika.pkgs }}
    - update: True

create_tika_user:
  user.present:
    - name: {{ tika.user }}
    - system: True
    - createhome: False
    - shell: /bin/false

create_tika_group:
  group.present:
    - name: {{ tika.group }}
    - addusers:
        - {{ tika.user }}
    - system: True

create_tika_directory:
  file.directory:
    - name: {{ tika.executable }}
    - makedirs: True
    - user: {{ tika.user }}
    - group: {{ tika.user }}

download_tika_jar_file:
  file.managed:
    - name: {{ tika.executable }}/tika-server.{{ tika.version }}.jar
    - source: {{ tika.url }}-{{ tika.version }}.jar
    - source_hash: {{ tika.hash_url }}-{{ tika.version }}.jar.sha512
    - user: {{ tika.user }}
    - group: {{ tika.user }}
    - require_in:
        - service: tika_service_running 

create_log_directory_for_tika:
  file.directory:
    - name: /var/log/tika
    - makedirs: True
    - user: {{ tika.user }}
    - group: {{ tika.user }}

create_tika_service_definition:
  file.managed:
    - name: /etc/systemd/system/{{ tika.service }}.service
    - source: salt://tika/templates/tika.service
    - template: jinja
    - context:
        tika_user: {{ tika.user }}
        tika_group: {{ tika.group }}
        tika_host: {{ tika.host }}
        tika_port: {{ tika.port }}
        tika_path: {{ tika.executable }}
        tika_log_config_file: {{ tika.log_config_file }}
        tika_version: {{ tika.version }}
        heap_max: {{ heap_max }}
    - require:
        - user: create_tika_user
  cmd.wait:
    - name: systemctl daemon-reload
    - watch:
        - file: create_tika_service_definition
    - require_in:
        - service: tika_service_running
