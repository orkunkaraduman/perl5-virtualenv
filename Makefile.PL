use strict;
use warnings;
use v5.10;
use ExtUtils::MakeMaker;


WriteMakefile(
	NAME				=> 'perl5-virtualenv',
	VERSION_FROM		=> 'lib/App/virtualenv.pm',
	PREREQ_PM			=> {'local::lib' => 0, 'Switch' => 0, 'FindBin' => 0,, 'Cwd' => 0 'File::Basename' => 0},
	AUTHOR				=> 'Orkun Karaduman <orkunkaraduman@gmail.com>',
	ABSTRACT			=> 'Virtual environment for Perl 5',
	EXE_FILES			=> [ qw(bin/virtualenv.pl bin/sh.pl) ],
);
