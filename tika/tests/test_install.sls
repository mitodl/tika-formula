{% from "tika/map.jinja" import tika with context %}

{% for pkg in tika.pkgs %}
test_{{pkg}}_is_installed:
  testinfra.package:
    - name: {{ pkg }}
    - is_installed: True
{% endfor %}
