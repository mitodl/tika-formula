{% from "tika/map.jinja" import tika with context %}

include:
  - .service

tika:
  pkg.installed:
    - pkgs: {{ tika.pkgs }}
    - require_in:
        - service: tika_service_running
