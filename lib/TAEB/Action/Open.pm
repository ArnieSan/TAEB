package TAEB::Action::Open;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Direction';

use constant command => 'o';

has '+direction' => (
    required => 1,
);

subscribe door => sub {
    my $self  = shift;
    my $event = shift;

    my $state = $event->state;
    my $door  = $event->tile;

    # The tile may have been changed between the announcement's origin and now
    return unless $door->isa('TAEB::World::Tile::Door');

    if ($state eq 'locked') {
        $door->state('locked');
    }
    elsif ($state eq 'resists') {
        $door->state('unlocked');
    }
};

sub is_impossible {
    return TAEB->is_polymorphed
        || TAEB->in_pit;
}

__PACKAGE__->meta->make_immutable;

1;

