# perl5-virtualenv
###### Virtual environment for Perl 5

perl5-virtualenv is a tool to create isolated Perl 5 virtual environments, like Python virtual environment.

## USAGE

### virtualenv.pl

creates new Perl virtual environment

> virtualenv.pl [*environment_path*]

### activate

activates Perl virtual environment

> source *environment_path*/bin/activate

### deactivate

deactivates activated Perl virtual environment

> deactivate

### sh.pl

runs Unix shell under Perl virtual environment

> [*environment_path*/bin/]sh.pl [*argument*]...

### perl.pl

runs Perl language interpreter under Perl virtual environment

> [*environment_path*/bin/]perl.pl [*argument*]...

### piv.pl

wrapper for Perl in Virtual environment

> [*environment_path*/bin/]piv.pl [-*arg*]... [--*arg* *value*]... *cmd* [*param*]...

#### piv virtualenv

creates new Perl virtual environment

> piv virtualenv [-e] [*environment_path*]

#### piv sh

runs Unix shell under Perl virtual environment

> [*environment_path*/bin/]piv sh [*argument*]...

#### piv perl

runs Perl language interpreter under Perl virtual environment

> [*environment_path*/bin/]piv perl [*argument*]...

#### piv list

list installed packages under Perl virtual environment

> [*environment_path*/bin/]piv list [-1]

**-1** One column list

#### piv install

install or upgrade packages under Perl virtual environment

> [*environment_path*/bin/]piv install [-f] [-t] [-s] *package*...

**-f** Force

**-t** Run tests

**-s** Soft install without installing prerequisites

#### piv remove

remove packages under Perl virtual environment

> [*environment_path*/bin/]piv remove [-f] *package*...

**-f** Force

## INSTALLATION

To install this module type the following

> perl Makefile.PL
>
> make
>
> make test
>
> make install

from CPAN

> cpan -i App::Virtualenv

## DEPENDENCIES

This module requires these other modules and libraries:

* local::lib
* Switch
* FindBin
* Cwd
* File::Basename
* ExtUtils::Installed
* CPAN
* CPANPLUS

## COPYRIGHT AND LICENCE

Copyright (C) 2016  Orkun Karaduman <<orkunkaraduman@gmail.com>>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <<http://www.gnu.org/licenses/>>.
