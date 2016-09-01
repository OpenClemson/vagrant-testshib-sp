shibboleth-repo:
  pkgrepo.managed:
    - humanname: Shibboleth (CentOS_7)
    - name: shibboleth
    - baseurl: http://download.opensuse.org/repositories/security:/shibboleth/CentOS_7/
    - gpgkey: http://download.opensuse.org/repositories/security:/shibboleth/CentOS_7//repodata/repomd.xml.key
    - gpgcheck: 1

shibboleth:
  pkg.installed:
    - require:
      - pkgrepo: shibboleth-repo

metadata:
  file.managed:
    - name: /etc/shibboleth/shibboleth2.xml
    - source: https://www.testshib.org/cgi-bin/sp2config.cgi?dist=Others&hostname={{ salt["network"].get_hostname() }}
    - skip_verify: true

secure_sessions:
  file.line:
    - name: /etc/shibboleth/shibboleth2.xml
    - match: <Sessions
    - content: <Sessions lifetime="28800" timeout="3600" checkAddress="false" relayState="ss:mem" handlerSSL="true" cookieProps="https">
    - mode: Replace
    - indent: True
    - require:
      - file: metadata

enable_eduperson_example_attributes:
  file.replace:
    - name: /etc/shibboleth/attribute-map.xml
    - pattern: (<!-- Some more eduPerson attributes, uncomment these to use them... -->)\n\s*<!--(.*?)-->
    - repl: \1\n\2
    - flags:
      - DOTALL
      - MULTILINE
    - require:
      - file: metadata

enable_ldap_example_attributes:
  file.replace:
    - name: /etc/shibboleth/attribute-map.xml
    - pattern: (<!-- Examples of LDAP-based attributes, uncomment to use these... -->)\n\s*<!--(.*?)-->
    - repl: \1\n\2
    - flags:
      - DOTALL
      - MULTILINE
    - require:
      - file: metadata

shibd:
  service.running:
    - enable: True
    - require:
      - pkg: shibboleth
      - selinux: permissive
    - watch:
      - file: /etc/shibboleth/attribute-map.xml
      - file: /etc/shibboleth/shibboleth2.xml
