use strict;
use warnings;
use Test::More;

use_ok $_ for qw(
    MobileMeta
    MobileMeta::DBI
    MobileMeta::Web
    MobileMeta::Web::Dispatcher
);

done_testing;
