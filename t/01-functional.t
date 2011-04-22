#!/usr/bin/env perl
use strict;
use warnings;

# Disable IPv6, epoll and kqueue
BEGIN { $ENV{MOJO_NO_IPV6} = $ENV{MOJO_POLL} = 1 }

use Test::More;
plan tests => 21;

# testing code starts here
use Mojolicious::Lite;
use Test::Mojo;

my $dbname = 'mojolicious_plugin_mongodb_test_' . $$;
my $dbname2 = 'mojolicious_plugin_mongodb_test_2' . $$;

plugin 'mongodb', { 'database'  =>  $dbname };

get '/defaultdb' => sub {
    my $self = shift;
    $self->render(text => $self->app->defaultdb );
};

get '/connection' => sub {
    my $self = shift;
    $self->render(text => ref($self->app->connection));
};

get '/getdb' => sub {
    my $self = shift;
    $self->render(text => $self->db->name);
};

get '/getotherdb' => sub {
    my $self = shift;
    $self->render(text => $self->db($dbname2)->name);
};

get '/db-get-collection/:cname' => sub {
    my $self = shift;
    my $cname = $self->stash('cname');
    $self->render(text => $self->db->get_collection($cname)->name);
};

get '/db-coll/:cname' => sub {
    my $self = shift;
    my $cname = $self->stash('cname');
    $self->render(text => $self->coll($cname)->name);
};

get '/db-coll-full/:cname' => sub {
    my $self = shift;
    my $cname = $self->stash('cname');
    $self->render(text => $self->coll($cname, $dbname2)->full_name);
};

my $t = Test::Mojo->new;

$t->get_ok('/defaultdb')->status_is(200)->content_is($dbname);
$t->get_ok('/connection')->status_is(200)->content_is('MongoDB::Connection');
$t->get_ok('/getdb')->status_is(200)->content_is($dbname);
$t->get_ok('/getotherdb')->status_is(200)->content_is($dbname2);
$t->get_ok('/db-get-collection/test1')->status_is(200)->content_is('test1');
$t->get_ok('/db-coll/test1')->status_is(200)->content_is('test1');
$t->get_ok('/db-coll-full/test1')->status_is(200)->content_is("$dbname2.test1");
