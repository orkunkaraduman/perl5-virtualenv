# NAME

App::Virtualenv - Perl virtual environment

# VERSION

version 1.10

# SYNOPSIS

Perl virtual environment

# DESCRIPTION

App::Virtualenv is a Perl package to create isolated Perl virtual environments, like Python virtual environment.

# USAGE

## virtualenv.pl

creates new Perl virtual environment

> **virtualenv.pl** \[_environment\_path_\]

## activate

activates Perl virtual environment

> source _environment\_path_/bin/**activate**

## deactivate

deactivates activated Perl virtual environment

> **deactivate**

## sh.pl

runs Unix shell under Perl virtual environment

> \[_environment\_path_/bin/\]**sh.pl** \[_argument_\]...

## perl.pl

runs Perl language interpreter under Perl virtual environment

> \[_environment\_path_/bin/\]**perl.pl** \[_argument_\]...

## piv.pl

Perl in Virtual environment

> \[_environment\_path_/bin/\]**piv.pl** \[-_argument_\]... \[--_argument_ _value_\]... _command_ \[_parameter_\]...

### Commands

#### piv virtualenv

creates new Perl virtual environment

> **piv virtualenv** \[-e\] \[_environment\_path_\]
>
> > **-e** Empty virtual environment

#### piv sh

runs Unix shell under Perl virtual environment

> \[_environment\_path_/bin/\]**piv sh** \[_argument_\]...

#### piv perl

runs Perl language interpreter under Perl virtual environment

> \[_environment\_path_/bin/\]**piv perl** \[_argument_\]...

#### piv list

lists installed packages under Perl virtual environment

> \[_environment\_path_/bin/\]**piv list** \[-1\]
>
> > **-1** One column list

#### piv install

installs or upgrades packages under Perl virtual environment

> \[_environment\_path_/bin/\]**piv install** \[-f\] \[-t\] \[-s\] \[-v\] _package_...
>
> > **-f** Force
> >
> > **-t** Run tests
> >
> > **-s** Soft install without installing prerequisites
> >
> > **-v** Verbose

#### piv remove

removes packages under Perl virtual environment

> \[_environment\_path_/bin/\]**piv remove** \[-f\] \[-v\] _package_...
>
> > **-f** Force
> >
> > **-v** Verbose

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

- local::lib
- Switch
- FindBin
- Cwd
- File::Basename
- ExtUtils::Installed
- CPAN
- CPANPLUS

# AUTHOR

Orkun Karaduman &lt;orkunkaraduman@gmail.com&gt;

# COPYRIGHT AND LICENSE

Copyright (C) 2016  Orkun Karaduman &lt;orkunkaraduman@gmail.com&gt;

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
