<VirtualHost <%= $ip %>:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	ServerName <%= $resource_name %>

	ServerAdmin <%= $server_admin %>
	DocumentRoot <%= $document_root %>

	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog <%= $error_log %>
	CustomLog <%= $access_log %> <%= $access_log_format %>
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
