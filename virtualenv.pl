#!/usr/bin/perl
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use utf8;

use App::virtualenv;


my ($envPath) = @ARGV;
App::virtualenv::create($envPath);

exit 0;
