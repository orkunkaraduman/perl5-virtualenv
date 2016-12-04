package App::Virtualenv;
=head1 NAME

App::Virtualenv - Perl virtual environment

=head1 VERSION

version 1.07.01

=head1 SYNOPSIS

Perl virtual environment

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

use App::Virtualenv::Utils;


BEGIN
{
	require Exporter;
	# set the version for version checking
	our $VERSION     = '1.07.01';
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw();
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw();
}


sub activate
{
	my ($virtualenvPath) = @_;
	$virtualenvPath = getVirtualenvPath() if not defined $virtualenvPath;
	$virtualenvPath = binVirtualenvPath() if not defined $virtualenvPath;
	$virtualenvPath = Cwd::realpath($virtualenvPath);
	return if not validVirtualenvPath($virtualenvPath);

	deactivate(1);

	$ENV{_OLD_PERL_VIRTUAL_ENV} = $ENV{PERL_VIRTUAL_ENV};
	$ENV{PERL_VIRTUAL_ENV} = $virtualenvPath;

	$ENV{_OLD_PERL_VIRTUAL_PATH} = $ENV{PATH};
	$ENV{PATH} = "$virtualenvPath/bin".((defined $ENV{PATH})? ":${ENV{PATH}}": "");

	$ENV{_OLD_PERL_VIRTUAL_PERL5LIB} = $ENV{PERL5LIB};
	$ENV{PERL5LIB} = "$virtualenvPath/lib/perl5".((defined $ENV{PERL5LIB})? ":${ENV{PERL5LIB}}": "");

	$ENV{_OLD_PERL_VIRTUAL_PERL_LOCAL_LIB_ROOT} = $ENV{PERL_LOCAL_LIB_ROOT};
	$ENV{PERL_LOCAL_LIB_ROOT} = "$virtualenvPath";

	$ENV{_OLD_PERL_VIRTUAL_PERL_MB_OPT} = $ENV{PERL_MB_OPT};
	$ENV{PERL_MB_OPT} = "--install_base \"$virtualenvPath\"";

	$ENV{_OLD_PERL_VIRTUAL_PERL_MM_OPT} = $ENV{PERL_MM_OPT};
	$ENV{PERL_MM_OPT} = "INSTALL_BASE=$virtualenvPath";

	$ENV{_OLD_PERL_VIRTUAL_PS1} = $ENV{PS1};
	$ENV{PS1} = "(" . basename($virtualenvPath) . ") ".((defined $ENV{PS1})? $ENV{PS1}: "");

	return $virtualenvPath;
}

sub deactivate
{
	my ($nondestructive) = @_;

	$nondestructive = not defined($ENV{PERL_VIRTUAL_ENV}) if not defined($nondestructive);

	$ENV{PERL_VIRTUAL_ENV} = $ENV{_OLD_PERL_VIRTUAL_ENV} if defined($ENV{_OLD_PERL_VIRTUAL_ENV}) or not $nondestructive;
	undef $ENV{_OLD_PERL_VIRTUAL_ENV};

	$ENV{PATH} = $ENV{_OLD_PERL_VIRTUAL_PATH} if defined($ENV{_OLD_PERL_VIRTUAL_PATH}) or not $nondestructive;
	undef $ENV{_OLD_PERL_VIRTUAL_PATH};

	$ENV{PERL5LIB} = $ENV{_OLD_PERL_VIRTUAL_PERL5LIB} if defined($ENV{_OLD_PERL_VIRTUAL_PERL5LIB}) or not $nondestructive;
	undef $ENV{_OLD_PERL_VIRTUAL_PERL5LIB};

	$ENV{PERL_LOCAL_LIB_ROOT} = $ENV{_OLD_PERL_VIRTUAL_PERL_LOCAL_LIB_ROOT} if defined($ENV{_OLD_PERL_VIRTUAL_PERL_LOCAL_LIB_ROOT}) or not $nondestructive;
	undef $ENV{_OLD_PERL_VIRTUAL_PERL_LOCAL_LIB_ROOT};

	$ENV{PERL_MB_OPT} = $ENV{_OLD_PERL_VIRTUAL_PERL_MB_OPT} if defined($ENV{_OLD_PERL_VIRTUAL_PERL_MB_OPT}) or not $nondestructive;
	undef $ENV{_OLD_PERL_VIRTUAL_PERL_MB_OPT};

	$ENV{PERL_MM_OPT} = $ENV{_OLD_PERL_VIRTUAL_PERL_MM_OPT} if defined($ENV{_OLD_PERL_VIRTUAL_PERL_MM_OPT}) or not $nondestructive;
	undef $ENV{_OLD_PERL_VIRTUAL_PERL_MM_OPT};

	$ENV{PS1} = $ENV{_OLD_PERL_VIRTUAL_PS1} if defined($ENV{_OLD_PERL_VIRTUAL_PS1}) or not $nondestructive;
	undef $ENV{_OLD_PERL_VIRTUAL_PS1};

	return;
}

sub getVirtualenvPath
{
	return (defined $ENV{PERL_VIRTUAL_ENV})? Cwd::realpath($ENV{PERL_VIRTUAL_ENV}): undef;
}

sub binVirtualenvPath
{
	return Cwd::realpath("${FindBin::Bin}/..");
}

sub validVirtualenvPath
{
	my ($virtualenvPath) = @_;
	return 0 if not defined $virtualenvPath;
	$virtualenvPath = Cwd::realpath($virtualenvPath);
	return -d "$virtualenvPath/lib/perl5";
}

sub create
{
	my ($virtualenvPath, $empty) = @_;
	$virtualenvPath = Cwd::realpath((defined $virtualenvPath)? $virtualenvPath: ".");
	say "Creating Perl virtual environment: $virtualenvPath";

	deactivate();

	require local::lib;
	local::lib->import($virtualenvPath);

	activate($virtualenvPath);

	perl("-MApp::Virtualenv::Module", "-e exit not App::Virtualenv::Module::install(force => 1, test => 0, modules => ['LWP', 'CPAN', 'CPANPLUS']);") unless $empty;

	my $pkgPath = dirname(__FILE__);
	_system("cp -v $pkgPath/Virtualenv/activate $virtualenvPath/bin/activate && chmod 644 $virtualenvPath/bin/activate");
	_system("cp -v $pkgPath/Virtualenv/sh.pl $virtualenvPath/bin/sh.pl && chmod 755 $virtualenvPath/bin/sh.pl");
	_system("cp -v $pkgPath/Virtualenv/perl.pl $virtualenvPath/bin/perl.pl && chmod 755 $virtualenvPath/bin/perl.pl");
	_system("ln -v -s -f perl.pl $virtualenvPath/bin/perl");
	_system("cp -v $pkgPath/Virtualenv/piv.pl $virtualenvPath/bin/piv.pl && chmod 755 $virtualenvPath/bin/piv.pl");
	_system("ln -v -s -f piv.pl $virtualenvPath/bin/piv");

	return 1;
}

sub sh
{
	my (@args) = @_;
	return _system((defined $ENV{SHELL})? $ENV{SHELL}: "/bin/sh", @args);
}

sub perl
{
	my (@args) = @_;
	return _system($Config{perlpath}, @args);
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
