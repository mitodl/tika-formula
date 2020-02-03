{% from "tika/map.jinja" import tika with context %}

tika_service_running:
  service.running:
    - name: {{ tika.service }}
    - enable: True
