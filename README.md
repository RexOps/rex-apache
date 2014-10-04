# Simple Apache Module

This is an example Apache module for Rex.

This module consist of 1 task (*setup*) and 2 resources (*vhost* and *module*). This module works with CentOS 7.

## TASKS

* setup

With this task you can setup the apache webserver and configure it.

```perl
use Rex -feature => ['0.54'];

use Apache;

group frontends => "fe[01..10]";

task "setup", sub {
  Apache::setup;
};
```

The *setup* task has some parameters you can define:

* package - the package name to install
* service - the service name to use
* listen - on which port the apache server should listen on
* user - the user for the daemon
* group - the group for the daemon
* server_admin - the ServerAdmin configuration option
* document_root - the base DocumentRoot configuration option
* error_log - the error.log file
* log_level - the log level
* cgi_bin - the path to your cgi scripts
* default_charset - the default charset Apache should use
* httpd_conf_template - if you want to use a custom template

```perl
task "setup", sub {
  Apache::setup {
    listen        => 8080,
    document_root => "/srv/www/htdocs",
  };
};
```

## RESOURCES

* module

With this resource you can manage which module the Apache webserver should load.

```perl
task "setup", sub {
  Apache::setup;

  Apache::module "rewrite",
    ensure => "present";
};
```

If you need to define the load order, you can also set the *order* parameter.

```perl
task "setup", sub {
  Apache::setup;

  Apache::module "rewrite",
    order  => '04',
    ensure => "present";
};
```

* vhost

With this resource you can manage the virtual hosts.

```perl
task "setup", sub {
  Apache::setup;

  Apache::vhost "www.somedomain.tld",
    ensure => "present";
};
```

There are several options you can define here:

* order - the load order
* ip - the ip to use. default: *
* server_admin - the ServerAdmin configuration option
* document_root - the DocumentRoot for this virtual host
* error_log - the error.log file for this virtual host
* access_log - the access.log file for this virtual host
* access_log_format - the log format for this virtual host
* template - if you want to use a custom tempate

```perl
task "setup", sub {
  Apache::setup;

  Apache::vhost "www.somedomain.tld",
    order  => '01',
    ip     => '127.0.0.1',
    ensure => "present";
};
```


