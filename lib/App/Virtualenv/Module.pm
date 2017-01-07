package App::Virtualenv::Module;
=head1 NAME

App::Virtualenv::Module - Module management for Perl virtual environment

=head1 VERSION

version 1.12

=head1 SYNOPSIS

Module management for Perl virtual environment

=cut
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.14;
use utf8;
use Config;
use Switch;
use FindBin;
use Cwd;
use File::Basename;
use Lazy::Utils;
use ExtUtils::Installed;
require CPANPLUS;
use CPANPLUS::Error qw(cp_msg cp_error);

use App::Virtualenv;


BEGIN
{
	require Exporter;
	# set the version for version checking
	our $VERSION     = '1.12';
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw();
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw();
}


my $inst = reloadInst();
my $cb = CPANPLUS::Backend->new();


sub reloadInst
{
	my @perl5lib = split(":", defined $ENV{PERL5LIB}? $ENV{PERL5LIB}: "");
	$inst = ExtUtils::Installed->new(inc_override => [($perl5lib[0]? ("$perl5lib[0]/$Config{version}/$Config{archname}", "$perl5lib[0]/$Config{version}", "$perl5lib[0]/$Config{archname}", "$perl5lib[0]"): ($Config{sitearch}, $Config{sitelib}))]);
	return $inst;
}

sub isInstalled
{
	my ($moduleName) = @_;
	reloadInst();
	return grep($_ eq $moduleName, $inst->modules()) > 0;
}

sub inPerlLib
{
	my ($moduleName) = @_;
	return grep({defined $_ and -e $_."/".($moduleName =~ s/\:\:/\//r).".pm"} ($Config{extrasarch}, $Config{extraslib}, $Config{archlib}, $Config{privlib})) > 0;
}

sub list
{
	my %params = @_;
	reloadInst();
	my @modules = $inst->modules();
	for my $moduleName (sort {lc($a) cmp lc($b)} @modules)
	{
		next if lc($moduleName) eq 'perl';
		if ($params{1})
		{
			say $moduleName;
			next;
		}
		my $space = "                                       ";
		my $len = length($space)-length($moduleName);
		my $spaces = substr($space, -$len);
		$spaces = "" if $len <= 0;
		my $version = $inst->version($moduleName);
		$version = "0" if not $version;
		say "$moduleName$spaces $version";
	}
	return 1;
}

sub install
{
	my %params = @_;
	my $force = $params{force}? 1: 0;
	my $test = $params{test}? 1: 0;
	my $soft = $params{soft}? 1: 0;
	my $verbose = $params{verbose}? 1: 0;
	my $result = 1;
	state @installing;
	state @installInfos;
	push @installing, "";
	for my $moduleName (@{$params{modules}})
	{
		pop @installing;
		push @installing, $moduleName;
		my $installInfo = {name => $moduleName, "success" => "", "fail" => "", "depth" => scalar(@installing)-1};
		push @installInfos, $installInfo;
		cp_msg("Looking for module $moduleName to install", 1);

		if (lc($moduleName) eq "perl" or $moduleName eq "Config")
		{
			cp_msg("Module $moduleName is in Perl", 1);
			$installInfo->{"success"} = "in Perl";
			next;
		}

		my $mod = $cb->module_tree($moduleName);
		if (not $mod)
		{
			cp_error("Module $moduleName is not found", 1);
			$installInfo->{"fail"} = "find";
			$result = 0;
			next;
		}

		if ($mod->package_is_perl_core())
		{
			cp_msg("Module $moduleName is in Perl core", 1);
			$installInfo->{"success"} = "in Perl core";
			next;
		}

		if (not $force and inPerlLib($moduleName))
		{
			cp_msg("Module $moduleName is in Perl library", 1);
			$installInfo->{"success"} = "in Perl library";
			next;
		}

		my $installed = isInstalled($moduleName);
		$installInfo->{"alreadyInstalled"} = $installed;
		if (not $force and $installed and $mod->is_uptodate())
		{
			cp_msg("Module $moduleName is up to date", 1);
			$installInfo->{"success"} = "up to date";
			next;
		}

		cp_msg("Fetching module $moduleName", 1);
		unless ($mod->fetch(verbose => $verbose))
		{
			cp_error("Failed to fetch module $moduleName", 1);
			$installInfo->{"fail"} = "fetch";
			$result = 0;
			next;
		}
		cp_msg("Succeed to fetch module $moduleName", 1);

		cp_msg("Extracting module $moduleName", 1);
		unless ($mod->extract(verbose => $verbose))
		{
			cp_error("Failed to extract module $moduleName", 1);
			$installInfo->{"fail"} = "extract";
			$result = 0;
			next;
		}
		cp_msg("Succeed to extract module $moduleName", 1);

		cp_msg("Preparing module $moduleName", 1);
		unless ($mod->prepare(verbose => $verbose))
		{
			cp_error("Failed to prepare module $moduleName", 1);
			$installInfo->{"fail"} = "prepare";
			$result = 0;
			next;
		}
		cp_msg("Succeed to prepare module $moduleName", 1);

		unless ($soft)
		{
			cp_msg("Looking for prerequisites of module $moduleName", 1);
			my $res = 1;
			for my $ps (@{$mod->{_status}->{prereqs}})
			{
				delete $ps->{'perl'};
				for my $p (keys %$ps)
				{
					next if (grep($_ eq $p, @installing));
					unless (install(modules => [$p], test => $test))
					{
						$res = 0;
						last;
					}
				}
				last unless $res;
			}
			unless ($res)
			{
				cp_error("Failed to install prerequisites of module $moduleName", 1);
				$installInfo->{"fail"} = "install prerequisites";
				$result = 0;
				next;
			}
			cp_msg("Succeed to install prerequisites of module $moduleName", 1);
		}

		if ($test)
		{
			cp_msg("Testing module $moduleName", 1);
			unless ($mod->test(verbose => $verbose))
			{
				cp_error("Failed to test module $moduleName", 1);
				$installInfo->{"fail"} = "test";
				$result = 0;
				next;
			}
			cp_msg("Succeed to test module $moduleName", 1);
		}

		cp_msg("Installing module $moduleName", 1);
		my $willBeStatus =  (not $installed)? "installed": "upgraded";
		unless ($mod->install(verbose => $verbose, force => 1, skiptest => 1))
		{
			cp_error("Module $moduleName could not be $willBeStatus", 1);
			$installInfo->{"fail"} = "install";
			$result = 0;
			next;
		}
		cp_msg("Module $moduleName has been successfully $willBeStatus", 1);
		$installInfo->{"success"} = "installed";
	}
	pop @installing;

	unless (@installing)
	{
		say "\nSummary:";
		my ($installedCount, $failedCount) = (0, 0);
		my $lastDepth = 0;
		for my $installInfo (@installInfos)
		{
			my $msg;
			if ($installInfo->{"fail"})
			{
				$msg = "is failed to $installInfo->{'fail'}";
				$failedCount++;
			} elsif ($installInfo->{"success"})
			{
				next if $installInfo->{'success'} ne "installed";
				$msg = "is $installInfo->{'success'}";
				$installedCount++;
			}
			my $spaces;
			if ($installInfo->{depth} < $lastDepth)
			{
				$spaces = "";
				for (0..$installInfo->{depth})
				{
					next unless $_;
					$spaces .= "|---";
				}
				$spaces .= "|---|";
				say $spaces;
			}
			$spaces = "";
			for (0..$installInfo->{depth})
			{
				next unless $_;
				$spaces .= "|---";
			}
			$spaces .= "|-- ";
			say $spaces.$installInfo->{name}." $msg";
			$lastDepth = $installInfo->{depth};
		}
		say "|\n| Installed: $installedCount\n| Failed: $failedCount\n";

		@installInfos = ();
	}

	return $result;
}

sub remove
{
	my %params = @_;
	my $force = $params{force}? 1: 0;
	my $verbose = $params{verbose}? 1: 0;
	my $result = 1;
	state @removeInfos;
	for my $moduleName (@{$params{modules}})
	{
		my $removeInfo = {name => $moduleName, "success" => "", "fail" => "", "depth" => 0};
		push @removeInfos, $removeInfo;
		cp_msg("Looking for module $moduleName to remove", 1);
		my $mod = $cb->module_tree($moduleName);
		if (not $mod)
		{
			cp_error("Module $moduleName is not found", 1);
			$removeInfo->{"fail"} = "find";
			$result = 0;
			next;
		}

		my $installed = isInstalled($moduleName);
		unless ($installed)
		{
			cp_msg("Module $moduleName is not installed", 1);
			$removeInfo->{"success"} = "not installed";
			next;
		}

		cp_msg("Removing module $moduleName", 1);
		unless ($mod->uninstall(verbose => $verbose, force => $force, type => 'all'))
		{
			cp_error("Module $moduleName could not be removed", 1);
			$removeInfo->{"fail"} = "remove";
			$result = 0;
			next;
		}
		cp_msg("Module $moduleName has been successfully removed", 1);
		$removeInfo->{"success"} = "removed";
	}

	say "\nSummary:";
	my ($removedCount, $failedCount) = (0, 0);
	my $lastDepth = 0;
	for my $removeInfo (@removeInfos)
	{
		my $msg;
		if ($removeInfo->{"fail"})
		{
			$msg = "is failed to $removeInfo->{'fail'}";
			$failedCount++;
		} elsif ($removeInfo->{"success"})
		{
			next if $removeInfo->{'success'} ne "removed";
			$msg = "is $removeInfo->{'success'}";
			$removedCount++;
		}
		my $spaces;
		if ($removeInfo->{depth} < $lastDepth)
		{
			$spaces = "";
			for (0..$removeInfo->{depth})
			{
				next unless $_;
				$spaces .= "|---";
			}
			$spaces .= "|---|";
			say $spaces;
		}
		$spaces = "";
		for (0..$removeInfo->{depth})
		{
			next unless $_;
			$spaces .= "|---";
		}
		$spaces .= "|-- ";
		say $spaces.$removeInfo->{name}." $msg";
		$lastDepth = $removeInfo->{depth};
	}
	say "|\n| Removed: $removedCount\n| Failed: $failedCount\n";

	@removeInfos = ();

	return $result;
}


1;
__END__
=head1 REPOSITORY

B<GitHub> L<https://github.com/orkunkaraduman/perl5-virtualenv>

B<CPAN> L<https://metacpan.org/release/App-Virtualenv>

=head1 AUTHOR

Orkun Karaduman <orkunkaraduman@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2017  Orkun Karaduman <orkunkaraduman@gmail.com>

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
