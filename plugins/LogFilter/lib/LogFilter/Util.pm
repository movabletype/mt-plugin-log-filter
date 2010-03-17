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

package LogFilter::Util;

use strict;
use warnings;

sub init {
    require MT;

    my $log_exclude = MT->config->LogExclude;
    return 1 unless $log_exclude;
    my %excluded = map { $_ => 1 } split( /\s*,\s*/, $log_exclude );

    no warnings 'redefine';
    my $orig_log = \&MT::log;
    *MT::log = sub { filtered_log( $orig_log,, \%excluded, @_ ) };

    1;
}

sub init_app {
    my ( $plugin, $app ) = @_;
    my $log_exclude     = MT->config->LogExclude;
    my $log_exclude_app = MT->config->LogExcludeApp;
    return 1 unless ( $log_exclude || $log_exclude_app );
    my %excluded_apps = map { $_ => 1 } split( /\s*,\s*/, $log_exclude_app );
    my %excluded      = map { $_ => 1 } split( /\s*,\s*/, $log_exclude );

    no warnings 'redefine';
    my $orig_log = \&MT::App::log;
    if ( $excluded_apps{ $app->id } ) {
        *MT::App::log = sub { 1 };
    }
    else {
        *MT::App::log = sub { filtered_log( $orig_log, \%excluded, @_ ); };
    }

    1;
}

sub filtered_log {
    my $orig_log = shift;
    my $excluded = shift;

    # cases:
    #   MT::log ($msg)
    #   MT->log ($msg)
    #   MT->log ({ hash }/$obj) <- this is the one we can block
    return 1
      if (
        @_ > 1
        && (
            (
                   ( ref( $_[1] ) eq 'HASH' )
                && ( $_[1]->{category} )
                && ( $excluded->{ $_[1]->{category} } )
            )
            || (   ( ref( $_[1] ) eq 'MT::Log' )
                && ( $excluded->{ $_[1]->category } ) )
        )
      );

    $orig_log->(@_);
}

1;
