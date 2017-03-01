#! /usr/bin/perl
=head1 NAME

test.pl - for internal tests

=head1 VERSION

version not defined

=head1 ABSTRACT

for internal tests

=cut
use strict;
use warnings;
use v5.14;
use utf8;
use open qw(:utf8 :std);
use open IO => ':bytes';
use FindBin;
use Data::Dumper;

use lib "${FindBin::Bin}/../lib";
use App::Virtualenv;
use App::Virtualenv::Module;
use App::Virtualenv::Piv;


exit 0;
__END__
=head1 AUTHOR

Orkun Karaduman <orkunkaraduman@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2017  Orkun Karaduman <orkunkaraduman@gmail.com>

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
