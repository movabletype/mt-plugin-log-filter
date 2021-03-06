##############################################################################
# Copyright © 2009 Six Apart Ltd.
# This program is free software: you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as published
# by the Free Software Foundation, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
# version 2 for more details. You should have received a copy of the GNU
# General Public License version 2 along with this program. If not, see
# <http://www.gnu.org/licenses/>.

use lib qw( t/lib lib extlib );

use strict;
use warnings;

use MT::Test;
use Test::More tests => 2;

require MT;
ok( MT->component('logfilter'), 'LogFilter loaded' );
require_ok('LogFilter::Util');

1;
