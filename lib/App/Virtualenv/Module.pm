package App::Virtualenv::Module;
=head1 NAME

App::Virtualenv::Module - Module management for Perl virtual environment

=head1 VERSION

version 1.07

=head1 SYNOPSIS

Module management for Perl virtual environment

=cut
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use utf8;
use Config;
use FindBin;
use Cwd;
use File::Basename;
use ExtUtils::Installed;
require CPANPLUS;
use CPANPLUS::Error qw(cp_msg cp_error);

use App::Virtualenv;
use App::Virtualenv::Utils;


BEGIN
{
	require Exporter;
	# set the version for version checking
	our $VERSION     = '1.07';
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw();
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw();
}


my @perl5lib = split(":", defined $ENV{PERL5LIB}? $ENV{PERL5LIB}: "");
my %sitelib;
$sitelib{$perl5lib[0]} = "perl5lib" if $perl5lib[0];
unless (keys %sitelib)
{
	$sitelib{$Config{sitelib}} = "sitelib";
	$sitelib{$Config{sitearch}} = "sitearch";
}
my $inst = ExtUtils::Installed->new;
my $cb = CPANPLUS::Backend->new;


sub moduleFiles
{
	my ($module) = @_;
	my %files;
	for my $path (sort keys %sitelib)
	{
		for my $file ($inst->files($module, "all", $path))
		{
			$files{$file} = $sitelib{$path};
		}
	}
	return keys %files;
}

sub list
{
	my %params = @_;
	my @modules = $inst->modules();
	for my $module (sort {lc($a) cmp lc($b)} @modules)
	{
		my @files = moduleFiles($module);
		next unless @files;
		if ($params{1})
		{
			say $module;
			next;
		}
		my $space = "                                       ";
		my $len = length($space)-length($module);
		my $spaces = substr($space, -$len);
		$spaces = "" if $len <= 0;
		my $version = $inst->version($module);
		$version = "0" if not $version;
		say "$module$spaces $version";
	}
	return 1;
}

sub install
{
	my %params = @_;
	my $force = $params{force}? 1: 0;
	my $test = $params{test}? 1: 0;
	my $soft = $params{soft}? 1: 0;
	my $result = 1;
	for my $moduleName (@{$params{modules}})
	{
		cp_msg("Looking for module $moduleName to install", 1);
		my $mod = $cb->module_tree($moduleName);
		if (not $mod)
		{
			cp_error("Module $moduleName is not found", 1);
			$result = 0;
			next;
		}

		if ($mod->package_is_perl_core() or $mod->module_is_supplied_with_perl_core())
		{
			cp_msg("Module $moduleName is in Perl core", 1);
			next;
		}

		my $instpath = $mod->installed_dir();
		$instpath = $mod->installed_file() unless defined $instpath;
		my $installed = (defined $instpath and grep($instpath =~ /^\Q$_\E/, keys %sitelib));
		if (not $force and
			($instpath =~ /^\Q$Config{privlib}\E|\Q$Config{archlib}\E/ or
			grep({ my $inc = $_; $inc =~ /^\Q$Config{privlib}\E|\Q$Config{archlib}\E/ and -e $inc."/".($moduleName =~ s/\:\:/\//r).".pm"; } @INC)))
		{
			cp_msg("Module $moduleName is in Perl library", 1);
			next;
		}

		if (not $force and $installed and $mod->is_uptodate())
		{
			cp_msg("Module $moduleName is up to date", 1);
			next;
		}

		cp_msg("Fetching module $moduleName", 1);
		unless ($mod->fetch(verbose => 1))
		{
			cp_error("Failed to fetch module $moduleName", 1);
			$result = 0;
			next;
		}
		#cp_msg("Succeed to fetch module $moduleName", 1);

		cp_msg("Extracting module $moduleName", 1);
		unless ($mod->extract(verbose => 1))
		{
			cp_error("Failed to extract module $moduleName", 1);
			$result = 0;
			next;
		}
		#cp_msg("Succeed to extract module $moduleName", 1);

		cp_msg("Preparing module $moduleName", 1);
		unless ($mod->prepare(verbose => 1))
		{
			cp_error("Failed to prepare module $moduleName", 1);
			$result = 0;
			next;
		}
		#cp_msg("Succeed to prepare module $moduleName", 1);

		unless ($soft)
		{
			cp_msg("Looking for prerequisites of module $moduleName", 1);
			state @install;
			push @install, $moduleName;
			my $res = 1;
			for my $ps (@{$mod->{_status}->{prereqs}})
			{
				delete $ps->{'perl'};
				delete $ps->{'Config'};
				delete $ps->{'Errno'};
				for my $p (keys %$ps)
				{
					next if (grep($_ eq $p, @install));
					unless (install(modules => [$p], test => $test))
					{
						$res = 0;
						last;
					}
				}
				last unless $res;
			}
			pop @install;
			unless ($res)
			{
				cp_error("Failed to install prerequisites of module $moduleName", 1);
				$result = 0;
				next;
			}
			cp_msg("Succeed to install prerequisites of module $moduleName", 1);
		}

		if ($test)
		{
			cp_msg("Testing module $moduleName", 1);
			unless ($mod->test(verbose => 1))
			{
				cp_error("Failed to test module $moduleName", 1);
				$result = 0;
				next;
			}
			#cp_msg("Succeed to test module $moduleName", 1);
		}

		cp_msg("Installing module $moduleName", 1);
		my $willBeStatus =  (not $installed)? "installed": "upgraded";
		unless ($mod->install(verbose => 1, force => 1, skiptest => 1))
		{
			cp_error("Module $moduleName could not be $willBeStatus", 1);
			$result = 0;
			next;
		}
		cp_msg("Module $moduleName has been successfully $willBeStatus", 1);
	}
	return $result;
}

sub remove
{
	my %params = @_;
	my $force = $params{force}? 1: 0;
	my $result = 1;
	for my $moduleName (@{$params{modules}})
	{
		cp_msg("Looking for module $moduleName to remove", 1);
		my $mod = $cb->module_tree($moduleName);
		if (not $mod)
		{
			cp_error("Module $moduleName is not found", 1);
			$result = 0;
			next;
		}

		my $instpath = $mod->installed_dir();
		$instpath = $mod->installed_file() unless defined $instpath;
		my $installed = (defined $instpath and grep($instpath =~ /^\Q$_\E/, keys %sitelib));
		unless ($installed)
		{
			cp_msg("Module $moduleName is not installed", 1);
			next;
		}

		cp_msg("Removing module $moduleName", 1);
		unless ($mod->uninstall(verbose => 1, force => $force, type => 'all'))
		{
			cp_error("Module $moduleName could not be removed", 1);
			$result = 0;
			next;
		}
		cp_msg("Module $moduleName has been successfully removed", 1);
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
