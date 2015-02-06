#!/usr/bin/perl

use CGI;
use DBI;
use List::Util 'shuffle';

BEGIN
{
	$cgi = new CGI;
	$key = $cgi->param('key');
	$method = $cgi->param('method');
	print $cgi->header(-status=> '200 OK', -type => 'text/html');
   	open(STDERR, ">&STDOUT");
}

if(!defined $method)
{
	for $rand(1..6)
	{
		@characters = ("A".."Z", "a".."z", "0".."9");
		my $image_name;
		$image_name .= $characters[rand @characters] for 1..24;
		$image_name = $image_name."ZIM";
		$dbh = DBI->connect("DBI:mysql:database=DATABASE;host=localhost", "USERNAME", "PASSWORD") or die "Could not connect";
		my $sqlh = $dbh->prepare("SELECT * FROM captcha WHERE idn = ?");
		$sqlh->execute($rand);
		while (my $row = $sqlh->fetchrow_hashref())
		{
			if($rand =~ "1" || $rand =~ "3" || $rand =~ "5")
			{
				$type_of = "orange";
			}
			if($rand =~ "2" || $rand =~ "4" || $rand =~ "6")
			{
				$type_of = "fish";
			}
			my $sqlh2 = $dbh->prepare("INSERT INTO `captcha_keys` (`name`, `key`) VALUES (?, ?);");
			$sqlh2->execute($type_of, $image_name);
		
			$data = `curl -s 'http://example.com/captcha_easy/${rand}.png'`;
			open($fh, '>', 'captcha/'.$image_name.'.png');
			print $fh $data;
			close $fh;
		}
		$dbh->disconnect();
		
		push (@full_list, "<img src='captcha/".$image_name.".png' style='background-color:blue;width:50px;height:50px;border:1px solid black; display:inline-block;' id='$image_name' class='captcha_imgs' onClick='captcha_click(this.id)'>");
	}
	print shuffle @full_list;
exit;
}