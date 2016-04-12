chrony:
  pkg.installed

chronyd:
  service.running:
    - enable: True
    - require:
      - pkg: chrony
