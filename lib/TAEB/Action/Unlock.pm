package TAEB::Action::Unlock;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Direction';
with 'TAEB::Action::Role::Item' => { items => [qw/implement/] };

use constant command => 'a';

has '+implement' => (
    required => 1,
);

has '+direction' => (
    required => 1,
);

sub respond_apply_what { shift->implement->slot }

sub respond_lock {
    shift->target_tile('closeddoor')->state('unlocked');
    'n';
}

sub respond_unlock { 'y' }

subscribe door => sub {
    my $self  = shift;
    my $event = shift;

    my $tile  = $event->door;
    my $state = $event->state;

    if ($state eq 'just_unlocked') {
        $tile->state('unlocked');
    }
    elsif ($state eq 'interrupted_locking') {
        $tile->state('locked');
    }
};

__PACKAGE__->meta->make_immutable;

1;

