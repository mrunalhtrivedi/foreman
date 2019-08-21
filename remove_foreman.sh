# Remove foreman

echo "############## Current status of Foreman #######################################################################"

systemctl status foreman.service
systemctl status foreman-proxy.service
systemctl status foreman-tasks.service

echo "############## Removing Foreman ################################################################################"
sudo yum -y remove --remove-leaves foreman foreman-installer foreman-proxy

echo "############## Removing files/folder's of foreman ##############################################################"
sudo rm -rf /var/lib/foreman /usr/share/foreman /usr/share/foreman-proxy/logs /etc/foreman /etc/foreman-installer /etc/foreman-proxy
sudo rm /etc/httpd/conf.d/foreman.conf

echo "############## Current status of Foreman should be dead ########################################################"
systemctl status foreman.service
systemctl status foreman-proxy.service
systemctl status foreman-tasks.service

echo "############## Removing Puppet Server and Puppet Agent #########################################################"
systemctl status puppetserver.service
systemctl status puppet.service
sudo yum -y remove --remove-leaves puppet puppetmaster puppet-common puppetmaster-common puppetlabs-release
sudo rm -rf /usr/lib/ruby/vendor_ruby/puppet /usr/share/puppet /var/lib/puppet /etc/puppet
sudo rm /etc/apache2/conf.d/puppet.conf
systemctl status puppetserver.service
systemctl status puppet.service

echo "############## Removing Foreman Metadata #######################################################################"
sudo yum --enablerepo=foreman clean metadata
