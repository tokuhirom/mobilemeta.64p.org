package MobileMeta;
use strict;
use warnings;
use parent qw/Amon2/;
our $VERSION='0.01';
use 5.008001;

use Amon2::Config::Simple;
sub load_config { Amon2::Config::Simple->load(shift) }

1;
