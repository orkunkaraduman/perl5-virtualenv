package App::Virtualenv::Piv;
=head1 NAME

App::Virtualenv::Piv - Perl in Virtual environment

=head1 VERSION

version 1.12

=head1 SYNOPSIS

Perl in Virtual environment

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


sub man
{
	my $man = whereisBin("man");
	my $cat = whereisBin("cat");
	return unless $man and $cat;
	my $P = shellmeta("-P$cat");
	return `$man "$P" piv.pl 2>/dev/null`;
}

sub main
{
	my $args = cmdArgs(@_);
	my $man = man();
	$man = "" unless $man;
	if (not defined $args->{command})
	{
		say STDERR "Command is needed:\n$man";
		return 254;
	}
	switch ($args->{command})
	{
		case "virtualenv"
		{
			my $empty = defined($args->{'-e'})? 1: 0;
			return not App::Virtualenv::create($args->{parameters}->[0], $empty);
		}
		case "sh"
		{
			App::Virtualenv::activate();
			return App::Virtualenv::sh(@{$args->{parameters}});
		}
		case "perl"
		{
			App::Virtualenv::activate();
			return App::Virtualenv::perl(@{$args->{parameters}});
		}
		case "list"
		{
			App::Virtualenv::activate2();
			my $_1 = defined($args->{'-1'})? 1: 0;
			return App::Virtualenv::perl("-MApp::Virtualenv::Module", "-e exit not App::Virtualenv::Module::list(1 => $_1);");
		}
		case "install"
		{
			App::Virtualenv::activate2();
			$ENV{PERL_MM_USE_DEFAULT} = 1;
			$ENV{NONINTERACTIVE_TESTING} = 1;
			my $force = defined($args->{'-f'})? 1: 0;
			my $test = defined($args->{'-t'})? 1: 0;
			my $soft = defined($args->{'-s'})? 1: 0;
			my $verbose = defined($args->{'-v'})? 1: 0;
			my @modules = @{$args->{parameters}};
			@modules = map(s/(.*)/\"\Q$1\E\"/r, @modules);
			my $modules = join(", ", @modules);
			return App::Virtualenv::perl("-MApp::Virtualenv::Module", "-e exit not App::Virtualenv::Module::install(force => $force, test=> $test, soft => $soft, verbose => $verbose, modules => [$modules]);");
		}
		case "remove"
		{
			App::Virtualenv::activate2();
			$ENV{PERL_MM_USE_DEFAULT} = 1;
			$ENV{NONINTERACTIVE_TESTING} = 1;
			my $force = defined($args->{'-f'})? 1: 0;
			my $verbose = defined($args->{'-v'})? 1: 0;
			my @modules = @{$args->{parameters}};
			@modules = map(s/(.*)/\"\Q$1\E\"/r, @modules);
			my $modules = join(", ", @modules);
			return App::Virtualenv::perl("-MApp::Virtualenv::Module", "-e exit not App::Virtualenv::Module::remove(force => $force, verbose => $verbose, modules => [$modules]);");
		}
		else
		{
			say STDERR "Command \"$args->{command}\" is not known:\n$man";
			return 253;
		}
	}
	return 0;
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
