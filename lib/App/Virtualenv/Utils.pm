package App::Virtualenv::Utils;
=head1 NAME

App::Virtualenv - Perl 5 virtual environment utilities

=head1 VERSION

version 1.05

=head1 SYNOPSIS

Perl 5 virtual environment utilities

=cut
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use utf8;


BEGIN
{
	require Exporter;
	# set the version for version checking
	our $VERSION     = '1.05';
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw(_system bashReadLine readLine);
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw();
}


sub _system
{
	system(@_);
	if ($? == -1)
	{
		warn "failed to execute: $!";
		return 255;
	} elsif ($? & 127)
	{
		warn "\nchild died with signal ".($? & 127).", ".(($? & 128)? "with": "without")." coredump";
		return 255;
	}
	return $? >> 8;
}

sub bashReadLine
{
	my ($prompt) = @_;
	$prompt =~ s/\\/\\\\/g;
	$prompt =~ s/"/\\"/g;
	$prompt =~ s/\\/\\\\/g;
	$prompt =~ s/"/\\"/g;
	my $cmd = '/bin/bash -c "read -p \"'.$prompt.'\" -r -e && echo -n \"\$REPLY\""';
	$_ = `$cmd`;
	return (not $?)? $_: undef;
}

sub readLine
{
	my $prompt = shift;
	if ( -t *STDIN ) {
		return bashReadLine($prompt);
	} else {
		print $prompt;
		my $line = <>;
		chomp $line if defined $line;
		return $line;
	}
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
