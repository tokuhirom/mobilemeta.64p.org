package MobileMeta::Web::Dispatcher;
use strict;
use warnings;

use Amon2::Web::Dispatcher::Lite;
use Path::Class;
use Time::Piece;
use Module::Find;
use autodie;

my @modules = grep !/ThirdForce/,
  grep !/WWW::MobileCarrierJP::Declare/, useall('WWW::MobileCarrierJP');
my %filename2module = (
    map {
        do {
            my $fname = $_;
            $fname =~ s/^WWW::MobileCarrierJP:://;
            $fname =~ s/::/-/g;
            lc($fname) . '.json';
        } => $_
    }
    @modules
);
my $module2src_path = +{
    map { $_ => do {
        my $path = $_;
        $path =~ s!::!/!g;
        $path .= '.pm';
        $INC{$path};
    }}
    @modules
};
my $module2name = +{
    map { $_ => do {
        open my $fh, '<:utf8', $module2src_path->{$_};
        my $content = do { local $/; <$fh> };
        $content =~ /=head1\s+NAME\n+WWW.+?\s+-\s+(.+)\n/;
        $1;
    }} @modules
};

any '/' => sub {
    my ($c) = @_;

    my @entries =
      map { $_ = $_->relative( $c->base_dir );
        my $basename = $_->basename;
        my $module = $filename2module{$basename};
        my $url = $module->url;
        +{
            basename => $basename,
            mtime    => Time::Piece->new($_->stat->mtime)->strftime('%Y-%m-%d'),
            module   => $module,
            urls     => ref($url) ? $url : [$url],
            name     => $module2name->{$module},
        }
      }
      dir( $c->base_dir(), 'dat' )->children();

    $c->render('index.tt', {entries => \@entries});
};

any '/dat/*.json' => sub {
    my ($c) = @_;
    my $fname = $c->req->path_info;
    open my $fh, '<', File::Spec->catfile($c->base_dir(), $fname);
    return $c->create_response(
        200,
        [
            'Content-Length' => -s $fh,
            'Content-Type'   => 'application/json; charset=utf-8'
        ],
        $fh
    );
};

1;
