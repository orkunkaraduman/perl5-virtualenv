package App::virtualenv;
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use utf8;
use Cwd;
use FindBin;
use File::Basename;


BEGIN {
	require Exporter;
	# set the version for version checking
	our $VERSION     = 1.00;
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw();
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw();
}


sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	my ($envPath) = @_;
	$self->{envPath} = Cwd::realpath((defined $envPath)? $envPath: ".");
	return $self;
}

DESTROY
{
}

sub create
{
	my $self = shift if defined $_[0] and UNIVERSAL::isa($_[0], __PACKAGE__);
	my ($envPath) = @_;
	$self = new($envPath) if not defined $self;
	$envPath = $self->{envPath};

	require local::lib;
	local::lib->import($envPath);

	_setEnv();

	system("perl -MCPAN -e \"CPAN::install('LWP', 'CPAN', 'App::cpanminus', 'App::cpanoutdated', 'Switch', 'FindBin', 'Cwd','Perl::Shell')\"") and warn $!; warn $! if $?;

	my $pkgPath = dirname(__FILE__);
	system("cp -v $pkgPath/virtualenv-activate $envPath/bin/activate") and warn $!; warn $! if $?;
	#system("cp -v $FindBin::Bin/sh.pl $envPath/bin/sh.pl && chmod 755 $envPath/bin/sh.pl") warn $!; warn $! if $?;

	return $self;
}

sub _setEnv
{
	my $self = shift;
	my $envPath = $self->{envPath};
	$ENV{PATH} = "$envPath/bin".((defined $ENV{PATH})? ":${ENV{PATH}}": "");
	$ENV{PERL5LIB} = "$envPath/lib/perl5";
	$ENV{PERL_LOCAL_LIB_ROOT} = "$envPath";
	$ENV{PERL_MB_OPT} = "--install_base \"$envPath\"";
	$ENV{PERL_MM_OPT} = "INSTALL_BASE=$envPath";
	return 0;
}


1;
