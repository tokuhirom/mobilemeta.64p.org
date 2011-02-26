package MobileMeta;
use strict;
use warnings;
use parent qw/Amon2/;
our $VERSION='0.01';
use 5.008001;

sub load_config { +{ 'Text::Xslate' => {} } }

1;
