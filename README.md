# NAME

App::Virtualenv - Perl virtual environment

# VERSION

version 1.12

# SYNOPSIS

Perl virtual environment

# DESCRIPTION

App::Virtualenv is a Perl package to create isolated Perl virtual environments, like Python virtual environment.

# USAGE

## virtualenv.pl

creates new Perl virtual environment

Usage: **virtualenv.pl** \[_environment\_path_\]

## activate

activates Perl virtual environment

Usage: source _environment\_path_/bin/**activate**

## deactivate

deactivates activated Perl virtual environment

Usage: **deactivate**

## sh.pl

runs Unix shell under Perl virtual environment

Usage: \[_environment\_path_/bin/\]**sh.pl** \[_argument_\]...

## perl.pl

runs Perl language interpreter under Perl virtual environment

Usage: \[_environment\_path_/bin/\]**perl.pl** \[_argument_\]...

## piv.pl

Perl in Virtual environment

Usage: \[_environment\_path_/bin/\]**piv.pl** \[-_option_\]... _command_ \[_parameter_\]...

\-h: _shows synopsis_

### piv virtualenv

creates new Perl virtual environment

Usage: **piv virtualenv** \[-e\] \[_environment\_path_\]

\-e: _Empty virtual environment_

### piv sh

runs Unix shell under Perl virtual environment

Usage: \[_environment\_path_/bin/\]**piv sh** \[_argument_\]...

### piv perl

runs Perl language interpreter under Perl virtual environment

Usage: \[_environment\_path_/bin/\]**piv perl** \[_argument_\]...

### piv list

lists installed packages under Perl virtual environment

Usage: \[_environment\_path_/bin/\]**piv list** \[-1\]

\-1: _One column list_

### piv install

installs or upgrades packages under Perl virtual environment

Usage: \[_environment\_path_/bin/\]**piv install** \[-f\] \[-t\] \[-s\] \[-v\] _package_...

\-f: _Force_

\-t: _Run tests_

\-s: _Soft install without installing prerequisites_

\-v: _Verbose_

### piv remove

removes packages under Perl virtual environment

Usage: \[_environment\_path_/bin/\]**piv remove** \[-f\] \[-v\] _package_...

\-f: _Force_

\-v: _Verbose_

# INSTALLATION

To install this module type the following

        perl Makefile.PL
        make
        make test
        make install

from CPAN

        cpan -i App::Virtualenv

# DEPENDENCIES

This module requires these other modules and libraries:

- Switch
- FindBin
- Cwd
- File::Basename
- local::lib
- Lazy::Utils
- ExtUtils::Installed
- ExtUtils::MakeMaker
- Module::Build
- Log::Log4perl
- Term::ReadLine
- YAML
- JSON
- LWP
- LWP::Protocol::https
- CPAN
- CPANPLUS
- CPANPLUS::Dist::Build

# REPOSITORY

**GitHub** [https://github.com/orkunkaraduman/perl5-virtualenv](https://github.com/orkunkaraduman/perl5-virtualenv)

**CPAN** [https://metacpan.org/release/App-Virtualenv](https://metacpan.org/release/App-Virtualenv)

# AUTHOR

Orkun Karaduman &lt;orkunkaraduman@gmail.com&gt;

# COPYRIGHT AND LICENSE

Copyright (C) 2017  Orkun Karaduman &lt;orkunkaraduman@gmail.com&gt;

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see &lt;http://www.gnu.org/licenses/&gt;.
