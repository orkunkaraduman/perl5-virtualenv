=Copyright
	Copyright (C) 2016  Orkun Karaduman <orkunkaraduman@gmail.com>
=GPLv3
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


use strict;
use warnings;
use v5.10;
use ExtUtils::MakeMaker;


WriteMakefile(
	NAME				=> 'perl5-virtualenv',
	VERSION_FROM		=> 'lib/App/virtualenv.pm',
	PREREQ_PM			=> {'local::lib' => 0, 'Switch' => 0, 'FindBin' => 0, 'Cwd' => 0, 'File::Basename' => 0},
	AUTHOR				=> 'Orkun Karaduman <orkunkaraduman@gmail.com>',
	ABSTRACT			=> 'Virtual environment for Perl 5',
	EXE_FILES			=> [ qw(lib/App/virtualenv/virtualenv.pl lib/App/virtualenv/sh.pl lib/App/virtualenv/perl.pl) ],
);
