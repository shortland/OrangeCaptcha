#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use DBI;
use List::Util 'shuffle';

sub print_images {
	my (@types) = @_;
	my $dbh = DBI->connect("DBI:mysql:database=dbname;host=localhost", "root", "password") or die "Could not connect";
	my @full_list;
	foreach my $type (@types) {
		my $sqlh = $dbh->prepare("SELECT * FROM `captcha` WHERE `type` = ? ORDER BY RAND() LIMIT 3");
		$sqlh->execute($type);
		while (my $row = $sqlh->fetchrow_hashref()) {
			my @characters = ("A".."Z", "a".."z", "0".."9");
			my $random;
			$random .= $characters[rand @characters] for 1..24;
			my $sqlh2 = $dbh->prepare("INSERT INTO `captcha_keys` (`name`, `key`, `imgid`, time) VALUES (?, ?, ?, ?);");
			$sqlh2->execute($row->{type}, $random, $row->{idn}, time);
			push (@full_list, "<img src='" . $row->{base64img} . "' id='$random' class='captcha_imgs' onClick='captcha_click(this.id)'> ");
		}
		$dbh->disconnect();
	}
	return shuffle @full_list;
}

BEGIN {
	my $cgi = CGI->new;
	print $cgi->header(-status=> '200 OK', -type => 'text/html');
   	open(STDERR, ">&STDOUT");
	my @types = ("orange", "fish");
   	print print_images(@types);
}