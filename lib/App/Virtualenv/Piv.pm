package App::Virtualenv::Piv;
=head1 NAME

App::Virtualenv::Piv - Perl in Virtual environment

=head1 VERSION

version 1.07

=head1 SYNOPSIS

Perl in Virtual environment

=cut
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use utf8;
use Switch;

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


sub activate
{
	my $virtualenvPath = App::Virtualenv::activate();
	say "Perl virtual environment path: $virtualenvPath" if defined $virtualenvPath;
	return $virtualenvPath;
}

sub main
{
	my $args = cmdArgs(@_);
	if (not defined $args->{cmd})
	{
		say STDERR "Command is needed.";
		return 254;
	}
	switch ($args->{cmd})
	{
		case "virtualenv"
		{
			my $empty = defined($args->{-e})? 1: 0;
			return not App::Virtualenv::create($args->{params}->[0], $empty);
		}
		case "sh"
		{
			activate;
			return App::Virtualenv::sh(@{$args->{params}});
		}
		case "perl"
		{
			activate;
			return App::Virtualenv::perl(@{$args->{params}});
		}
		case "list"
		{
			activate;
			my $_1 = defined($args->{-1})? 1: 0;
			return App::Virtualenv::perl("-MApp::Virtualenv::Module", "-e exit not App::Virtualenv::Module::list(1 => $_1);");
		}
		case "install"
		{
			activate;
			my $force = defined($args->{-f})? 1: 0;
			my $test = defined($args->{-t})? 1: 0;
			my $soft = defined($args->{"-s"})? 1: 0;
			my @modules = @{$args->{params}};
			@modules = map(s/(.*)/\"\Q$1\E\"/r, @modules);
			my $modules = join(", ", @modules);
			return App::Virtualenv::perl("-MApp::Virtualenv::Module", "-e exit not App::Virtualenv::Module::install(force => $force, test=> $test, soft => $soft, modules => [$modules]);");
		}
		case "remove"
		{
			activate;
			my $force = defined($args->{-f})? 1: 0;
			my @modules = @{$args->{params}};
			@modules = map(s/(.*)/\"\Q$1\E\"/r, @modules);
			my $modules = join(", ", @modules);
			return App::Virtualenv::perl("-MApp::Virtualenv::Module", "-e exit not App::Virtualenv::Module::remove(force => $force, modules => [$modules]);");
		}
		else
		{
			say STDERR "Command \"$args->{cmd}\" is not known.";
			return 253;
		}
	}
	return 0;
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
