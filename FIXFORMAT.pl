#!/usr/bin/perl

use strict;
use warnings;
use Path::Tiny;

sub read_dir {
	my ($dir_name, $new_path) = @_;
	opendir my $dir, $dir_name or die "Cannot open directory: $!";
	my @files = readdir $dir;
	closedir $dir;
	for my $file (@files) {
		if ($file =~ m/\.txt$/) {
			cleanse_file($dir_name."/".$file, $new_path);
		}
	}
	return "Done processing.\n";
}

sub write_file {
	my ($fname, $data) = @_;
	path($fname)->spew($data);
	return "Done cleaning, created file at new location: $fname\n\n";
}

sub read_file {
	my ($fname) = @_;
	my $fraw = path($fname)->slurp;
	return $fraw;
}

sub append_file {
	my ($fname, $data) = @_;
	path($fname)->append($data);
}

sub cleanse_file {
	my ($f_full_path, $new_path) = @_;
	write_file($new_path.$f_full_path, "FIXED\n\n");
	my $read = read_file($f_full_path);
	my @big_arr = split(/\n/, $read);
	my @temp_arr = ("a", "b", "c", "d", "Z");
	for (my $i = 0; $i < scalar @big_arr; $i++) {
		if ($big_arr[$i] =~ /^(\d)/) {
			my $temp_c = 0;
			foreach my $val (@temp_arr) {
				if ($temp_c eq 4) {
					append_file($new_path.$f_full_path, $val . "\n") unless length $val eq 1;
					last;
				}
				append_file($new_path.$f_full_path, $val . "\n") unless length $val eq 1;
				$temp_c++;
			}
			append_file($new_path.$f_full_path, "\n");
			append_file($new_path.$f_full_path, $big_arr[$i] . "\n");
		}
		if ($big_arr[$i] =~ /^a/) {
			@temp_arr[0] = $big_arr[$i];
		}
		if ($big_arr[$i] =~ /^b/) {
			@temp_arr[1] = $big_arr[$i];
		}
		if ($big_arr[$i] =~ /^c/) {
			@temp_arr[2] = $big_arr[$i];
		}
		if ($big_arr[$i] =~ /^d/) {
			@temp_arr[3] = $big_arr[$i];
		}
		if ($big_arr[$i] =~ /^ANS:/) {
			@temp_arr[4] = $big_arr[$i];
		}
	}
}

BEGIN {
	my $dir_name = "CleanedQuestions";
	my $new_path = "EvenCleaner/";
	print read_dir($dir_name, $new_path);
}