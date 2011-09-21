#!/usr/bin/perl -w

use strict;
use POSIX	qw(setsid);
use Socket	qw(:DEFAULT :crlf);
use IO::Socket;
use lib('/home/oneighty/library');
use JsonRpcParser;
# use DateTime;

	sub daemonize
	{
		open(STDIN,  '/dev/null')                                or die("Unable to read input: $!");
		open(STDOUT, '>>/home/oneighty/logs/jsonrpc-access.log') or die("Unable to write logs: $!");
		open(STDERR, '>>/home/oneighty/logs/jsonrpc-error.log')  or die("Unable to write logs: $!");
			my($_pid) = fork or die("Unable to fork: $!");
				exit if($_pid);
					setsid or die("Unable to create session: $!");
						&logpid($_pid) or die("Unable to log PID: $!");
	}
	
	sub logpid
	{
		my($_pid) = shift;
			open(PID, '>>/home/oneighty/logs/jsonrpc-pid.log');
				print(PID "$_pid\n");
			close(PID);
	}

	# &daemonize;

	while (1) {
		my($_parser)  = JsonRpcParser->new;
		my($_ip)      = '184.106.212.246';
		my($_port)    = 1988;
		my($_server)  = new IO::Socket::INET(
			Proto     => 'tcp', 
			LocalAddr => $_ip, 
			LocalPort => $_port, 
			Listen    => SOMAXCONN, 
			Reuse     => 1
		);
	
		while (my($_client) = $_server->accept) {
			$_client->autoflush(1);
				
				my(%_request) = ();
				my(%_data);
				
				{
					local $/ = Socket::CRLF;
	
					while (<$_client>) {
						chomp;
		
						if (/\s*(\w+)\s*([^\s]+)\s*HTTP\/(\d.\d)/) {
							$_request{METHOD}       = uc($1);
							$_request{URL}          = $2;
							$_request{HTTP_VERSION} = $3;
						}
		
						elsif (/:/) {
							my($_type, $_val) = split(/:/, $_, 2);
							$_type            =~ s/^\s+//;
			
							foreach($_type, $_val) {
								s/^\s+//;
								s/\s+$//;
							}
		
							$_request{lc($_type)} = $_val;
						}
		
						elsif (/^$/) {
							read($_client, $_request{CONTENT}, $_request{'content-length'})
								if (defined($_request{'content-length'}));
							last;
						}
					}
				}
				
				if ($_request{METHOD} eq 'GET') {
					if ($_request{URL} =~ /(.*)\?(.*)/) {
						$_request{URL}     = $1;
						$_request{CONTENT} = $2;
					} else {
						%_data = ();
					}
	
					$_data{"_method"} = "GET";
				}
	
				elsif ($_request{METHOD} eq 'POST') {
					$_data{"_method"} = "POST";
				} else {
					$_data{"_method"} = "ERROR";
				}
				
				if ($_request{METHOD} eq 'POST') {
					print($_client "HTTP/1.0 200 OK", $CRLF);
					print($_client "Content-type:  application/json", $CRLF);
					print($_client $CRLF);
					print($_client $_parser->parse($_request{CONTENT}));
						
						$_data{"_status"} = "200";
				}
	
				if ($_request{METHOD} eq 'GET') {
					print($_client "HTTP/1.0 200 OK", $CRLF);
					print($_client "Content-type: application/json", $CRLF);
					print($_client $CRLF);
					print($_client $_parser->map);
						
						$_data{"_status"} = "200";
				}
			
			open(LOG, '>>/home/oneighty/logs/jsonrpc-activity.log');
				# my($_dt) = DateTime->now(
				#	time_zone => 'America/New_York'
				# );
				my($_time) = localtime;
				
				print(LOG "REQUEST [".$_time."]\n");
					
					while (my($_k, $_v) = each(%_request)) {
						print(LOG "[$_k] => $_v\n");
					}
				
				print(LOG "\nDATA [".$_time."]\n");
				
					while (my($_k, $_v) = each(%_data)) {
						print(LOG "[$_k => $_v]\n");
					}
				
				print(LOG "\n\n");
			close(LOG);
			}
	}
