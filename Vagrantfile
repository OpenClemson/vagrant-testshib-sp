# Require landrush plugin for DNS
unless Vagrant.has_plugin?("landrush")
  $stderr.puts "\033[33mThe landrush plugin is required. Please install it with:\033[0m"
  $stderr.puts "\033[33m$ vagrant plugin install landrush\033[0m"
  exit(false)
end

Vagrant.configure(2) do |config|

  config.vm.box = "boxcutter/centos71"

  config.landrush.enabled = true
  config.vm.hostname = "shibsp.vagrant.test"

  config.vm.synced_folder "./salt", "/srv/salt"
  config.vm.synced_folder "./docroot", "/var/www/html", owner: "root", group: "root"

  config.vm.provision :salt do |salt|

    salt.install_type = "git"
    salt.install_args = "v2015.8.8.2"

    salt.masterless = true
    salt.run_highstate = true
    salt.verbose = true
    salt.colorize = true
  end

end
