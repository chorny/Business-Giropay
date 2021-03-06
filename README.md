# NAME

Business::Giropay - Giropay payments API

# VERSION

Version 0.102

# DESCRIPTION

**Business::Giropay** implement's Giropay's GiroCheckout API to make direct
calls to Giropay's payments server.

Giropay facilitates payments via various provider networks in addition to 
their own. This module currently supports the following networks:

- eps - EPS (Austria)
- giropay - Giropay's own network (Germany)
- ideal - iDEAL (The Netherlands)

Contributions to allow this module to support other networks available via
Giropay are most welcome.

# SYNOPSIS

    use Business::Giropay;

    my $giropay = Business::Giropay->new(
        network    => 'giropay',
        merchantId => '123456789',
        projectId  => '1234567',
        sandbox    => 1,
        secret     => 'project_secret',
    );

    my $response = $giropay->transaction(
        merchantTxId => 'tx-10928374',
        amount       => 2938,               # 29.38 in cents
        currency     => 'EUR',
        purpose      => 'Test Transaction',
        bic          => 'TESTDETT421',
        urlRedirect  => 'https://www.example.com/return_page',
        urlNotify    => 'https://www.example.com/api/giropay/notify',
    );

    if ( $response->success ) {
        # all is good so redirect customer to GiroCheckout
    }
    else {
        # transaction request failed
    }

`urlRedirect` and `urlNotify` can also be passed to `new`:

    use Business::Giropay;

    my $giropay = Business::Giropay->new(
        network     => 'giropay',
        merchantId  => '123456789',
        projectId   => '1234567',
        urlRedirect => 'https://www.example.com/return_page',
        urlNotify   => 'https://www.example.com/api/giropay/notify',
        sandbox     => 1,
        secret      => 'project_secret',
    );

    my $response = $giropay->transaction(
        merchantTxId => 'tx-10928374',
        amount       => 2938,               # 29.38 in cents
        currency     => 'EUR',
        purpose      => 'Test Transaction',
        bic          => 'TESTDETT421',
    );

    if ( $response->success ) {
        # all is good so redirect customer to GiroCheckout
    }
    else {
        # transaction request failed
    }

Elsewhere in your `urlNotify` route:

    my $notification = $giropay->notification( %request_params );

    if ( $notification->success ) {
        # save stuff in DB - customer probably still on bank site
    }
    else {
        # bad stuff happened - make a note of it
    }

And in the `urlRedirect` route:

    my $notification = $giropay->notification( %request_params );

    if ( $notification->success ) {
        # we should already have earlier notification but check anyway
        # in case customer came back before we received it then thank
        # customer for purchase
    }
    else {
        # bad stuff - check out the details and tell the customer
    }

# ATTRIBUTES

See ["ATTRIBUTES" in Business::Giropay::Role::Core](https://metacpan.org/pod/Business::Giropay::Role::Core#ATTRIBUTES) for full details of the
following attributes that can be passed to `new`.

- network
- merchantId
- projectId
- sandbox
- secret

See ["ATTRIBUTES" in Business::Giropay::Role::Urls](https://metacpan.org/pod/Business::Giropay::Role::Urls#ATTRIBUTES) for full details of the
following attributes that can be passed to `new`.

- urlRedirect
- urlNotify

# METHODS

**NOTE:** it is not necessary to pass in any attributes that were already
passed to `new` since they are passed through automatically.

## bankstatus %attributes

This API call checks if a bank supports the giropay/eps payment method.

Returns a [Business::Giropay::Response::Bankstatus](https://metacpan.org/pod/Business::Giropay::Response::Bankstatus) object.

See ["ATTRIBUTES" in Business::Giropay::Request::Bankstatus](https://metacpan.org/pod/Business::Giropay::Request::Bankstatus#ATTRIBUTES) for full details of
the following attribute that can be passed to this method:

- bic

## issuer

Returns a [Business::Giropay::Response::Issuer](https://metacpan.org/pod/Business::Giropay::Response::Issuer) object which includes a
list which contains all supported giropay/eps/ideal issuer banks.

## transaction %attributes

This API call creates the start of a transaction and returns a
[Business::Giropay::Response::Transaction](https://metacpan.org/pod/Business::Giropay::Response::Transaction) object. If the response indicates
success then customer can be redirected to
["redirect" in Business::Giropay::Response::Transaction](https://metacpan.org/pod/Business::Giropay::Response::Transaction#redirect) to complete payment.

Returns a [Business::Giropay::Response::Transaction](https://metacpan.org/pod/Business::Giropay::Response::Transaction) object.

See ["ATTRIBUTES" in Business::Giropay::Request::Transaction](https://metacpan.org/pod/Business::Giropay::Request::Transaction#ATTRIBUTES) for full details of
the following attributes that can be passed to this method:

- merchantTxId
- amount
- currency
- purpose
- bic
- urlRedirect
- urlNotify

## notification %query\_params

Accepts query parameters and returns a [Business::Giropay::Notification](https://metacpan.org/pod/Business::Giropay::Notification)
object.

## status %attributes

Returns a [Business::Giropay::Response::Status](https://metacpan.org/pod/Business::Giropay::Response::Status) object with details of
the requested transaction.

See ["ATTRIBUTES" in Business::Giropay::Request::Status](https://metacpan.org/pod/Business::Giropay::Request::Status#ATTRIBUTES) for full details of
the following attribute that can be passed to this method:

- reference

# SEE ALSO

[GiroCheckout API](http://api.girocheckout.de/en:start) which has links for
the various payment network types (giropay, eps, etc). For ["status"](#status) see
[http://api.girocheckout.de/en:tools:transaction\_status](http://api.girocheckout.de/en:tools:transaction_status).

# TODO

Add more of Giropay's payment networks.

# ACKNOWLEDGEMENTS

Many thanks to [CALEVO Equestrian](https://www.calevo.com/) for sponsoring
development of this module.

# LICENSE AND COPYRIGHT

Copyright 2016 Peter Mottram (SysPete) &lt;peter@sysnix.com>

This program is free software; you can redistribute it and/or modify it
under the terms of Perl itself.
