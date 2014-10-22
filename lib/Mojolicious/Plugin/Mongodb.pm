use warnings;
use strict;
package Mojolicious::Plugin::Mongodb;
BEGIN {
  $Mojolicious::Plugin::Mongodb::VERSION = '1.07';
}
use Mojo::Base 'Mojolicious::Plugin';
use MongoDB;

sub register {
    my $self = shift;
    my $app  = shift;
    my $conf = shift || {}; 

    $conf->{helper} ||= 'db';

    $app->attr('defaultdb' => sub { delete($conf->{'database'}) || undef });
    $app->attr('mongodb_connection' => sub { MongoDB::Connection->new($conf) });
    $app->helper('connection' => sub {
        my $c = shift;
        warn q|Mojolicious::Plugin::Mongodb: the 'connection' attribute is deprecated, please use 'mongodb_connection' instead!|, "\n";
        return $c->mongodb_connection;
    });

    $app->helper($conf->{helper} => sub {
        my $self = shift;
        my $db   = shift || $self->app->defaultdb;
        return ($db) ? $self->app->mongodb_connection->get_database($db) : undef;
    }) unless($conf->{nohelper});

    $app->helper('coll' => sub {
        my $self = shift;
        my $coll = shift;
        my $db   = shift || $self->app->defaultdb;

        return undef unless($db && $coll);
        return $self->app->mongodb_connection->get_database($db)->get_collection($coll);
    });
}

1; 
__END__
=head1 NAME

Mojolicious::Plugin::Mongodb - Use MongoDB in Mojolicious

=head1 VERSION

version 1.07

=head1 SYNOPSIS

Provides a few helpers to ease the use of MongoDB in your Mojolicious application.

    use Mojolicious::Plugin::Mongodb

    sub startup {
        my $self = shift;
        $self->plugin('mongodb', { 
            host => 'localhost',
            port => 27017,
            database => 'default_database',
            helper => 'db',
            });
    }

=head1 CONFIGURATION OPTIONS

    helper      (optional)  The name to give to the easy-access helper if you want to change it's name from the default
    no_helper   (optional)  When set to true, no helper will be installed.
    database    (optional)  Set a default database you want to operate on

All other options passed to the plugin are used to connect to MongoDB.

=head1 HELPERS/ATTRIBUTES

=head2 connection

This attribute has been deprecated in favor of mongodb_connection.

=head2 mongodb_connection

This plugin attribute holds the MongoDB::Connection object, use this if you need to access it for some reason. 

=head2 db([dbname])

This helper will return the database you specify, if you don't specify one, then the default database is returned. If no default has been set and you have not specified a database name, undef will be returned. If you have renamed the helper, use that name instead of 'db' in the example below :)

    sub someaction {
        my $self = shift;

        # select a database yourself
        $self->db('my_snazzy_database')->get_collection('foo')->insert({ bar => 'baz' });

        # if you passed 'my_snazzy_database' during plugin load as the default, this is equivalent:
        $self->db->get_collection('foo')->insert({ bar => 'baz' });

        # if you want to be anal retentive about things in case no default exists and no database was passed:
        $self->db and $self->db->get_collection('foo')->insert({ bar => 'baz' });
    }

=head2 coll(collname, [dbname])

This helper allows easy access to a collection. If you don't pass the dbname argument, it will return the given collection inside the default database. If no default database exists, it will return undef.

    sub someaction {
        my $self = shift;

        # get the 'foo' collection in the default database
        my $collection = $self->coll('foo');

        # get the 'bar' collection in the 'baz' database
        my $collection = $self->coll('bar', 'baz');
    }


=head1 AUTHOR

Ben van Staveren, C<< <madcat at cpan.org> >>

=head1 BUGS/CONTRIBUTING

Please report any bugs through the web interface at L<http://github.com/benvanstaveren/mojolicious-plugin-mongodb/issues>  
If you want to contribute changes or otherwise involve yourself in development, feel free to fork the Git repository from
L<https://github.com/benvanstaveren/mojolicious-plugin-mongodb/>.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Mojolicious::Plugin::Mongodb


You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Mojolicious-Plugin-Mongodb>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Mojolicious-Plugin-Mongodb>

=item * Search CPAN

L<http://search.cpan.org/dist/Mojolicious-Plugin-Mongodb/>

=back


=head1 ACKNOWLEDGEMENTS

Based on L<Mojolicious::Plugin::Database> because I don't want to leave the MongoDB crowd in the cold.

Thanks to Henk van Oers for pointing out a few errors in the documentation, and letting me know I should really fix the MANIFEST

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Ben van Staveren.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut