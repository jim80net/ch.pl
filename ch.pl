#!/usr/bin/perl
#
###########################################################################################
# ch.pl v 0.2
# this script checks for ports (defined below) and prompts user to open the pertinent ones
# Written by jim80net, blog@jim80.net
# 
# Based on a port check script written by Trent Nguyen, tnguyen@serverbeach.com
#
#  To Do:
# 	 need to correct variable scope
#
# Revision history:
# - Forthcoming as changes are made. 
# 
###########################################################################################
#
use IO::Socket;
use FindBin '$RealBin';

#
##### Define some Initial Variables here
#
use vars qw(@ports $ip $timeout $defaultUN);
#
require "$RealBin/etc/config.pl";

$timeout = 0.15;
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
	@ports = (21,22,25,53,80,110,139,143,389,443,465,636,902,903,993,995,1433,1581,2087,3306,3389,8443,23794);
	}	
if ($chports == "default") {
	$all = 0;
	@ports = (21,22,25,53,80,110,139,143,389,443,465,636,902,903,993,995,1433,1581,2087,3306,3389,8443,23794);
	}	
#####
##First header
print "\n";
print "##########################\n";
$os = $^O;
print "Running in: $os - ";
   	 if ($os eq "linux") {print "Using: OpenSSH, rdesktop, firefox \n"};
   	 if ($os eq "darwin") {print "Using: OpenSSH, tsclient, open \n"};
   	 if ($os eq "MSWin32") {print "Using: putty, firefox \n"};
#Resolve IP if hostname given, also, ensure a hostname is given
if ($ARGV[0]) {
	if ($ARGV[0] !=~ /^([\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3})$/) {
    		print "\n";
   		if ($os eq "linux") {print `host $ARGV[0]`; $foundit = $?};
 		if ($os eq "darwin") {print `host $ARGV[0]`; $foundit = $?};
   		if ($os eq "MSWin32") {print `nslookup $ARGV[0]`; $foundit = $?};
	# process anyways if user supplied IP address
	if ($ARGV[0] =~ /^([\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3})$/) {
		$foundit = 0
		}
	print "##########################\n";
 	print "\n";
	}
        $ip = $ARGV[0];
        $nports = @ports;
        $maxtime = $timeout * $nports;
} 

else { # last chance to try something else
print "Hostname or IP to check?[enter to Quit]\n";
chomp($ip = <STDIN>);}

if ($foundit != 0) {
	print "\nERROR: Cannot find scan target \n";
	exit 2};

# Handles for notdown events
sub notdown {
if ($ssh == 1) {
	print "\n....................\n.   SSH CAPABLE    .\n....................\n\n";
	print "SSH?[y/N] ";
	chomp($doit = <STDIN>);
		if ($doit eq "y") {
			print "Connecting to $ip\n";
			print "Username to connect as?[$defaultUN]\n";
			chomp($unamein = <STDIN>);
			$username = $unamein || $defaultUN;
   			if ($os eq "linux") {$cmd = "ssh $username\@$ip"};
			if ($os eq "darwin") {$cmd = "ssh $username\@$ip"};
   	 		if ($os eq "MSWin32") {$cmd = "C:/Progra~1/PuTTY/putty.exe -ssh $username\@$ip"};
			system $cmd;
		}
}
if ($rdp == 1) {
	print "\n....................\n.   RDP CAPABLE    .\n....................\n\n";
	print "Start RDP session?[y/N] ";
	chomp($doit = <STDIN>);
		if ($doit eq "y") {
			print "Connecting to $ip\n";
			if ($os eq "linux") {
				print "Username to connect as?[$defaultUNMicrosoft]\n";
				chomp($unamein = <STDIN>);
				$username = $unamein || $defaultUNMicrosoft; 
				print "Password? [Enter to prompt]\n";
				chomp($Passwordin = <STDIN>);
				$Password = $Passwordin || '-' ; 
				print "Fullscreen? [y/N]";
				chomp($fullscreenin = <STDIN>);
					$screen = '-g 1260x800 ';
					if ($fullscreenin eq "n") {$screen = '-g 1260x800 '};
					if ($fullscreenin eq "y") {$screen = '-f '};
				print "Attach to console? [y/N]";
				chomp($console = <STDIN>);
					if ($console eq "y") {$consolo = '-0 '}
				$cmd = "rdesktop $screen$consolo -r sound:remote -u $username -p $Password -a 16 $ip &"};
			if ($os eq "darwin") {print "PSYCH!!! No RDP support on Macs quite yet (Im working on it, I promise)\n"};
			if ($os eq "MSWin32") {$cmd = "mstsc /admin /v:$ip"};
			system $cmd;
		}
}
if ($Tivoli == 1) {
	print "\n......................\n. Tivoli Client detected .......................\n\n";
	print "Open in browser window?[y/N] ";
	chomp($doit = <STDIN>);
		if ($doit eq "y") {
			print "starting Tivoli Client session\n";
   			if ($os eq "linux") {$cmd = "firefox http://$ip:1581 &"};
   			if ($os eq "darwin") {$cmd = "open http://$ip:1581 &"};
   	 		if ($os eq "MSWin32") {$cmd = "C:/Progra~1/Mozill~1/firefox.exe http://$ip:1581"};
			system $cmd;
		}
}
if ($WHM == 1) {
	print "\n....................\n.   WHM CAPABLE    .\n....................\n\n";
	print "Open in browser window?[y/N] ";
	chomp($doit = <STDIN>);
		if ($doit eq "y") {
			print "starting WHM session\n";
   			if ($os eq "linux") {$cmd = "firefox https://$ip:2087 &"};
   			if ($os eq "darwin") {$cmd = "open https://$ip:2087 &"};
   	 		if ($os eq "MSWin32") {$cmd = "C:/Progra~1/Mozill~1/firefox.exe https://$ip:2087"};
			system $cmd;
		}
}
if ($Plesk == 1) {
	print "\n......................\n.   Plesk CAPABLE    .\n......................\n\n";
	print "Open in browser window?[y/N] ";
	chomp($doit = <STDIN>);
		if ($doit eq "y") {
			print "starting Plesk session\n";
   			if ($os eq "linux") {$cmd = "firefox https://$ip:8443 &"};
   			if ($os eq "darwin") {$cmd = "open https://$ip:8443 &"};
   	 		if ($os eq "MSWin32") {$cmd = "C:/Progra~1/Mozill~1/firefox.exe https://$ip:8443"};
			system $cmd;
		}
}
if ($Innominate == 1) {
	print "\n......................\n. Innominate Firewall detected .\n......................\n\n";
	print "Open in browser window?[y/N] ";
	chomp($doit = <STDIN>);
		if ($doit eq "y") {
			print "starting Innominate session\n";
   			if ($os eq "linux") {$cmd = "firefox https://$ip:23794 &"};
   			if ($os eq "darwin") {$cmd = "open https://$ip:23794 &"};
   	 		if ($os eq "MSWin32") {$cmd = "C:/Progra~1/Mozill~1/firefox.exe https://$ip:23794"};
			system $cmd;
		}
}
#formatting
print "\n";
exit 0
}
sub checkit {
print "Checking $ip (max scan time $maxtime seconds)...\n";
print "Ports: @ports\n\n";
foreach $port (@ports) {
        my $foo = IO::Socket::INET->new(
                PeerAddr        => "$ip",
                PeerPort        => $port,
                Proto           => 'tcp',
                Timeout         => $timeout
        );
        if ($foo) {
        	print "  $ip:$port - ";
                print "OK\n";
		$notdown = 1;
		if ($port == 22) {$ssh = 1};
		if ($port == 1581) {$Tivoli = 1};
		if ($port == 2087) {$WHM = 1};
		if ($port == 3389) {$rdp = 1};
		if ($port == 8443) {$Plesk = 1};
		if ($port == 23794) {$Innominate = 1};
                close($foo);
        } 
	#else {
	#	if ($all == "") {
        #	printf ("%15s:%-5d\t",$ip,$port);
        #       print "nope\n";
	#	}
        #}
}
print "##########################\n";
print "\n";
if ($notdown == 1) {notdown};
}
checkit;
if ($notdown == 0) {
	print "\n......................\n                          Server does not appear to be online.\n" ;
		print  " 0 to check until it responds, " ;
		print " or specify the number of repetitions.\n [Enter to Quit]\n......................\n\n";
		chomp($times = <STDIN>);
		$count = 1;
			if ($times eq "0") {
				while ($notdown == 0) { 
				print "sleeping for 2 seconds....\n";
				sleep 2;
				print "##########################\n";
				print "Pass $count of $times\n";
				checkit;
				$count ++;
				}
			}
			else {
				while ($count <= $times) { 
				print "sleeping for 2 seconds....\n";
				sleep 2;
				print "##########################\n";
				print "Pass $count of $times\n";
				checkit;
				$count ++;
				}
				
			}
}       
