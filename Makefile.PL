use 5.010;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	NAME				=> 'perl5-virtualenv',
	VERSION_FROM		=> 'lib/App/virtualenv.pm',
	PREREQ_PM			=> {'local::lib' => 0, 'Cwd' => 0, 'FindBin' => 0, 'File::Basename' => 0},
	AUTHOR				=> 'Orkun Karaduman <orkunkaraduman@gmail.com>',
	ABSTRACT			=> 'Virtual environment for Perl 5',
	EXE_FILES			=> [ qw(bin/virtualenv.pl) ],
);
