#!/usr/bin/perl

use strict;
use warnings;
use Path::Tiny;

# # this is only a wrapper for Pandoc.
# # You may need to install Pandoc on your system separately.
# # https://pandoc.org/installing.html
# use Pandoc;             # check at first use
# use Pandoc 1.12;        # check at compile time
# Pandoc->require(1.12);  # check at run time

sub readDir {
	my ($dirname, $newDirname) = @_;
	opendir my $dir, $dirname or die "Cannot open directory: $!";
	my @files = readdir $dir;
	closedir $dir;
	for my $file (@files) {
		if ($file =~ m/\.rtf$/) {
			if (rtfTotxt($dirname, $file)) {
				$file =~ s/\.rtf//g;
				print "Cleaned file: " . $file ."\n" . writeFile($newDirname . "/" . "new_" . $file . ".txt", remGarb(readFile($dirname . "/" . $file . ".txt")));
			}
		}
	}
	return "Done processing.\n";
}

sub rtfTotxt {
	my ($dirname, $fname) = @_;
	print "Converting from .rtf to .txt...\n";

	#if OS is MAC use textutil...
	system("textutil -convert txt $dirname/$fname");

	#otherwise we need to use Pandoc...
	#not working... only mac for now using textutil :}
	# my $nfname = $fname =~ s/\.rtf/\.txt/gr; #/
	# die $nfname."\n";
	# pandoc->run($dirname . "/" . $fname, -o => $dirname . "/" . $nfname);

	print "Done converting.\n";
	return 1;
}

sub writeFile {
	my ($fname, $data) = @_;
	path($fname)->spew($data);
	return "Done cleaning, created file at new location: $fname\n\n";
}

sub remGarb {
	my ($data) = @_;
	#remove unecessary stuff about answer difficulty 
	$data =~ s/DIF:\t\w+\t\w+:\t\d+\.?\d+\s*\|*\s*\d*\.?\d*\s*\nOBJ:\t[\S ]+\t*\n*MSC:\t[\S ]+//mg;
	#remove all tabs... mostly the ones before questions
	$data =~ s/\t//gm;
	#add space after multiple choice option
	$data =~ s/^(a|b|c|d)\.\s*\n/$1\. /gm;
	#add additional lines to easily differentiate between answer/question correspondence.
	$data =~ s/^\n\n^ANS:(\w)\n$/\nANS: $1\n\n\n/gm;
	#add space after question #
	$data =~ s/^(\d+)\./$1\. /gm;
	return $data;
}

sub readFile {
	my ($fname) = @_;
	my $fraw = path($fname)->slurp;
	return $fraw;
}

BEGIN {
	my $dirname = "RawQuestions";
	my $newDirname = "CleanedQuestions";
	print readDir($dirname, $newDirname);
}