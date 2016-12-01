package App::Virtualenv::Piv;
=head1 NAME

App::Virtualenv::Piv - Perl in Virtual environment

=head1 VERSION

version 1.05

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
	our $VERSION     = '1.05';
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw();
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw();
}


sub main
{
	my $args = cmdArgs(@_);
	switch ($args->{cmd})
	{
		case "virtualenv"
		{
			return virtualenv(@{$args->{params}});
		}
		case "list"
		{
			return list(@{$args->{params}});
		}
		case "install"
		{
			return install(@{$args->{params}});
		}
		case "remove"
		{
			return remove(@{$args->{params}});
		}
		else
		{
			say STDERR, "Command $args->{cmd} is not defined.";
			return 254;
		}
	}
	return 0;
}

sub activate
{
	my $virtualenvPath = App::Virtualenv::activate();
	say "Perl virtual environment path: $virtualenvPath" if defined $virtualenvPath;
	return $virtualenvPath;
}

sub virtualenv
{
	my ($virtualenv) = @_;
	return not App::Virtualenv::create($virtualenv);
}

sub sh
{
	activate;
	return App::Virtualenv::sh(@_);
}

sub perl
{
	activate;
	return App::Virtualenv::perl(@_);
}

sub list
{
	activate;
	return App::Virtualenv::perl("-MApp::Virtualenv::Module", "-e exit not App::Virtualenv::Module::list();");
}

sub install
{
	activate;
	my @mods = @_;
	for (@mods) { s/(.*)/\"\Q$1\E\"/; }
	my $mods = join ", ", @mods;
	return App::Virtualenv::perl("-MApp::Virtualenv::Module", "-e exit not App::Virtualenv::Module::install($mods);");
}

sub remove
{
	activate;
	my @mods = @_;
	for (@mods) { s/(.*)/\"\Q$1\E\"/; }
	my $mods = join ", ", @mods;
	return App::Virtualenv::perl("-MApp::Virtualenv::Module", "-e exit not App::Virtualenv::Module::remove($mods);");
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
