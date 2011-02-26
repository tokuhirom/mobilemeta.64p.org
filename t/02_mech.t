use strict;
use warnings;
use utf8;
use Test::More;
use Plack::Util;
use Test::WWW::Mechanize::PSGI;
use JSON;

my $app = Plack::Util::load_psgi('mobilemeta.psgi');
my $mech = Test::WWW::Mechanize::PSGI->new(app => $app);
$mech->get_ok('http://localhost/index.html');
$mech->get_ok('http://localhost/');
{
    my $res = $mech->get('http://localhost/api/list.json');
    ok($res->is_success);
    my $data = decode_json($res->decoded_content());
    is ref($data), 'ARRAY';
    like $res->decoded_content(), qr/\.json/;
}

done_testing;

