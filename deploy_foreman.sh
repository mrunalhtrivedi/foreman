#Script to install Foreman

echo "##############   Changing SELinux to permissive ################################################################"
sudo setenforce permissive
sudo sed -i 's/SELINUX=disabled/SELINUX=permissive/g' /etc/selinux/config /etc/selinux/config
sudo grep SELINUX= /etc/selinux/config

echo "##############   Metadata of Foreman cleanup/ If its previously installed ######################################"
sudo yum --enablerepo=foreman clean metadata
sudo yum clean metadata

echo "##############   Installing Git/ZSH/TMUX #######################################################################"
sudo yum -y install git zsh tmux

echo "##############   Installing Puppet & NTP module ################################################################"
sudo yum -y install https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
sudo puppet module install puppetlabs/ntp

echo "##############   Installing latest Epel ########################################################################"
sudo yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

echo "##############   Installing Foreman Insatller/foreman-vmware ###################################################"
sudo yum -y install https://yum.theforeman.org/releases/1.22/el7/x86_64/foreman-release.rpm
sudo yum -y install foreman-installer
sudo foreman-installer

echo "##############   Firewall Configuration  #######################################################################"

echo "##############   Enabling Firewall #############################################################################"
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo systemctl status firewalld
sudo firewall-cmd --permanent --add-port=53/tcp
sudo firewall-cmd --permanent --add-port=67-69/udp
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --permanent --add-port=3306/tcp
sudo firewall-cmd --permanent --add-port=5910-5930/tcp
sudo firewall-cmd --permanent --add-port=5432/tcp
sudo firewall-cmd --permanent --add-port=8140/tcp
sudo firewall-cmd --permanent --add-port=8443/tcp
sudo firewall-cmd --reload

echo "##############   Reset password for admin  #####################################################################"
sudo foreman-rake permissions:reset username=admin password='defaultforeman'

echo "##############   Checking web locally ##########################################################################"
sudo curl https://localhost:443

echo "############## Current status of Foreman/Puppet ################################################################"
systemctl status foreman.service
systemctl status foreman-proxy.service
systemctl status foreman-tasks.service
systemctl status puppetserver.service
systemctl status puppet.service

echo "##############  Testing Puppet agent ###########################################################################"
sudo /opt/puppetlabs/puppet/bin/puppet agent --test
