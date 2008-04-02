#!/usr/bin/env perl
package TAEB::AI::Personality::Human;
use TAEB::OO;
extends 'TAEB::AI::Personality';

=head1 NAME

TAEB::AI::Personality::Human - the only personality that has a chance

=head1 VERSION

Version 0.01 released ???

=cut

our $VERSION = '0.01';

=head2 next_action TAEB -> STRING

This will consult a magic 8-ball to determine what move to make next.

=cut

sub next_action {
    while (1) {
        my $c = TAEB->get_key;

        if ($c eq "~") {
            TAEB->notify(TAEB->keypress(TAEB->get_key));
        }
        else {
            return TAEB::Action->new_action(custom => string => $c);
        }
    }
}

=head1 IDEA BY

arcanehl

=cut

__PACKAGE__->meta->make_immutable;
no Moose;

1;

