#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use DBI;

sub check_key {
	my ($key) = @_;
	my $dbh = DBI->connect("DBI:mysql:database=dbname;host=localhost", "root", "password") or die "Could not connect";
	my $sqlh = $dbh->prepare("SELECT `name` FROM `captcha_keys` WHERE `key` = ?");
	$sqlh->execute($key);
	if (($sqlh->fetchrow_array())[0] !~ "orange") {
		return 1;
	}
}

BEGIN {
	my $cgi = CGI->new;
	print $cgi->header(-status => '200 OK', -type => 'text');
	my $false = 0;
	foreach my $c ($cgi->param("captcha1"), $cgi->param("captcha2"), $cgi->param("captcha3")) {
		$false = 1 if check_key($c);
	}
	if ($false) {
		print "Error";
	}
	else {
		print "Success";
	}
}