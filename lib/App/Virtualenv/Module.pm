package App::Virtualenv::Module;
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use utf8;
use FindBin;
use Cwd;
use File::Basename;
use Term::ReadLine;
use Config;
use ExtUtils::Installed;


BEGIN
{
	require Exporter;
	# set the version for version checking
	our $VERSION     = $App::Virtualenv::VERSION;
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw();
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw();

	$ENV{PERL_RL} = 'gnu o=0';
	require Term::ReadLine;
}


sub list
{
	my $inst = ExtUtils::Installed->new();
	my @perl5lib = split(":", $ENV{PERL5LIB});
	my $perl5lib = $perl5lib[0];
	return 0 if not defined $perl5lib;
	my @modules = $inst->modules();
	for my $module (sort {lc($a) cmp lc($b)} @modules)
	{
		my @files = $inst->files($module, "all", $perl5lib);
		my $version = $inst->version($module);
		my $space = "                                      ";
		my $len = length($space)-length($module);
		my $spaces = substr($space, -$len);
		$spaces = "" if $len <= 0;
		say "$module $spaces $version" if @files;
	}
	return 1;
}


1;
