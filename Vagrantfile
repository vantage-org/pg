$script = <<SCRIPT
    locale-gen en_GB.UTF-8
    apt-add-repository ppa:fish-shell/release-2
    apt-get --assume-yes update
    apt-get --assume-yes dist-upgrade
    apt-get --assume-yes install git fish curl
    chsh -s /usr/bin/fish vagrant
    wget -qO- https://raw.githubusercontent.com/vantage-org/vantage/master/bootstrap | sh
    curl -sSL https://get.docker.com/ | sh
    usermod -aG docker vagrant
    ln -s /vagrant /usr/local/vantage/plugins/installed/pg
SCRIPT

Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.provision "shell", inline: $script
end
