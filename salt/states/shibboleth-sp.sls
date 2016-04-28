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

# TODO: No need for this after metadata is fetched with file.managed
curl:
  pkg.installed

# TODO: Convert this to file.managed once https://github.com/saltstack/salt/pull/31265 becomes available.
metadata:
  cmd.run:
    - name: curl -k "https://www.testshib.org/cgi-bin/sp2config.cgi?dist=Others&hostname=$(hostname)" > /etc/shibboleth/shibboleth2.xml
    - require:
      - pkg: curl

shibd:
  service.running:
    - enable: True
    - require:
      - pkg: shibboleth
      - selinux: permissive
# TODO: Add this once the metadata state is switched to file.managed
#    - watch:
#      - file: /etc/shibboleth/shibboleth2.xml

secure_sessions:
  file.line:
    - name: /etc/shibboleth/shibboleth2.xml
    - match: <Sessions
    - content: <Sessions lifetime="28800" timeout="3600" checkAddress="false" relayState="ss:mem" handlerSSL="true" cookieProps="https">
    - mode: Replace
    - indent: True
    - require:
      - cmd: metadata
