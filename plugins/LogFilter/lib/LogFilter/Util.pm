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
    *MT::log = sub {

        # cases:
        #   MT::log ($msg)
        #   MT->log ($msg)
        #   MT->log ({ hash }) <- this is the one we can block
        return 1
          if (
            @_ > 1
            && (
                (
                       ( ref( $_[1] ) eq 'HASH' )
                    && ( $_[1]->{category} )
                    && ( $excluded{ $_[1]->{category} } )
                )
                || (   ( ref( $_[1] ) eq 'MT::Log' )
                    && ( $excluded{ $_[1]->category } ) )
            )
          );

        $orig_log->(@_);
    };
}

1;
