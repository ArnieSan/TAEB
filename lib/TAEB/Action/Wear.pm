package TAEB::Action::Wear;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Item';

has '+item' => (
    required => 1,
);

# Only matters if we have a choice in the matter (i.e. rings)
has 'slot' => (
    isa     => 'Str',
    is      => 'ro',
    default => 'left_hand',
);

sub command {
    my $self = shift;
    my $item = $self->item;

    return 'W' if $item->type eq 'armor';
    return 'P';
}

sub respond_wear_what { shift->item->slot }

# yes, it makes the AI simpler if we know what slot we're putting stuff in
sub respond_which_finger {
    my $self = shift;

    $self->slot eq 'right_ring' ? 'r' : 'l';
}

sub done {
    my $self = shift;

    if ($self->item->type eq 'ring') {
        $self->item->hand($self->slot eq 'right_hand' ? 'right' : 'left');
    }

    $self->item->is_worn(1);
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

