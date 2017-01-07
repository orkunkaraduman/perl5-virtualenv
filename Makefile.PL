use strict;
use warnings;
use ExtUtils::MakeMaker;


WriteMakefile(
	NAME				=> 'App::Virtualenv',
	VERSION_FROM		=> 'lib/App/Virtualenv.pm',
	MIN_PERL_VERSION	=> '5.014',
	PREREQ_PM			=> {
		'Switch' => 0,
		'FindBin' => 0,
		'Cwd' => 0,
		'File::Basename' => 0,
		'local::lib' => 0,
		'Lazy::Utils' => '1.04',
		'ExtUtils::Installed' => 0,
		'ExtUtils::MakeMaker' => 0,
		'Module::Build' => 0,
		'Log::Log4perl' => 0,
		'Term::ReadLine' => 0,
		'YAML' => 0,
		'JSON' => 0,
		'LWP' => 0,
		'LWP::Protocol::https' => 0,
		'CPAN' => 0,
		'CPANPLUS' => 0,
		'CPANPLUS::Dist::Build' => 0,
	},
	EXE_FILES			=> [qw(
		lib/App/Virtualenv/virtualenv.pl
		lib/App/Virtualenv/sh.pl
		lib/App/Virtualenv/perl.pl
		lib/App/Virtualenv/piv.pl
		lib/App/Virtualenv/piv
	)],
	AUTHOR				=> 'Orkun Karaduman <orkunkaraduman@gmail.com>',
	ABSTRACT			=> 'Perl virtual environment',
	LICENSE				=> 'gpl_3',
	META_MERGE			=> {
		"meta-spec" => {
			version => 2,
		},
		resources => {
			homepage   => 'https://metacpan.org/release/App-Virtualenv',
			license    => 'https://www.gnu.org/licenses/gpl-3.0.html',
			repository => {
				type => 'git',
				url => 'git://git@github.com:orkunkaraduman/perl5-virtualenv.git',
				web => 'https://github.com/orkunkaraduman/perl5-virtualenv',
			},
			bugtracker => {
				web    => 'https://github.com/orkunkaraduman/perl5-virtualenv/issues',
				mailto => 'bug-App-Virtualenv@rt.cpan.org',
			},
		},
	},
);
