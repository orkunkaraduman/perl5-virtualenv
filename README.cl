[1mNAME[0m
    App::Virtualenv - Perl virtual environment

[1mVERSION[0m
    version 1.11

[1mSYNOPSIS[0m
    Perl virtual environment

[1mDESCRIPTION[0m
    App::Virtualenv is a Perl package to create isolated Perl virtual
    environments, like Python virtual environment.

[1mUSAGE[0m
  [1mvirtualenv.pl[0m
    creates new Perl virtual environment

        [1mvirtualenv.pl[0m [[33menvironment_path[0m]

  [1mactivate[0m
    activates Perl virtual environment

        source [33menvironment_path[0m/bin/[1mactivate[0m

  [1mdeactivate[0m
    deactivates activated Perl virtual environment

        [1mdeactivate[0m

  [1msh.pl[0m
    runs Unix shell under Perl virtual environment

        [[33menvironment_path[0m/bin/][1msh.pl[0m [[33margument[0m]...

  [1mperl.pl[0m
    runs Perl language interpreter under Perl virtual environment

        [[33menvironment_path[0m/bin/][1mperl.pl[0m [[33margument[0m]...

  [1mpiv.pl[0m
    Perl in Virtual environment

        [[33menvironment_path[0m/bin/][1mpiv.pl[0m [-[33margument[0m]... [--[33margument[0m [33mvalue[0m]...
        [33mcommand[0m [[33mparameter[0m]...

   Commands
   piv virtualenv
    creates new Perl virtual environment

        [1mpiv virtualenv[0m [-e] [[33menvironment_path[0m]

            [1m-e[0m Empty virtual environment

   piv sh
    runs Unix shell under Perl virtual environment

        [[33menvironment_path[0m/bin/][1mpiv sh[0m [[33margument[0m]...

   piv perl
    runs Perl language interpreter under Perl virtual environment

        [[33menvironment_path[0m/bin/][1mpiv perl[0m [[33margument[0m]...

   piv list
    lists installed packages under Perl virtual environment

        [[33menvironment_path[0m/bin/][1mpiv list[0m [-1]

            [1m-1[0m One column list

   piv install
    installs or upgrades packages under Perl virtual environment

        [[33menvironment_path[0m/bin/][1mpiv install[0m [-f] [-t] [-s] [-v] [33mpackage[0m...

            [1m-f[0m Force

            [1m-t[0m Run tests

            [1m-s[0m Soft install without installing prerequisites

            [1m-v[0m Verbose

   piv remove
    removes packages under Perl virtual environment

        [[33menvironment_path[0m/bin/][1mpiv remove[0m [-f] [-v] [33mpackage[0m...

            [1m-f[0m Force

            [1m-v[0m Verbose

[1mINSTALLATION[0m
    To install this module type the following

            perl Makefile.PL
            make
            make test
            make install

    from CPAN

            cpan -i App::Virtualenv

[1mDEPENDENCIES[0m
    This module requires these other modules and libraries:

    *   local::lib

    *   Switch

    *   FindBin

    *   Cwd

    *   File::Basename

    *   ExtUtils::Installed

    *   CPAN

    *   CPANPLUS

[1mAUTHOR[0m
    Orkun Karaduman <orkunkaraduman@gmail.com>

[1mCOPYRIGHT AND LICENSE[0m
    Copyright (C) 2016 Orkun Karaduman <orkunkaraduman@gmail.com>

    This program is free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the
    Free Software Foundation, either version 3 of the License, or (at your
    option) any later version.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
    Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program. If not, see <http://www.gnu.org/licenses/>.

