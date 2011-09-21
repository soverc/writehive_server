#!/usr/bin/perl
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ##
#	mpSql v1.5																		 #
#																					 #
#   mpSql is an easy to use PDO SQL wrapper aimed at making it easier for developers #
#	of all levels to utilize PDO in their perl applications		     				 #
# 																					 #
#   Copyright (C) 2010  MediaPlace (Travis Brown (http://www.travismbrown.com))		 #
#																					 #
#   This program is free software: you can redistribute it and/or modify			 #
#   it under the terms of the GNU General Public License as published by			 #
#   the Free Software Foundation, either version 3 of the License, or				 #
#   (at your option) any later version.												 #
#																					 #
#   This program is distributed in the hope that it will be useful,					 #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of					 #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the					 #
#   GNU General Public License for more details.									 #
#																					 #
#   You should have received a copy of the GNU General Public License				 #
#   along with this program.  If not, see http://www.gnu.org/licenses.			 	 #
#																					 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ##

# Package Name
package mpSql;

# Use Pear Database Objects
use DBI;

# MySQL Server
our($_svr);

# MySQL User
our($_usr);

# MySQL Password
our($_pwd);

# MySQL Database
our($_dbs);

# MySQL Connection String
our($_dbc);

# Class Instantiator
sub new 
{
	my($class) = shift;
	my($self)  = bless({}, $class);
		return($self);
}

# Our Connection Method
sub connect
{
	my($self, $arch, $svr, $usr, $pwd, $dbs) = @_;
	our($_dbc) = DBI->connect(
		"DBI:$arch:dbname=$dbs;host=$svr", # Architecture : mysql or Pg
		$usr, 
		$pwd, 
		{
			RaiseError => 1
		}
	);
	our($_dbs) = $dbs;
}

# Method to run a MySQL Insert Query
sub insert
{
	my($self, $table, $data) = @_;
	my($_c)                  = scalar(keys %{$data});
	my($_i)                  = 1;
	my($_sql)                = "INSERT INTO $table (";

	while (my($k, $v) = each(%{$data})) {
		if ($_i != $_c) { 
			$_sql .= "$k, ";
				$_i++;
		} else {
			$_sql .= "$k";
		}
	}

	$_i    = 1;
	$_sql .= ") VALUES (";

	while (($k, $v) = each(%{$data})) {
		if ($_i != $_c) {
			if ($v =~ m/\QPASSWORD(\E([^<>]*)\Q)\E/i || $v =~ m/\QNOW(\E([^<>]*)\Q)\E/i || $v =~ m/\QCONCAT(\E([^<>]*)\Q)\E/i || $v =~ m/\QDATEDIFF(\E([^<>]*)\Q)\E/i) {
				$_sql .= $v.", ";
			} else {
				$_sql .= $_dbc->quote($v).", ";
			}
			$_i++;
		} else {
			if ($v =~ m/\QPASSWORD(\E([^<>]*)\Q)\E/i || $v =~ m/\QNOW(\E([^<>]*)\Q)\E/i || $v =~ m/\QCONCAT(\E([^<>]*)\Q)\E/i || $v =~ m/\QDATEDIFF(\E([^<>]*)\Q)\E/i) {
				$_sql .= $v;
			} else {
				$_sql .= $_dbc->quote($v);
			}
		}
	}

	$_sql .= ")";

	# Execute the SQL
	# print($_sql); exit;
	
	if ($_dbc->do($_sql)) {
		return($_dbc->{'mysql_insertid'});
	} else {
		return(0);
	}
}

# Method to run a MySQL Insert Ignore Query
sub insert_ignore
{
	my($self, $table, $data) = @_;
	my($_c)                  = scalar(keys %{$data});
	my($_i)                  = 1;
	my($_sql)                = "INSERT IGNORE INTO $table (";

	while (my($k, $v) = each(%{$data})) {
		if ($_i != $_c) { 
			$_sql .= "$k, ";
				$_i++;
		} else {
			$_sql .= "$k";
		}
	}

	$_i    = 1;
	$_sql .= ") VALUES (";

	while (($k, $v) = each(%{$data})) {
		if ($_i != $_c) {
			if ($v =~ m/\QPASSWORD(\E([^<>]*)\Q)\E/i || $v =~ m/\QNOW(\E([^<>]*)\Q)\E/i || $v =~ m/\QCONCAT(\E([^<>]*)\Q)\E/i || $v =~ m/\QDATEDIFF(\E([^<>]*)\Q)\E/i) {
				$_sql .= $v.", ";
			} else {
				$_sql .= $_dbc->quote($v).", ";
			}
			$_i++;
		} else {
			if ($v =~ m/\QPASSWORD(\E([^<>]*)\Q)\E/i || $v =~ m/\QNOW(\E([^<>]*)\Q)\E/i || $v =~ m/\QCONCAT(\E([^<>]*)\Q)\E/i || $v =~ m/\QDATEDIFF(\E([^<>]*)\Q)\E/i) {
				$_sql .= $v;
			} else {
				$_sql .= $_dbc->quote($v);
			}
		}
	}

	$_sql .= ")";

	# Execute the SQL
	if ($_dbc->do($_sql)) {
		return(1);
	} else {
		return(0);
	}
}


sub update 
{
	my($self, $table, $data, $args, $ops) = @_;
	my($_c)                               = scalar(keys %{$data});
	my($_i)                               = 1;
	my($_sql)                             = "UPDATE $table SET ";

	while (my($k, $v) = each(%{$data})) {
		if ($_i != $_c) {
			if ($v =~ m/\QPASSWORD(\E([^<>]*)\Q)\E/i || $v =~ m/\QNOW(\E([^<>]*)\Q)\E/i || $v =~ m/\QCONCAT(\E([^<>]*)\Q)\E/i || $v =~ m/\QDATEDIFF(\E([^<>]*)\Q)\E/i) {
				$_sql .= $k." = ".$v.", ";
			} else {
				$_sql .= $k." = ".$_dbc->quote($v).", ";
			}
			$_i++;
		} else {
			if ($v =~ m/\QPASSWORD(\E([^<>]*)\Q)\E/i || $v =~ m/\QNOW(\E([^<>]*)\Q)\E/i || $v =~ m/\QCONCAT(\E([^<>]*)\Q)\E/i || $v =~ m/\QDATEDIFF(\E([^<>]*)\Q)\E/i) {
				$_sql .= $k." = ".$v;
			} else {
				$_sql .= $k." = ".$_dbc->quote($v);
			}
		}
	}

	if (defined($args)) {
		my($_a) = 1;
		$_sql  .= " WHERE ";

		for $_arg (@$args) {
			$_sql .= $_arg;

			if ($_a != scalar(@$args)) {
				$_sql .= " AND ";
					$_a ++;
			}
		}
	}

	if (defined($ops)) {
		$_o = scalar(@$ops);
		$_x = 1;

		for $_op (@$ops) {
			if ($_x != $_o) {
				$_sql .= " $_op, ";
			} else {
				$_sql .= " $_op";
			}
		}
	}
	
	# Execute the SQL
	if ($_dbc->do($_sql)) {
		return(1);
	} else {
		return(0);
	}
}

sub delete
{
	my($self, $table, $data) = @_;
	my($_c)                  = scalar(keys %$data);
	my($_i)                  = 1;
	my($_sql)                = "DELETE FROM $table WHERE ";

	while (my($k, $v) = each(%$data)) {
		if ($_i != $_c) {
			$_sql .= "$k = ".$_dbc->quote($v)." AND ";
				$_i++;
		} else {
			$_sql .= "$k = ".$_dbc->quote($v);
		}
	}

	# Execute the SQL
	$_dbc->do($_sql);

	# Return true
	return(1);
}

sub select
{
	my($self, $table, $fields, $args, $ops) = @_;
	my(@results);
	my($_c)                               = scalar(@$fields);
	my($_i)                               = 1;
	my($_sql)                             = "SELECT ";

	foreach (@$fields) {
		if ($_i != $_c) {
			$_sql .= "$_, ";
				$_i++;
		} else {
			$_sql .= "$_";
		}
	}

	$_sql .= " FROM $table ";

	if (defined($args)) {
		my($_a) = 1;
		$_sql  .= "WHERE ";

		for $_arg (@$args) {
			$_sql .= $_arg;

			if ($_a != scalar(@$args)) {
				$_sql .= " AND ";
					$_a ++;
			}
		}
	}

	if (defined($ops)) {
		$_o = scalar(@$ops);
		$_x = 1;

		for $_op (@$ops) {
			if ($_x != $_o) {
				$_sql .= " $_op, ";
			} else {
				$_sql .= " $_op";
			}
		}
	}

	# Prepare the SQL for execution
	my($query) = $_dbc->prepare($_sql);

		# Execute the query
		$query->execute();

		# Pipe the results into an array
		while ($row = $query->fetchrow_hashref()) {
			push(@results, $row);
		}

	# Return the resultset
	return(\@results);
}

# Custom SQL (Namely for JOINS)
sub query
{
	my($self, $_sql) = @_;
	
	# Check to see if we have a SELECT statement
	if ($_sql =~ m/SELECT/sim) {
		
		# Prepare the SQL
		my($query) = $_dbc->prepare($_sql);
		
		# Results Array
		my(@results);
		
			# Execute the SQL
			$query->execute();
			
			# Pipe the results into an array
			while ($row = $query->fetchrow_hashref()) {
				
				# Add Hash to the results
				push(@results, $row);
			}
			
			# Return results
			return(\@results);
	} else {
		
		# Execute the Query
		if ($_dbc->do($_sql)) {
			
			# Return Successful
			return(1);
		} else {
			
			# Return Unsuccessful
			return(0);
		}
	}
}

sub quote
{
	my($_self, $_str) = @_;
		return($_dbc->quote($_str));
}

# Return class status
1;