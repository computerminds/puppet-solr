class solr::config {
  file { "/opt/solr":
    ensure => directory,
    owner => "tomcat6",
    group => "tomcat6",
  }

  augeas { "solr config":
    changes => [
      "set /files/etc/default/tomcat6/JAVA_OPTS '\"-Djava.awt.headless=true -Dsolr.solr.home=/opt/solr/config -Dsolr.data.dir=/opt/solr/data -Xmx128m -XX:+UseConcMarkSweepGC\"'",
    ],
    require => [ File["/opt/solr/config"], File["/opt/solr/data"] ],
    notify => Service["tomcat6"],
  }

  file { "/opt/solr/data":
    ensure => directory,
    owner => "tomcat6",
    group => "tomcat6",
  }

  # This is so hardcoded to backpack that it's not even funny.
  file { "/opt/solr/config":
    ensure => directory,
    source => "/backpacktv/config/solr",
    recurse => true,
    notify => Service["tomcat6"],
  }

  file { "/etc/tomcat6/server.xml":
    ensure => present,
    source => "puppet:///modules/solr/etc/tomcat6/server.xml",
    notify => Service["tomcat6"],
  }
}
