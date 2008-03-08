#!/usr/bin/env perl
package TAEB::Action::Quaff;
use Moose;
extends 'TAEB::Action';

use constant command => "q";

has from => (
    is       => 'rw',
    isa      => 'TAEB::World::Item | Str',
    required => 1,
);

sub respond_drink_from {
    my $self = shift;
    my $msg  = shift;
    my $from = shift;

    # no, we want to drink an item, not from the floor tile
    return 'n' if blessed $self->from;

    # we're specific about this. really
    return 'y' if $from eq $self->from;

    # this means something probably went wrong. respond_drink_what will catch it
    return 'n';
}

sub respond_drink_what {
    my $self = shift;
    return $self->from->slot if blessed($self->from);

    TAEB->error("Unable to drink from '" . $self->into . "'. Sending escape, but I doubt this will work.");
    return "\e";
}

sub done {
    my $self = shift;
    if (blessed $self->from) {
        TAEB->inventory->decrease_quantity($self->from->slot)
    }
}

make_immutable;

1;

