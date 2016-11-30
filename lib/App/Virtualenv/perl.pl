#! /usr/bin/perl
=head1 NAME

perl.pl - runs Perl language interpreter under Perl virtual environment

=head1 VERSION

version 1.05

=head1 SYNOPSIS

runs Perl language interpreter under Perl virtual environment

C<I<environment_path>/bin/perl.pl [I<argument>]...>

=cut
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use open qw(:std :locale);
use utf8;

use App::Virtualenv;


my $virtualenvPath = App::Virtualenv::activate($virtualenvPath);
say "Virtual environment path: $virtualenvPath";
exit App::Virtualenv::perl(@ARGV);
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
