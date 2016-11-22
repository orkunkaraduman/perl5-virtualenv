#!/usr/bin/perl
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use utf8;
use FindBin;
use Cwd;


my ($envPath) = @ARGV;
$envPath = Cwd::realpath((defined $envPath)? $envPath: ".");

require local::lib;
local::lib->import($envPath);

$ENV{PATH} = "$envPath/bin".((defined $ENV{PATH})? ":${ENV{PATH}}": "");
$ENV{PERL5LIB} = "$envPath/lib/perl5";
$ENV{PERL_LOCAL_LIB_ROOT} = "$envPath";
$ENV{PERL_MB_OPT} = "--install_base \"$envPath\"";
$ENV{PERL_MM_OPT} = "INSTALL_BASE=$envPath";

system("perl -MCPAN -e \"CPAN::install('LWP', 'CPAN', 'App::cpanminus', 'App::cpanoutdated', 'Switch', 'FindBin', 'Cwd','Perl::Shell')\"") and die; die if $?;

system("cp -v $FindBin::Bin/activate $envPath/bin/activate") and die $!; die $! if $?;
system("cp -v $FindBin::Bin/sh.pl $envPath/bin/sh.pl && chmod 755 $envPath/bin/sh.pl") and die $!; die $! if $?;

exit 0;
