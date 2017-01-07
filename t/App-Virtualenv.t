use strict;
use warnings;

use Test::More tests => 3;


BEGIN
{
	use_ok('App::Virtualenv');
	use_ok('App::Virtualenv::Module');
	use_ok('App::Virtualenv::Piv');
}
