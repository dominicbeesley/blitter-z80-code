#!/usr/bin/perl

use strict;
use Device::SerialPort;
use Errno qw( EAGAIN );
use Time::HiRes qw(usleep time);

my $socket=new Device::SerialPort("/dev/ttyS13");
$socket->baudrate(38400);
$socket->parity('none');
$socket->databits(8);
$socket->stopbits(1); 
$socket->handshake("rts"); 
$socket->write_settings || die "Cannot write port settings";



# when expects a function code and an array of parameter bytes, sends FN, LEN, bytes, CKSUM
sub SEND($$) {
	my ($fn, $bytes) = @_;

	my $cksum = $fn + scalar(@{$bytes}) + sum($bytes);
	my $res = pack("C C C*", $fn, scalar @$bytes, @$bytes).chr((-$cksum) & 0xFF);
	
	map { printf "%02X ", $_; } unpack("C*", $res);
	print "\n";

	while (!defined($socket->write($res)) && $! == EAGAIN)
    {
     # select(undef,undef,undef,1/1000);
    }

}

sub sum($) {
	my ($arr) = @_;
	my $r = 0;
	map { $r += $_; } @{$arr};
	return $r;
}

sub SENDEX($$) {
	my ($fn, $bytes) = @_;
	SEND($fn, $bytes);

	my $fn2 = raw_read_char();

	$fn2 == $fn or SYNCERR(sprintf "Expecting FN=%02X, got %02X\n", $fn, $fn2) or return;

	my $len = raw_read_char();
	my $data = raw_read_char_n($len);

	length($data) == $len or SYNCERR("Truncated data") or return;

	my $ck = raw_read_char();
	my @a = unpack("C*", $data);

	my $ck2 = (-($fn2 + sum(\@a) + $len)) & 0xFF;

	($ck2 == $ck) or SYNCERR(sprintf "Expecting CK=%02X, got %02X\n", $ck2, $ck) or return;

}

sub SYNCERR($) {
	my ($err) = @_;

	my $t = time();
	while (time() < $t + 2) {
		raw_read_char();
	}
	
	return 0;
}

sub raw_read_char()
{
  my ($d,$l)=("",0);


    my $ts = time();
    while (!$l) 
    {
      ($l,$d)=$socket->read(1);
      my $x = time()-$ts;
      if ($x > 0.1) {
        usleep(10000);
        if ($x > 1.5) {
        	print "TO\n";
        	return "";
        }
      }
    }
	return(ord($d));
}

sub raw_read_char_n($) {
  my ($n) = @_;

  if (!$n) {
  	return "";
  }

  my ($d,$l)=("",0);


    my $ts = time();
    while (!$l) 
    {
      ($l,$d)=$socket->read($n);
      my $x = time()-$ts;
      if ($x > 0.1) {
        usleep(10000);
        if ($x > 1.5) {
        	print "TO\n";
        	return "";
        }
      }
    }
 
  return $d;

}

sub send_mo7($) {

	my ($fn) = @_;

	open(my $fh, "<:raw:", $fn) or die "Cannot open $fn for input $!";

	my $l = 0;
	my $ad = 0x7C00;
	while ($l < 2048) {
		my $buf;
		my $x = read($fh, $buf, 40);
		if ($x) {
			my @d = ( 0, $ad % 256, $ad >> 8 );
			push @d, unpack("C*", $buf);
			SENDEX(0xFD, \@d);
		} else {
			last;
		}
		$l += $x;
		$ad += $x;
	}

	close($fh);
}

opendir DIR, "." or die "Cannot open directory . $!";
my @allfiles = grep /\.mo7/, readdir(DIR);
closedir(DIR);

my $prev = -1;
while (1) {
	my $next;
	do {
		$next = int rand @allfiles;
	} while ($next == $prev);
	print "$next\n";
	send_mo7(@allfiles[$next]);
	$prev = $next;
}

