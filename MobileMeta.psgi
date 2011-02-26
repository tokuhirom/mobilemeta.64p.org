use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use MobileMeta::Web;
use Plack::Builder;

builder {
    enable 'Plack::Middleware::Static',
        path => qr{^(?:/static/|/robot\.txt$|/favicon.ico$)},
        root => File::Spec->catdir(dirname(__FILE__), 'htdocs');
    enable 'Plack::Middleware::Static',
        path => qr{^/dat/},
        root => './';
    enable 'Plack::Middleware::ReverseProxy';
    MobileMeta::Web->to_app();
};
