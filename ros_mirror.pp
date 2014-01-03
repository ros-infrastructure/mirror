import 'mirror'

package { 'git':
  ensure => present
}

package { 'rsync':
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
  command => "rsync -aqz docs.ros.org::mirror /mirror/docs.ros.org --bwlimit=200 --copy-unsafe-links --delete",
  user => 'rosmirror',
  minute => [12],
  hour => [0],
}

cron { 'wiki.ros.org_mirror':
  ensure => present,
  command => "rsync -aqz wiki.ros.org::wiki_mirror /mirror/wiki.ros.org --bwlimit=200 --copy-unsafe-links --delete",
  user => 'rosmirror',
  minute => [12],
  hour => [2],
}

cron { 'packages.ros.org_mirror':
  ensure => present,
  command => "apt-mirror /mirror/packages.ros.org/mirror.list",
  user => 'rosmirror',
  minute => [12],
  hour => [3],
}

class { 'apache': }

apache::vhost{'docs.ros.org.mirror':
  vhost_name => "*",
  port => '80',
  docroot => '/mirror/docs.ros.org',
  serveraliases => ['docs.ros.org*',],
}


apache::vhost{'wiki.ros.org.mirror':
  vhost_name => "*",
  port => '80',
  docroot => '/mirror/wiki.ros.org',
  serveraliases => ['wiki.ros.org*',],
}

apache::vhost{'packages.ros.org.mirror':
  vhost_name => "*",
  port => '80',
  docroot => '/mirror/packages.ros.org/mirror/packages.ros.org',
  serveraliases => ['packages.ros.org*',],
}

apache::vhost{'packages.osrfoundation.org.mirror':
  vhost_name => "*",
  port => '80',
  docroot => '/mirror/packages.ros.org/mirror/packages.osrfoundation.org',
  serveraliases => ['packages.osrfoundation.org*',],
}


# for testing
host { 'localhost':
  ip => '127.0.0.1',
  host_aliases => ['docs.ros.org.example.com', 'wiki.ros.org.example.com', 'packages.ros.org.example.com',],
}
