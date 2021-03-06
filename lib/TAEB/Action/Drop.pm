package TAEB::Action::Drop;
use Moose;
use TAEB::OO;
use TAEB::Util 'refaddr';
extends 'TAEB::Action';
with 'TAEB::Action::Role::Item';

use constant command => "D";

has items => (
    is       => 'ro',
    isa      => 'ArrayRef[NetHack::Item]',
    provided => 1,
);

has sell => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

subscribe query_dropitems => sub {
    my $self = shift;
    my $event = shift;

    my %drop;
    for my $item (@{ $self->items }) {
        $drop{refaddr $item} = $item;
    }

    for my $menu_item ($event->all_menu_items) {
        my $item = $menu_item->user_data;
        if ($drop{refaddr $item}) {
            $menu_item->selected(1);
            $menu_item->quantity('all');
            delete $drop{refaddr $item};
        }
    }

    TAEB->log->inventory("Tried to drop item I don't have: $_")
        for values %drop;
};

sub respond_sell_item {
    my $self = shift;
    my ($seller, $shk_short_funds, $cost, $item) = @_;

    # Sell it all.
    if ($self->sell) {
        return 'a';
    }

    return 'n';
}

sub done {
    my $self = shift;

    for my $item (@{ $self->items }) {
        # dropping a part of the stack
        #if (ref($drop) && $$drop < $item->quantity) {
        #    my $new_item = $item->fork_quantity($$drop);
        #    TAEB->send_message('floor_item' => $new_item);
        #}
        ## dropping the whole stack
        #elsif ($drop) {
            TAEB->inventory->remove($item->slot);
            TAEB->send_message('floor_item' => $item);
        # }
    }
}

sub exception_drop_wearing {
    my $self = shift;

    if (@{ $self->items } == 1) {
        $self->items->[0]->is_worn(1);
    }
    else {
        # who knows what item it was
        TAEB->send_message(check => "inventory");
        TAEB->send_message(check => "floor");
        TAEB->log->action("We are wearing an item we tried to drop");
    }

    $self->aborted(1);

    return "";
}

__PACKAGE__->meta->make_immutable;

1;

