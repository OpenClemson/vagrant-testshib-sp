vim-enhanced:
  pkg.installed

# Directory for caching metadata file name
metadata-cache-directory:
  file.directory:
    - name: /etc/vagrant-testshib-sp
    - user: vagrant
    - group: vagrant
    - dir_mode: 775
    - file_mode: 664
    - recurse:
      - user
      - group
      - mode
