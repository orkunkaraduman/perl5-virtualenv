#! /usr/bin/perl
=head1 NAME

dist.pl - distribution generator

=head1 VERSION

version not defined

=head1 SYNOPSIS

distribution generator

=cut
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.14;
use utf8;
use open qw(:std :locale);
use Config;
use FindBin;
use Cwd;


my $module = "App::Virtualenv";
my $modulePath = "lib/" . $module =~ s/\:\:/\//gr . ".pm";
my $base = "${FindBin::Bin}/..";
cwd($base);

system("perl Makefile.PL");
system("pod2markdown --html-encode-chars 1 $modulePath > README.md");
system("pod2text $modulePath > README");
system("rm MANIFEST; make manifest");
system("make dist");

exit 0;
__END__
=head1 REPOSITORY

B<GitHub> L<https://github.com/orkunkaraduman/perl5-virtualenv>

B<CPAN> L<https://metacpan.org/release/App-Virtualenv>

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
