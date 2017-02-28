$script = <<SCRIPT
    locale-gen en_GB.UTF-8
    apt-get --assume-yes update
    apt-get --assume-yes dist-upgrade
    apt-get --assume-yes install git curl

    wget -qO- https://raw.githubusercontent.com/vantage-org/vantage/master/bootstrap | sh

    curl -sSL https://get.docker.com/ | sh
    usermod -aG docker ubuntu

    apt-get --assume-yes autoremove

    ln -s /vagrant /usr/local/vantage/plugins/installed/pg
SCRIPT

Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/xenial64"
    config.vm.provision "shell", inline: $script

    config.vm.network "private_network", ip: "192.168.99.22"
    config.vm.hostname = "pg.vantage.local"
end
