use strict;
use warnings;
use v5.10;
use ExtUtils::MakeMaker;


WriteMakefile(
	NAME				=> 'App::Virtualenv',
	VERSION				=> '1.05',
	MIN_PERL_VERSION	=> 'v5.10',
	PREREQ_PM			=> { 'local::lib' => 0, 'Switch' => 0, 'FindBin' => 0, 'Cwd' => 0, 'File::Basename' => 0, 'CPAN' => 0, 'ExtUtils::Installed' => 0, },
	EXE_FILES			=> [ qw(lib/App/Virtualenv/virtualenv.pl lib/App/Virtualenv/shell.pl) ],
	AUTHOR				=> 'Orkun Karaduman <orkunkaraduman@gmail.com>',
	ABSTRACT			=> 'Virtual environment for Perl 5',
	LICENSE				=> 'gpl_3',
	META_MERGE			=> {
		"meta-spec" => { version => 2 },
		resources => {
			repository => {
				type => 'git',
				url => 'git://git@github.com:orkunkaraduman/perl5-virtualenv.git',
				web => 'https://github.com/orkunkaraduman/perl5-virtualenv',
			},
		},
	},
);
