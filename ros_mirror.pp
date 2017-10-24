import 'mirror'

include apt

class { 'unattended_upgrades':
  auto => { 'reboot' => true },
}

package { 'git':
  ensure => present
}

package { 'apt-mirror':
  ensure => present,
#  before => File['/mirror/packages.ros.org/mirror.list']
}

file {'/mirror/packages.ros.org/mirror.list':
  ensure => file,
  mode => 664,
  owner => 'rosmirror',
  source => 'puppet:///modules/mirror/mirror.list',
}

file {['/mirror', '/mirror/packages.ros.org', '/mirror/packages.ros.org/mirror', '/mirror/packages.ros.org/mirror/packages.ros.org', '/mirror/packages.ros.org/mirror/packages.osrfoundation.org', '/mirror/wiki.ros.org', '/mirror/docs.ros.org']:
  ensure => directory,
  mode   => 644,
  owner  => 'rosmirror',
  before => [ Apache::Vhost['packages.ros.org.mirror'],
              File['/mirror/packages.ros.org/mirror.list'] ],
}

user {'rosmirror':
  ensure => present,
  before => File['/mirror/packages.ros.org'],
}


cron { 'docs.ros.org_mirror':
  ensure => present,
  command => "rsync -aqz rsync.osuosl.org::ros_docs_mirror /mirror/docs.ros.org --bwlimit=200 --copy-unsafe-links --delete",
  user => 'rosmirror',
  minute => [fqdn_rand(59)],
  hour => [fqdn_rand(23)],
}

cron { 'wiki.ros.org_mirror':
  ensure => present,
  command => "rsync -aqz rsync.osuosl.org::ros_wiki_mirror /mirror/wiki.ros.org --bwlimit=200 --copy-unsafe-links --delete",
  user => 'rosmirror',
  minute => [fqdn_rand(59)],
  hour => [fqdn_rand(23)],
}

cron { 'packages.ros.org_mirror':
  ensure => present,
  command => "apt-mirror /mirror/packages.ros.org/mirror.list",
  user => 'rosmirror',
  minute => [fqdn_rand(59)],
  hour => [fqdn_rand(23)],
}

class { 'apache': }

apache::vhost{'docs.ros.org.mirror':
  vhost_name => "*",
  port => '80',
  docroot => '/mirror/docs.ros.org',
  serveraliases => ['*docs.ros.org*',],
}


apache::vhost{'wiki.ros.org.mirror':
  vhost_name => "*",
  port => '80',
  docroot => '/mirror/wiki.ros.org',
  override => 'All',
  serveraliases => ['*wiki.ros.org*',],
}

apache::vhost{'packages.ros.org.mirror':
  vhost_name => "*",
  port => '80',
  docroot => '/mirror/packages.ros.org/mirror/packages.ros.org',
  serveraliases => ['*packages.ros.org*',],
}

apache::vhost{'packages.osrfoundation.org.mirror':
  vhost_name => "*",
  port => '80',
  docroot => '/mirror/packages.ros.org/mirror/packages.osrfoundation.org',
  serveraliases => ['*packages.osrfoundation.org*',],
}

apache::mod { 'headers': }

# for testing
host { 'localhost':
  ip => '127.0.0.1',
  host_aliases => ['docs.ros.org.example.com', 'wiki.ros.org.example.com', 'packages.ros.org.example.com',],
}


class {'rsync::server': }

rsync::server::module{'mirrorlogs':
  path => '/var/log/apache2',
  hosts_allow => ['web1.osuosl.org', 'ros.osuosl.org', 'localhost'],
}
