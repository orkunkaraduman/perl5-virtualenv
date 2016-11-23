#!/usr/bin/perl
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use utf8;
use FindBin;
use Cwd;


my $envPath = Cwd::realpath((defined $ENV{PERL_VIRTUAL_ENV})? $ENV{PERL_VIRTUAL_ENV}: "${FindBin::Bin}/..");
$ENV{PATH} = "$envPath/bin".((defined $ENV{PATH})? ":${ENV{PATH}}": "");
$ENV{PERL5LIB} = "$envPath/lib/perl5";
$ENV{PERL_LOCAL_LIB_ROOT} = "$envPath";
$ENV{PERL_MB_OPT} = "--install_base \"$envPath\"";
$ENV{PERL_MM_OPT} = "INSTALL_BASE=$envPath";

system ((defined $ENV{SHELL})? $ENV{SHELL}: "/bin/sh", @ARGV);
exit $?;
