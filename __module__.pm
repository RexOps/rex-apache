#
# (c) Jan Gehring <jan.gehring@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Apache;

use Rex -feature => ['0.51'];
use Rex::Ext::ParamLookup;
use Rex::Resource::Common;

my $packages = { centos => ["httpd"], };
my $services = { centos => ["httpd"], };

task "setup", make {
  my $os                  = lc operating_system;
  my $package_name        = param_lookup "package", $packages->{$os};
  my $service_name        = param_lookup "service", $services->{$os};
  my $httpd_listen        = param_lookup "listen", 80;
  my $httpd_user          = param_lookup "user", "apache";
  my $httpd_group         = param_lookup "group", "apache";
  my $server_admin        = param_lookup "server_admin", 'root@localhost';
  my $document_root       = param_lookup "document_root", "/var/www/html";
  my $error_log           = param_lookup "error_log", "logs/error_log";
  my $log_level           = param_lookup "log_level", "warn";
  my $cgi_bin             = param_lookup "cgi_bin", "/var/www/cgi-bin";
  my $default_charset     = param_lookup "default_charset", "UTF-8";
  my $httpd_conf_template = param_lookup "httpd_conf_template",
    "templates/$os/httpd/conf/httpd.conf.tpl";

  pkg $package_name, ensure => present;

  file "/etc/httpd/conf.d/httpd.conf",
    content   => template($httpd_conf_template),
    owner     => "root",
    group     => "root",
    mode      => 644,
    on_change => make {
    service $service_name => "restart";
    };

  service $service_name, ensure => running;
};

resource "module", make {
  my $module_name = resource_name;

  my $load_order = param_lookup "order",  99;
  my $ensure     = param_lookup "ensure", "present";

  my $module_file =
    "/etc/httpd/conf.modules.d/${load_order}-${module_name}.conf";

  file $module_file,
    ensure    => $ensure,
    content   => template("templates/$os/etc/httpd/conf.modules.d/module.tpl"),
    owner     => "root",
    group     => "root",
    mode      => 644,
    on_change => make {
    emit changed;
    };
};

resource "vhost", make {
  my $name          = resource_name;
  my $ensure        = param_lookup "ensure", "present";
  my $load_order    = param_lookup "order", 15;
  my $vhost_name    = param_lookup "name";
  my $vhost_ip      = param_lookup "bind", "*";
  my $server_admin  = param_lookup "server_admin", 'webmaster@localhost';
  my $document_root = param_lookup "document_root", '/var/www/html';
  my $error_log     = param_lookup "error_log",
    "/var/log/httpd/${vhost_name}-error.log";
  my $access_log = param_lookup "access_log",
    "/var/log/httpd/${vhost_name}-access.log";
  my $access_log_format = param_lookup "access_log_format", "combined";
  my $vhost_template = param_lookup "template",
    "templates/$os/etc/httpd/conf.d/vhost.tpl";

  my $vhost_file = "/etc/httpd/conf.d/${load_order}-${vhost_name}.conf";

  file $module_file,
    ensure    => $ensure,
    content   => template($vhost_template),
    owner     => "root",
    group     => "root",
    mode      => 644,
    on_change => make {
    emit changed;
    };
};

1;
