package TAEB::Action::Role::Item;
use Moose::Role;

has item => (
    traits   => [qw/TAEB::Provided/],
    is       => 'rw',
    isa      => 'NetHack::Item | Str',
);

sub exception_missing_item {
    my $self = shift;
    return unless blessed $self->item;

    TAEB->log->action("We don't have item " . $self->item . ", escaping.",
                      level => 'warning');
    TAEB->inventory->remove($self->item->slot);
    TAEB->enqueue_message(check => 'inventory');
    $self->aborted(1);
    return "\e\e\e";
}

no Moose::Role;

1;

