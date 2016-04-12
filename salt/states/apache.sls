httpd:
  pkg.installed

mod_ssl:
  pkg.installed

php:
  pkg.installed

httpd-service:
  service.running:
    - name: httpd
    - enable: True
    - require:
      - pkg: httpd
      - pkg: mod_ssl
      - pkg: php
    - watch:
      - file: /etc/httpd/conf/httpd.conf

/etc/httpd/conf/httpd.conf:
  file.blockreplace:
    - marker_start: <Directory "/var/www/html">
    - marker_end: </Directory>
    - source: salt://files/docroot_directory.conf
    - show_changes: True
