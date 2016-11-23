package App::virtualenv;
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use utf8;
use FindBin;
use Cwd;
use File::Basename;


BEGIN {
	require Exporter;
	# set the version for version checking
	our $VERSION     = 1.04;
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw();
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw();
}


sub activate
{
	my ($virtualEnvPath) = @_;
	$virtualEnvPath = getVirtualEnv() if not defined $virtualEnvPath;
	$virtualEnvPath = binVirtualEnv() if not defined $virtualEnvPath;
	$virtualEnvPath = Cwd::realpath($virtualEnvPath);
	warn "Virtual environment is not valid" if not validVirtualEnv($virtualEnvPath);

	deactivate('nondestructive');

	$ENV{_OLD_PERL_VIRTUAL_ENV} = $ENV{PERL_VIRTUAL_ENV};
	$ENV{PERL_VIRTUAL_ENV} = $virtualEnvPath;

	$ENV{_OLD_PERL_VIRTUAL_PATH} = $ENV{PATH};
	$ENV{PATH} = "$virtualEnvPath/bin".((defined $ENV{PATH})? ":${ENV{PATH}}": "");

	$ENV{_OLD_PERL_VIRTUAL_PERL5LIB} = $ENV{PERL5LIB};
	$ENV{PERL5LIB} = "$virtualEnvPath/lib/perl5";

	$ENV{_OLD_PERL_VIRTUAL_PERL_LOCAL_LIB_ROOT} = $ENV{PERL_LOCAL_LIB_ROOT};
	$ENV{PERL_LOCAL_LIB_ROOT} = "$virtualEnvPath";

	$ENV{_OLD_PERL_VIRTUAL_PERL_MB_OPT} = $ENV{PERL_MB_OPT};
	$ENV{PERL_MB_OPT} = "--install_base \"$virtualEnvPath\"";

	$ENV{_OLD_PERL_VIRTUAL_PERL_MM_OPT} = $ENV{PERL_MM_OPT};
	$ENV{PERL_MM_OPT} = "INSTALL_BASE=$virtualEnvPath";

	$ENV{_OLD_PERL_VIRTUAL_PS1} = $ENV{PS1};
	$ENV{PS1} = "(" . basename($virtualEnvPath) . ") ".((defined $ENV{PS1})? $ENV{PS1}: "");

	return $virtualEnvPath;
}

sub deactivate
{
	my $nondestructive = (defined($_[0]) and ($_[0] eq 'nondestructive'));

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

sub getVirtualEnv
{
	return (defined $ENV{PERL_VIRTUAL_ENV})? Cwd::realpath($ENV{PERL_VIRTUAL_ENV}): undef;
}

sub binVirtualEnv
{
	return Cwd::realpath("${FindBin::Bin}/..");
}

sub validVirtualEnv
{
	my ($virtualEnvPath) = @_;
	return 0 if not defined $virtualEnvPath;
	$virtualEnvPath = Cwd::realpath($virtualEnvPath);
	return -d "$virtualEnvPath/lib/perl5";
}

sub create
{
	my ($virtualEnvPath) = @_;
	$virtualEnvPath = Cwd::realpath((defined $virtualEnvPath)? $virtualEnvPath: ".");

	deactivate();

	require local::lib;
	local::lib->import($virtualEnvPath);

	activate($virtualEnvPath);

	system("perl -MCPAN -e \"CPAN::install('LWP', 'CPAN', 'App::cpanminus', 'App::cpanoutdated')\"") and warn $!; warn $! if $?;

	my $pkgPath = dirname(__FILE__);
	system("cp -v $pkgPath/virtualenv-activate $virtualEnvPath/bin/activate") and warn $!; warn $! if $?;

	return 1;
}

sub sh {
	my ($virtualEnvPath) = @_;
	$virtualEnvPath = activate($virtualEnvPath);
	system((defined $ENV{SHELL})? $ENV{SHELL}: "/bin/sh", @ARGV) and warn $!; warn $! if $?;
	return 1;
}


1;
