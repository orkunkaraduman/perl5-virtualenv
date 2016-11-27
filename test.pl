#! /usr/bin/perl

use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use open qw(:std :locale);
use utf8;

use lib './lib';
use App::virtualenv;


exit App::virtualenv::shell(undef, @ARGV);
