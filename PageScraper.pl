#!/usr/bin/perl

use strict;
use warnings; 

my $baseURL = "http://sappho.eps.mcgill.ca/~olivia/UPE/Norton_Publishing/";
my $pageData = `curl -s "$baseURL"`;

my @pages = ($pageData =~ m/<li><a href="[\w\d]+\.rtf">\s?(\w+)/g);

foreach my $page (@pages) {
	$page =~ m/_(ch[0-9]+|int[A-Z])/;
	my $newPageName = $1;
	print "Getting page: $newPageName\n";
	`curl "$baseURL/$page.rtf" > "RawQuestions/$newPageName.rtf"`;
}