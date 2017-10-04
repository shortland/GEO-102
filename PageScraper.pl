#!/usr/bin/perl

use strict;
use warnings; 

my $baseURL = "http://sappho.eps.mcgill.ca/~olivia/UPE/Norton_Publishing/";
my $pageData = `curl -s "$baseURL"`;

my @pages = ($pageData =~ m/<li><a href="[\w\d]+\.rtf">\s?(\w+)/g);

foreach my $page (@pages) {
	print "Getting page: $page\n";
	`curl "$baseURL/$page.rtf" > "Questions/$page.rtf"`;
}