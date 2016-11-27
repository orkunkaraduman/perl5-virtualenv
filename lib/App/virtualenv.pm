package App::virtualenv;
use strict;
use warnings;
no warnings qw(qw utf8 redefine);
use v5.10;
use utf8;
use FindBin;
use Cwd;
use File::Basename;
use Perl::Shell;
use Term::ReadLine;
use Config;
use Lexical::Persistence;


BEGIN
{
	require Exporter;
	# set the version for version checking
	our $VERSION     = '1.02';
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw();
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw();

	$ENV{PERL_RL} = 'gnu o=0';
	require Term::ReadLine;
}


sub activate
{
	my ($virtualEnvPath) = @_;
	$virtualEnvPath = getVirtualEnv() if not defined $virtualEnvPath;
	$virtualEnvPath = binVirtualEnv() if not defined $virtualEnvPath;
	$virtualEnvPath = Cwd::realpath($virtualEnvPath);
	warn "Virtual environment is not valid" if not validVirtualEnv($virtualEnvPath);

	deactivate(1);

	$ENV{_OLD_PERL_VIRTUAL_ENV} = $ENV{PERL_VIRTUAL_ENV};
	$ENV{PERL_VIRTUAL_ENV} = $virtualEnvPath;

	$ENV{_OLD_PERL_VIRTUAL_PATH} = $ENV{PATH};
	$ENV{PATH} = "$virtualEnvPath/bin".((defined $ENV{PATH})? ":${ENV{PATH}}": "");

	$ENV{_OLD_PERL_VIRTUAL_PERL5LIB} = $ENV{PERL5LIB};
	$ENV{PERL5LIB} = "$virtualEnvPath/lib/perl5".((defined $ENV{PERL5LIB})? ":${ENV{PERL5LIB}}": "");

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

	system("/usr/bin/perl -MCPAN -e \"CPAN::install('LWP', 'CPAN', 'App::cpanminus', 'App::cpanoutdated')\"");

	my $pkgPath = dirname(__FILE__);
	system("cp -v $pkgPath/virtualenv/activate $virtualEnvPath/bin/activate && chmod 644 $virtualEnvPath/bin/activate");
	system("cp -v $pkgPath/virtualenv/sh.pl $virtualEnvPath/bin/sh.pl && chmod 755 $virtualEnvPath/bin/sh.pl");
	system("cp -v $pkgPath/virtualenv/perl.pl $virtualEnvPath/bin/perl.pl && chmod 755 $virtualEnvPath/bin/perl.pl");

	return 1;
}

sub _sh
{
	my (@args) = @_;
	system((defined $ENV{SHELL})? $ENV{SHELL}: "/bin/sh", @args);
	return $? >> 8;
}

sub sh
{
	my ($virtualEnvPath, @args) = @_;
	$virtualEnvPath = activate($virtualEnvPath);
	return _sh(@args);
}

sub _perl
{
	my (@args) = @_;
	system("/usr/bin/perl", @args);
	return $? >> 8;
}

sub perl
{
	my ($virtualEnvPath, @args) = @_;
	$virtualEnvPath = activate($virtualEnvPath);
	return _perl(@args);
}

sub bashReadLine
{
	my ($prompt) = @_;
	$prompt =~ s/\\/\\\\/g;
	$prompt =~ s/"/\\"/g;
	$prompt =~ s/\\/\\\\/g;
	$prompt =~ s/"/\\"/g;
	my $cmd = '/bin/bash -c "read -p \"'.$prompt.'\" -r -e && echo \"\$REPLY\""';
	$_ = `$cmd`;
	chomp;
	return (not $?)? $_: undef;
}

#sub Perl::Shell::_readline
sub _readline
{
	my $prompt = shift;
	if ( -t STDIN ) {
		return bashReadLine($prompt);
	} else {
		print $prompt;
		my $line = <>;
		chomp $line if defined $line;
		return $line;
	}
}

sub Perl::Shell::_State::do
{
	my $self = shift;
	$_[0] = "use v$Config{version};\n".$_[0] if defined $_[0];
	return Lexical::Persistence::do($self, @_);
}

sub shell
{
	my ($virtualEnvPath, @args) = @_;
	open my $stdout, ">&:encoding(iso-8859-1)", *STDOUT;
	local *STDOUT = *$stdout;
	#open my $stdin, "<&:encoding(iso-8859-1)", *STDIN;
	#local *STDIN = *$stdin;
	return Perl::Shell::shell();
}


1;
