package TAEB::AI::ErrorOut;
use TAEB::OO;
extends 'TAEB::AI';

=head1 NAME

TAEB::AI::ErrorOut - An AI that can't possibly work, for testing

=cut

# When asked for an action, throw an error to see how well the rest of
# the framework handles it.
sub next_action { die 'TAEB::AI::ErrorOut intentionally threw an error' }

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

