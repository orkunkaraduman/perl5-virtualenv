#! /usr/bin/perl

use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use open qw(:std :locale);
use utf8;
use Perl::Shell;
use POSIX qw(:locale_h);
use locale;

use lib './lib';
use App::virtualenv;

setlocale LC_ALL, 'en_US.UTF-8';

exit App::virtualenv::shell(undef, @ARGV);
