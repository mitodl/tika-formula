{% from "tika/map.jinja" import tika with context %}

include:
  - .install
  - .service

write_tika_log_config:
  file.managed:
    - name: {{ tika.log_config_file }}
    - source: salt://tika/files/log4j_tika.xml
    - makedirs: True
    - watch_in:
      - service: tika_service_running
