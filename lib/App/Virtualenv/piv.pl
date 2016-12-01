#! /usr/bin/perl
=head1 NAME

pev.pl - bla bla bla

=head1 VERSION

version 1.05

=head1 SYNOPSIS

bla bla bla

C<[I<environment_path>/bin/]pev.pl>

=cut
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use open qw(:std :locale);
use utf8;
use Switch;
use FindBin;
use Data::Dumper;

use lib "${FindBin::Bin}/../../../lib";
use App::Virtualenv;
use App::Virtualenv::Utils;


my $args = cmdArgs(@ARGV);
say Dumper($args);
exit 0;

my $virtualenvPath = App::Virtualenv::activate();
say "Perl virtual environment path: $virtualenvPath";
exit App::Virtualenv::sh(@ARGV);
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
