
BEGIN {
    unless ("A" eq pack('U', 0x41)) {
	print "1..0 # Unicode::Collate " .
	    "cannot stringify a Unicode code point\n";
	exit 0;
    }
    if ($ENV{PERL_CORE}) {
	chdir('t') if -d 't';
	@INC = $^O eq 'MacOS' ? qw(::lib) : qw(../lib);
    }
}

use strict;
use warnings;
BEGIN { $| = 1; print "1..14\n"; }
my $count = 0;
sub ok ($;$) {
    my $p = my $r = shift;
    if (@_) {
	my $x = shift;
	$p = !defined $x ? !defined $r : !defined $r ? 0 : $r eq $x;
    }
    print $p ? "ok" : "not ok", ' ', ++$count, "\n";
}

use Unicode::Collate::Locale;

ok(1);

#########################

my $objMr = Unicode::Collate::Locale->
    new(locale => 'MR', normalization => undef);

ok($objMr->getlocale, 'mr');

$objMr->change(level => 1);

ok($objMr->lt("\x{950}", "\x{902}"));
ok($objMr->lt("\x{902}", "\x{903}"));
ok($objMr->lt("\x{903}", "\x{972}"));

ok($objMr->eq("\x{902}", "\x{901}"));

ok($objMr->lt("\x{939}", "\x{933}"));
ok($objMr->lt("\x{933}", "\x{915}\x{94D}\x{937}"));
ok($objMr->lt("\x{915}\x{94D}\x{937}", "\x{91C}\x{94D}\x{91E}"));
ok($objMr->lt("\x{91C}\x{94D}\x{91E}", "\x{93D}"));

ok($objMr->eq("\x{933}", "\x{934}"));

# 11

$objMr->change(level => 2);

ok($objMr->lt("\x{902}", "\x{901}"));
ok($objMr->lt("\x{933}", "\x{934}"));

$objMr->change(level => 3);

ok($objMr->eq("\x{933}\x{93C}", "\x{934}"));

# 14
