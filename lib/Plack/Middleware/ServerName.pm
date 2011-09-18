package Plack::Middleware::ServerName;

use strict;
use warnings;

use Data::Dumper;

use parent qw(Plack::Middleware);
use Plack::Util;

sub call {
    my ( $self, $env ) = @_;
    my $res  = $self->app->($env);

    Plack::Util::response_cb( $res, sub {
        my $res = shift();

        my %response_headers = @{ $res->[1] };
        delete $response_headers{ $_ } foreach ( grep { /^server$/i } keys %response_headers );
        $response_headers{Server} = $self->{name} if( defined( $self->{name} ) );

        $res->[1] = [ map { $_, $response_headers{$_} } ( keys %response_headers ) ];

        return;
    } );
}

1;
__END__

=head1 NAME

Plack::Middleware::ServerName - sets/fakes the name of the webserver processing the
requests

=head1 SYNOPSIS

  use Plack::Builder;

  builder {
      enable "Plack::Middleware::ServerName",
          name => 'Apache';
      $app;
  };

=head1 DESCRIPTION

Plack::Middleware::ServerName is a middleware that allows to fakes the response
Server header by removing it ( if name is undef ) or setting it to a defined
value.

=head1 CONFIGURATIONS

=over

=item name

  name => 'Apache'
  name => 'My-Own-WebServer/0.01'

string that defines/fakes the server's name

=back

=head1 SEE ALSO

L<Plack::Middleware>

=head1 AUTHOR

Sorin Pop E<lt>sorin.pop {at} evozon.comE<gt>

=head1 LICENSE

This software is copyright (c) 2011 by Sorin Pop.

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
