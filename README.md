ROS Mirror Puppet Manifest
==========================

This repo provides a way to easily mirror the ROS services. 

The machine will need ~ 100 GB of disk space and as much bandwidth as you plan to pull. 

This is tested on Ubuntu Precise LTS

How to Setup
------------

Run the following commands:

```
sudo apt-get update
sudo apt-get install rubygems git
sudo gem install puppet
sudo puppet module install puppetlabs/apache
git clone https://github.com/ros-infrastructure/mirror.git
cd mirror
sudo puppet apply ros_mirror.pp --modulepath=/etc/puppet/modules:/usr/share/puppet/modules:.
```

Overnight the sync jobs will run and you can see that they are setup correctly by running:
> sudo crontab -l rosmirror

If you want to accelerate the download process you can su to rosmirror and run the cron jobs. '''Make sure to run any of the jobs as user rosmirror''' And please do not remove the throttling so as not to overload the main servers. 



How to Use
----------

The above configuration has setup the mirrors such that on the localhost you can visit wiki.ros.org.example.com or docs.ros.org.example.com or packages.ros.org.example.com initially you will see an empty directory listing. After they mirroring processes have run you will see the mirrors of the sites. 

The apache instance has virtual hosts setup such that it will respond to subdomains which match the ros domains. So the wiki will match anything wiki.ros.org.* and likewise docs.ros.org.* and packages.ros.org.*

To make this easily accessable to your network add a DNS entry for the names wiki.ros.org.myorganization.org which point to the installed server. 
