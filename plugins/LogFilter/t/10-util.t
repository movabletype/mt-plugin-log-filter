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

use MT::Test qw( :db :data );
use Test::More tests => 9;

require_ok ('LogFilter::Util');

require MT;
require MT::Log;

MT::log ('abcdefg');

is (MT::Log->count ({ message => 'abcdefg'}), 1, "Log via class method works");

MT->log ('abcdefg');

is (MT::Log->count ({ message => 'abcdefg'}), 2, "Log via 'instance' method works");

MT->log ({ message => 'abcdefg' });

is (MT::Log->count ({ message => 'abcdefg'}), 3, "Log via 'hash' method works");

MT->config->LogExclude ('some_category');
LogFilter::Util->init;

MT::log ('abcdefg');

is (MT::Log->count ({ message => 'abcdefg'}), 4, "Log via class method works");

MT->log ('abcdefg');

is (MT::Log->count ({ message => 'abcdefg'}), 5, "Log via 'instance' method works");

MT->log ({ message => 'abcdefg' });

is (MT::Log->count ({ message => 'abcdefg'}), 6, "Log via 'hash' method works");

MT->log ({ message => 'abcdefg', category => 'some_category'});

is (MT::Log->count ({ message => 'abcdefg'}), 6, "Log via 'hash' method with blocked category didn't reach log");

MT->log ({ message => 'abcdefg', category => 'some_other_category'});

is (MT::Log->count ({ message => 'abcdefg'}), 7, "Log via 'hash' method with non-blocked category did reach log ");

1;
