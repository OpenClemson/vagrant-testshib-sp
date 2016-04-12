policycoreutils:
  pkg.installed

policycoreutils-python:
  pkg.installed

permissive:
  selinux.mode:
    - require:
      - pkg: policycoreutils
      - pkg: policycoreutils-python
