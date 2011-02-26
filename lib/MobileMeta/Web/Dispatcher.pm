package MobileMeta::Web::Dispatcher;
use strict;
use warnings;

use Amon2::Web::Dispatcher::Lite;
use Path::Class;
use Time::Piece;

any '/' => sub {
    my ($c) = @_;

    my @entries =
      map { $_ = $_->relative( $c->base_dir );
        +{
            basename => $_->basename,
            mtime    => Time::Piece->new($_->stat->mtime)->strftime('%Y-%m-%d'),
        }
      }
      dir( $c->base_dir(), 'dat' )->children();

    $c->render('index.tt', {entries => \@entries});
};

1;
