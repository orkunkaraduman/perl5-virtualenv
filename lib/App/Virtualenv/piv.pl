#! /usr/bin/perl
=head1 NAME

piv.pl - Perl in Virtual environment

=head1 VERSION

version 1.11

=head1 SYNOPSIS

Perl in Virtual environment

=over

[I<environment_path>/bin/]B<piv.pl> [-I<argument>]... [--I<argument> I<value>]... I<command> [I<parameter>]...

=back

=head2 PIV

=head3 Commands

=head4 piv virtualenv

creates new Perl virtual environment

=over

B<piv virtualenv> [-e] [I<environment_path>]

=over

B<-e> Empty virtual environment

=back

=back

=head4 piv sh

runs Unix shell under Perl virtual environment

=over

[I<environment_path>/bin/]B<piv sh> [I<argument>]...

=back

=head4 piv perl

runs Perl language interpreter under Perl virtual environment

=over

[I<environment_path>/bin/]B<piv perl> [I<argument>]...

=back

=head4 piv list

lists installed packages under Perl virtual environment

=over

[I<environment_path>/bin/]B<piv list> [-1]

=over

B<-1> One column list

=back

=back

=head4 piv install

installs or upgrades packages under Perl virtual environment

=over

[I<environment_path>/bin/]B<piv install> [-f] [-t] [-s] [-v] I<package>...

=over

B<-f> Force

B<-t> Run tests

B<-s> Soft install without installing prerequisites

B<-v> Verbose

=back

=back

=head4 piv remove

removes packages under Perl virtual environment

=over

[I<environment_path>/bin/]B<piv remove> [-f] [-v] I<package>...

=over

B<-f> Force

B<-v> Verbose

=back

=back

=cut
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.14;
use utf8;
use open qw(:std :locale);

use App::Virtualenv;
use App::Virtualenv::Piv;


exit App::Virtualenv::Piv::main(@ARGV);
__END__
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
