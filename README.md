ROS Mirror Puppet Manifest
==========================

This repo provides a way to easily mirror the ROS services. 

The machine will need ~ 100 GB of disk space and as much bandwidth as you plan to pull. 

How to setup
------------

```
sudo apt-get update
sudo apt-get install rubygems git
sudo gem install puppet
sudo puppet module install puppetlabs/apache
git clone https://github.com/ros-infrastructure/mirror.git
cd mirror
sudo puppet apply ros_mirror.pp --modulepath=/etc/puppet/modules:/usr/share/puppet/modules:.
```
