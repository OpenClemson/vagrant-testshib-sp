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
      - file: /etc/httpd/conf.d/ssl.conf

apache-docroot-configuration:
  file.blockreplace:
    - name: /etc/httpd/conf/httpd.conf
    - marker_start: <Directory "/var/www/html">
    - marker_end: </Directory>
    - source: salt://files/docroot_directory.conf
    - show_changes: True

apache-servername:
  file.replace:
    - name: /etc/httpd/conf/httpd.conf
    - pattern: ^#?ServerName .+
    - repl: ServerName {{ salt["network"].get_hostname() }}:80
    - show_changes: True

apache-servername-ssl:
  file.replace:
    - name: /etc/httpd/conf.d/ssl.conf
    - pattern: ^#?ServerName .+
    - repl: ServerName {{ salt["network"].get_hostname() }}:443
    - show_changes: True

# See https://www.vagrantup.com/docs/synced-folders/virtualbox.html
disable-sendfile:
  file.replace:
    - name: /etc/httpd/conf/httpd.conf
    - pattern: ^EnableSendfile on
    - flags: ["IGNORECASE", "MULTILINE"]
    - repl: EnableSendfile Off
    - show_changes: True
