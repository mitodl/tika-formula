{% from "tika/map.jinja" import tika with context %}

include:
  - .install
  - .service

tika-config:
  file.managed:
    - name: {{ tika.conf_file }}
    - source: salt://tika/templates/conf.jinja
    - template: jinja
    - watch_in:
      - service: tika_service_running
    - require:
      - pkg: tika
