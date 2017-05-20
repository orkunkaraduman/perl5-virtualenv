#!/usr/bin/env perl
=head1 NAME

dist.pl - distribution generator

=head1 VERSION

version not defined

=head1 SYNOPSIS

distribution generator

=cut
use strict;
use warnings;
use v5.14;
use utf8;
use open qw(:utf8 :std);
use open IO => ':bytes';
use FindBin;
use Cwd;


my $main_pkg = "App::Virtualenv";
my $pod_path = "lib/" . $main_pkg =~ s/\:\:/\//gr . ".pm";
#my $pod_path = "doc/README.pod";

cwd("${FindBin::Bin}/..");
system("perl Makefile.PL");
system("pod2markdown --html-encode-chars 1 $pod_path > README.md");
system("pod2text $pod_path > README");
system("rm MANIFEST; make manifest");
system("make dist");

exit 0;
__END__
=head1 AUTHOR

Orkun Karaduman (ORKUN) <orkun@cpan.org>

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
