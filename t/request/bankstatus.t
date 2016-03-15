use Test::More;
use Test::Exception;

use aliased 'Business::Giropay::Request::Bankstatus';

my $request;

throws_ok { $request = Bankstatus->new }
qr/Missing required arguments: bic, merchantId, projectId, secret/,
  "Request class with no parameters method dies";

lives_ok {
    $request = Bankstatus->new(
        merchantId => 1234567,
        projectId  => 1234,
        bic        => 'TESTDETT421',
        secret     => 'secure'
    );
}
"good request lives";

cmp_ok $request->hash, 'eq', '8fa3b55d66d47c8d5f0b6a42748747b0', 'hash is good';

cmp_ok $request->url, 'eq',
  'https://payment.girosolution.de/girocheckout/api/v2/giropay/bankstatus',
  'url is good';

done_testing;
