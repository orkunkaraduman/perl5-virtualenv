package App::Virtualenv::Module;
=head1 NAME

App::Virtualenv::Module - Module management for Perl 5 virtual environment

=head1 VERSION

version 1.05

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
use ExtUtils::Installed;
require CPANPLUS;

use App::Virtualenv;


BEGIN
{
	require Exporter;
	# set the version for version checking
	our $VERSION     = '1.05';
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw();
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw();
}


my @perl5lib = split(":", defined $ENV{PERL5LIB}? $ENV{PERL5LIB}: "");
my $perl5lib = $perl5lib[0];
die "Perl virtual environment variable PERL5LIB is not defined" unless $perl5lib;
my $inst = ExtUtils::Installed->new;
my $cb = CPANPLUS::Backend->new;


sub list
{
	my @modules = $inst->modules();
	for my $module (sort {lc($a) cmp lc($b)} @modules)
	{
		my @files = $inst->files($module, "all", $perl5lib);
		my $space = "                                       ";
		my $len = length($space)-length($module);
		my $spaces = substr($space, -$len);
		$spaces = "" if $len <= 0;
		my $version = $inst->version($module);
		$version = "0" if not $version;
		say "$module$spaces $version" if @files;
	}
	return 1;
}

sub install
{
	my ($moduleName) = @_;
	my $mod = $cb->module_tree($moduleName);
	die "Module $moduleName is not found" if not defined $mod;
	my $instdir = $mod->installed_dir();
	die "Module $moduleName is already installed in Perl virtual environment" if defined $instdir and $instdir eq $perl5lib;
	return $mod->install(force => 1, verbose => 1);
}

sub upgrade
{
	my ($moduleName) = @_;
	my $mod = $cb->module_tree($moduleName);
	die "Module $moduleName is not found" if not defined $mod;
	my $instdir = $mod->installed_dir();
	die "Module $moduleName is not installed in Perl virtual environment" unless defined $instdir and $instdir eq $perl5lib;
	if ($mod->is_uptodate())
	{
		say "Module $moduleName is up to date.";
		return 0;
	}
	return $mod->install(force => 1, verbose => 1);
}

sub remove
{
	my ($moduleName) = @_;
	my $mod = $cb->module_tree($moduleName);
	die "Module $moduleName is not found" if not defined $mod;
	my $instdir = $mod->installed_dir();
	die "Module $moduleName is not installed in Perl virtual environment" unless defined $instdir and $instdir eq $perl5lib;
	my $result = $mod->uninstall(type => 'all');
	if ($result)
	{
		say "Module $moduleName had been successfully removed.";
	} else
	{
		say "Module $moduleName could not be removed.";
	}
	return $result;
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
