use strict;
use warnings;

use Test::More;


BEGIN
{
	use_ok('App::Virtualenv');
	use_ok('App::Virtualenv::Utils');
	use_ok('App::Virtualenv::Module');
	use_ok('App::Virtualenv::Piv');
}
