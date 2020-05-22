ROS Mirror Puppet Manifest
==========================

This repo provides a way to easily mirror the ROS services. 

The machine will need ~ 200 GB of disk space in the /mirror directory and as much bandwidth as you plan to pull. 

This is tested on Ubuntu Xenial LTS (16.04) and Ubuntu Bionic LTS (18.04)

How to Setup
------------

Run the following commands:

```
sudo apt-get update
sudo apt-get install rubygems git
sudo gem install puppet --no-ri --no-rdoc
sudo puppet module install puppetlabs-apt
sudo puppet module install puppetlabs/apache
sudo puppet module install puppetlabs/rsync
sudo puppet module install puppet-unattended_upgrades
git clone https://github.com/ros-infrastructure/mirror.git
cd mirror
sudo puppet apply ros_mirror.pp --modulepath=/etc/puppet/modules:/etc/puppetlabs/code/modules:. # /etc/puppet/modules can be removed after EOL support for puppet 3.x
```

Overnight the sync jobs will run and you can see that they are setup correctly by running:
> sudo crontab -u rosmirror -l

If you want to accelerate the download process you can su to rosmirror and run the cron jobs. '''Make sure to run any of the jobs as user rosmirror''' And please do not remove the throttling so as not to overload the main servers. 



How to Use
----------

The above configuration has setup the mirrors such that on the localhost you can visit wiki.ros.org.example.com or docs.ros.org.example.com or packages.ros.org.example.com initially you will see an empty directory listing. After they mirroring processes have run you will see the mirrors of the sites. 

The apache instance has virtual hosts setup such that it will respond to subdomains which match the ros domains. So the wiki will match anything wiki.ros.org.* and likewise docs.ros.org.* and packages.ros.org.*

To make this easily accessable to your network add a DNS entry for the names wiki.ros.org.myorganization.org which point to the installed server. 

Mailing list
------------

If you are maintaining a mirror please join the mirrors discourse category: http://discourse.ros.org/c/mirrors for both feedback and prompt updates. 

<iframe id="forum_embed"
  src="javascript:void(0)"
  scrolling="no"
  frameborder="0"
  width="900"
  height="700">
</iframe>
<script type="text/javascript">
  document.getElementById('forum_embed').src =
     'https://groups.google.com/a/osrfoundation.org/forum/embed/?place=forum/mirror-admins'
     + '&showsearch=true&showpopout=true&showtabs=false'
     + '&parenturl=' + encodeURIComponent(window.location.href);
</script>
