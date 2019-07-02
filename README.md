# satellite_insights_client

#### Table of Contents

1. [Overview - What is the satellite_insights_client module](#overview)
2. [Module Description - What the insights client does and why it is useful](#module-description)
3. [Setup - The basics of getting started with satellite_insights_client](#setup)
    * [What satellite_insights_client affects](#what-satellite_insights_client-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview
The satellite_insights_client module allows you to easily configure the Red Hat Insights Client service on RHEL hosts using Puppet.

## Module Description

This module automates the registration of RHEL hosts to  Red Hat Insights, a hosted service designed to help you proactively identify and resolve technical issues in Red Hat Enterprise Linux and Red Hat Cloud Infrastructure environments. 
The module can be used in RHEL hosts subscribed directly to the Red Hat CDN, or via Red Hat Satellite 6.
This module wasn't yet tested with Red Hat Satellite 5.

## Setup

### What satellite_insights_client affects

* This module will install the latest `insights-client` rpm package and install cron jobs in either `/etc/cron.hourly/insights-client`, `/etc/cron.daily/insights-client` or `/etc/cron.weekly/insights-client`, depending on how it is configured. Also, a cron will be automatically created in `/etc/cron.monthly` for redundancy.

###Setup Requirements

RHEL hosts need to be subscribed to the Red Hat CDN or Satellite in order to fulfill Red Hat Insights rpm dependencies.



## Usage

This module includes a single puppet class ,`satellite_insights_client`, which you apply to RHEL hosts to enroll them in the Red Hat Insights service.
The default parameters for the class will suffice for most deployments:

```
    class { 'satellite_insights_client':}
```

This will enable the Red Hat Insights service and schedule a hourly cron job for uploading analytics data.

## Reference

###Class: satellite_insights_client
```
Parameters
#
# Change log level, valid options DEBUG, INFO, WARNING, ERROR, CRITICAL. Default DEBUG
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
# Location of the certificate chain for api.access.redhat.com used for Certificate Pinning
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
```

## Limitations

This module has been tested with the following operating systems:
* RHEL 6.x
* RHEL 7.x

## Development

Submit your patches or pull requests to:
GitHub: <https://github.com/sticks23/satellite_insights_client>
