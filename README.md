# perl5-virtualenv
###### Virtual environment for Perl 5

perl5-virtualenv is a tool to create isolated Perl 5 virtual environments, like Python virtual environment.

## USAGE

### virtualenv.pl

creates new Perl virtual environment

> virtualenv.pl [*environment_path*]

### sh.pl

runs Unix shell under Perl virtual environment

> [*environment_path*/bin/]sh.pl

### perl.pl

runs Perl language interpreter under Perl virtual environment

> [*environment_path*/bin/]perl.pl [*argument*]...

### shell.pl

runs Perl shell interpreter under Perl virtual environment

> [*environment_path*/bin/]shell.pl

### activate

activates Perl virtual environment

> source *environment_path*/bin/activate

### deactivate

deactivates activated Perl virtual environment

> deactivate

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

> cpan App::Virtualenv

## DEPENDENCIES

This module requires these other modules and libraries:

* local::lib
* Switch
* FindBin
* Cwd
* File::Basename
* Perl::Shell

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
