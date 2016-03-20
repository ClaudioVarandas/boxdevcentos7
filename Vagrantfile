host_folder = "~/Projects"
remote_folder = "/var/www"
php_timezone = "UTC"

vm_hostname = "devbox7"
vm_ip_address = "172.16.200.200"


Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"

  config.vm.hostname = vm_hostname

  # Create a static IP
  if Vagrant.has_plugin?("vagrant-auto_network")
    config.vm.network :private_network, :ip => "0.0.0.0", :auto_network => true
  else
    config.vm.network :private_network, ip: vm_ip_address
    config.vm.network :forwarded_port, guest: 80, host: 8000
  end

  # Enable agent forwarding over SSH connections
  config.ssh.forward_agent = true

  # Use NFS for the shared folder
  config.vm.synced_folder host_folder, remote_folder,
    id: "core",
    :nfs => true,
    :mount_options => ['nolock,vers=3,udp,noatime,actimeo=2,fsc']

  # Config Virtualbox
  config.vm.provider :virtualbox do |vb|

    vb.name = "devbox7"

    # Set server cpus
    vb.customize ["modifyvm", :id, "--cpus", 1]

    # Set server memory
    vb.customize ["modifyvm", :id, "--memory", 2048]

    # Set the timesync threshold to 10 seconds, instead of the default 20 minutes.
    # If the clock gets more than 15 minutes out of sync (due to your laptop going
    # to sleep for instance, then some 3rd party services will reject requests.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]

  end


  #####################
  # Provision scripts #
  #####################

  config.vm.provision "shell", 	path:"base.sh"

  config.vm.provision "shell", path: "./scripts/php.sh", args: [php_timezone]

  config.vm.provision "shell", 	path:"./scripts/nginx.sh", args: [vm_ip_address,remote_folder,vm_hostname]

  config.vm.provision "shell", 	path:"./scripts/mysql.sh"

  config.vm.provision "shell", 	path:"tools.sh"

end
