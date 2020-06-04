# Class: satellite_insights_client
# ===========================
#
# Full description of class satellite_insights_client here.
#
# Parameters
# ----------
#
# Change log level, valid options DEBUG, INFO, WARNING, ERROR, CRITICAL.
# Default DEBUG
#loglevel=DEBUG
# Attempt to auto configure with Satellite server
#auto_config=True
# Change authentication method, valid options BASIC, CERT. Default BASIC
#authmethod=BASIC
# username to use when authmethod is BASIC
#username=
# password to use when authmethod is BASIC
#password=
#base_url=cert-api.access.redhat.com:443/r/insights
# URL for your proxy.  Example: http://user:pass@192.168.100.50:8080
#proxy=
# Location of the certificate chain for api.access.redhat.com used
# for Certificate Pinning
#cert_verify=/etc/insights-client/cert-api.access.redhat.com.pem
#cert_verify=False
#cert_verify=True
# Enable/Disable GPG verification of dynamic configuration
#gpg=True
# Automatically update the dynamic configuration
#auto_update=True
# Obfuscate IP addresses
#obfuscate=False
# Obfuscate hostname
#obfuscate_hostname=False
#
# Authors
# -------
#
# Bogdan Stefan Gavrila <bogdan.gavrila@tolwit.ro>
#
# Copyright
# ---------
#
# Copyright 2019 - Bogdan Stefan Gavrila
#
class satellite_insights_client(
    $log_level = undef,
    $auto_config = 'True',
    $authmethod = undef,
    $username = undef,
    $password = undef,
    $base_url = undef,
    $proxy = undef,
    $cert_verify = undef,
    $gpg = undef,
    $auto_update = undef,
    $obfuscate = undef,
    $obfuscate_hostname = undef,
    $upload_schedule = undef,
){
    if $operatingsystemrelease =~ /^[6].*/ {
	$insightstools = [ 'PyYAML', 'libcgroup', 'libyaml', 'python-backports', 'python-backports-ssl_match_hostname', 'python-cffi', 'python-enum34', 'python-idna', 'python-ipaddress', 'python-ply', 'python-pycparser', 'python-cryptography', 'python-pyasn1', 'python-pysocks', 'python-requests', 'insights-client' ]
    }
    else {
	$insightstools = [ 'PyYAML', 'libcgroup', 'libyaml', 'python-backports', 'python-backports-ssl_match_hostname', 'python-cffi', 'python-enum34', 'python-idna', 'python-ipaddress', 'python-ply', 'python-pycparser', 'python2-cryptography', 'python2-pyasn1', 'python2-pysocks', 'python2-requests', 'insights-client' ]
    }

    package { $insightstools:
      ensure   => latest,
      provider => yum,
    }

    file {'/etc/insights-client/insights-client.conf':
      ensure  => file,
      content => template('satellite_insights_client/insights-client.conf.erb'),
      require => Package['insights-client'],
    }

    file {'/etc/insights-client/insightsupdate.cron':
      ensure  => file,
      mode    => '0777',
      owner   => 'root',
      group   => 'root',
      content => template('satellite_insights_client/insightsupdate.cron.erb'),
      require => Package['insights-client'],
    }

    file {'/etc/cron.monthly/insightsupdate.cron':
      ensure  => file,
      mode    => '0777',
      owner   => 'root',
      group   => 'root',
      content => template('satellite_insights_client/insightsupdate.cron.erb'),
      require => Package['insights-client'],
    }

    file {'/etc/cron.daily/redhat-access-insights':
      ensure  => absent,
      require => Package['insights-client'],
    }

    case $upload_schedule {
        hourly: { file { '/etc/cron.hourly/insights-client':
            ensure  => 'link',
            target  => '/etc/insights-client/insightsupdate.cron',
            require => Package['insights-client'],
        }
        }
        daily: { file { '/etc/cron.daily/insights-client':
            ensure  => 'link',
            target  => '/etc/insights-client/insightsupdate.cron',
            require => Package['insights-client'],
        }
        }
        weekly: { file { '/etc/cron.weekly/insights-client':
            ensure  => 'link',
            target  => '/etc/insights-client/insightsupdate.cron',
            require => Package['insights-client'],
        }}
        default: { file { '/etc/cron.hourly/insights-client':
            ensure  => 'link',
            target  => '/etc/insights-client/insightsupdate.cron',
            require => Package['insights-client'],
        }}
    }
    if ($upload_schedule == 'weekly') {
        file { '/etc/cron.hourly/insights-client':
            ensure => 'absent'
        }
        file { '/etc/cron.daily/insights-client':
            ensure => 'absent'
        }
    }elsif ($upload_schedule == 'daily') {
        file { '/etc/cron.hourly/insights-client':
            ensure => 'absent'
        }
        file { '/etc/cron.weekly/insights-client':
            ensure => 'absent'
        }
    }elsif ($upload_schedule == 'hourly') {
        file { '/etc/cron.weekly/insights-client':
            ensure => 'absent'
        }
        file { '/etc/cron.hourly/insights-client':
            ensure => 'absent'
        }
    }else {
        file { '/etc/cron.weekly/insights-client':
            ensure => 'absent'
        }
        file { '/etc/cron.daily/insights-client':
            ensure => 'absent'
        }
    }
    exec { '/usr/bin/insights-client --register':
        creates => '/etc/insights-client/.registered',
        unless  => '/usr/bin/test -f /etc/insights-client/.unregistered',
        require => Package['insights-client']
    }
}
