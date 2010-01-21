#!/usr/bin/perl
#
###########################################################################################
# chfe.pl 
# this script QUICKLY (means not always accurate) checks for ports open in a hardcoded subnet. 
# Written by jim80net, blog@jim80.net
# 
# Based on a port check script written by Trent Nguyen, tnguyen@serverbeach.com
#
###########################################################################################
#
use IO::Socket;
#
##### Define some Initial Variables here
#
use vars qw(@ports $ip $timeout $defaultUN);
#
$timeout = 0.25;
# default username
$defaultUN = "beach";
# which ports to check
$chports = $ARGV[1];
@ports = split(',',$chports);
if ($chports == "all") {
	$count = 1;
	$all = 1;
	while ($count <= 65535 ) {
	push(@ports,$count);
	$count ++;
	}	
}
if ($chports == "") {
	$all = 0;
	@ports = (21,22,25,53,80,110,443,2087,3389,8443,23794);
	}	
if ($chports == "default") {
	$all = 0;
	@ports = (21,22,25,53,80,110,443,2087,3389,8443,23794);
	}	
sub checkit {
print "Checking $ip (max scan time $maxtime seconds)...\n";
print "Ports: @ports\n\n";
$notdown = 0; 
foreach $port (@ports) {
        my $foo = IO::Socket::INET->new(
                PeerAddr        => "$ip",
                PeerPort        => $port,
                Proto           => 'tcp',
                Timeout         => 0.25
        );
	if ($notdown == 0) {
		if ($foo) {
        	print " $ip:$port - ";
			print "OK\n";
			$notdown = 1;
			if ($port == 22) {$ssh = 1};
			if ($port == 2087) {$WHM = 1};
			if ($port == 3389) {$rdp = 1};
			if ($port == 8443) {$Plesk = 1};
			if ($port == 23794) {$Innominate = 1};
        close($foo);
        }
	}
}
	open FH,">>results.txt" or die ("Could not create results.txt file");
		if ($notdown == 0) {
		print FH $ip,"\n";
		}
	close FH;
print "##########################\n";
print "\n";
}
	$count = 5;
	while ($count <= 109 ) {
	$IP = "64.34.186." . $count ; 
	push(@list,$IP);
	$count ++;
	}
	$count = 128 ; 
	while ($count <= 254 ) {
	$IP = "64.34.186." . $count ; 
	push(@list,$IP);
	$count ++;
	}
	my $start_run = time();
	my $str = scalar localtime;
	open FH,">>results.txt" or die ("Could not create results.txt file");
		print FH "These IPs are down. This test was started ", $str, "\n";
	close FH;	
	foreach (@list) {
		$ip=$_;
		checkit;
	}
	my $end_run = time();
	my $str = scalar localtime;
		open FH,">>results.txt" or die ("Could not create results.txt file");
		print FH "This test concluded ", $str, "\n";
		my $run_time = $end_run - $start_run;
		print FH "Job took $run_time seconds\n";
	close FH;
