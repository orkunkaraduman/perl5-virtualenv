package App::Virtualenv::Module;
=head1 NAME

App::Virtualenv::Module - Module management for Perl 5 virtual environment

=head1 VERSION

version 1.04

=head1 SYNOPSIS

Module management for Perl 5 virtual environment

I<This module is not completed yet.>

=cut
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

use App::Virtualenv;


BEGIN
{
	require Exporter;
	# set the version for version checking
	our $VERSION     = '1.04';
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw();
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw();

	$ENV{PERL_RL} = 'perl o=0';
	require Term::ReadLine;
}


my $inst = ExtUtils::Installed->new();
my @perl5lib = split(":", $ENV{PERL5LIB});
my $perl5lib = $perl5lib[0];


sub _list
{
	return 0 if not defined $perl5lib;
	my @modules = $inst->modules();
	for my $module (sort {lc($a) cmp lc($b)} @modules)
	{
		my @files = $inst->files($module, "all", $perl5lib);
		my $space = "                                       ";
		my $len = length($space)-length($module);
		my $spaces = substr($space, -$len);
		$spaces = "" if $len <= 0;
		my $version = $inst->version($module);
		$version = "undef" if not $version;
		say "$module$spaces $version" if @files;
	}
	return 1;
}

sub list
{
	my ($virtualenvPath, @args) = @_;
	eval { $virtualenvPath = App::Virtualenv::activate($virtualenvPath); };
	warn $@ if $@;
	return App::Virtualenv::_perl("-MApp::Virtualenv::Module", "-e exit not App::Virtualenv::Module::_list();");
}


1;
=head1 AUTHOR

Orkun Karaduman <orkunkaraduman@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016  Orkun Karaduman <orkunkaraduman@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut
