package TAEB::World::Item::Food::Corpse;
use TAEB::OO;
extends 'TAEB::World::Item::Food';

has '+nhi' => (
    isa     => 'NetHack::Item::Food::Corpse',
    handles => {
        monster => 'monster',
    },
);

has is_forced_verboten => (
    isa     => 'Bool',
    default => 1,
);

has estimated_date => (
    isa     => 'Int',
    default => sub { TAEB->turn },
);

has failed_to_sacrifice => (
    isa     => 'Bool',
    default => 0,
);

sub estimate_age {
    my $self = shift;
    my $when = shift || TAEB->turn;
    return $when - $self->estimated_date;
}

sub maybe_rotted {
    my $self = shift;
    my $when = shift || TAEB->turn;

    my $rotted_low = int($self->estimate_age($when) / 29);
    my $rotted_high = int($self->estimate_age($when) / 10);

    if (!defined($self->buc)) {
        $rotted_low -= 2; $rotted_high += 2;
    } elsif ($self->buc eq 'blessed') {
        $rotted_low -= 2; $rotted_high -= 2;
    } elsif ($self->buc eq 'uncursed') {
    } elsif ($self->buc eq 'cursed') {
        $rotted_low += 2; $rotted_high += 2;
    }

    $rotted_high = 10 if $self->is_forced_verboten;

    return 0 if $self->monster =~ /^(?:lizard|lichen|acid blob)$/;
    TAEB->log->item("in maybe_rotted; " . $rotted_low . "-" . $rotted_high .
        " for " . $self->raw . "(" . $self->estimate_age . ")" .
        $self->is_forced_verboten);

    return  1 if $rotted_low > 5;
    return -1 if $rotted_high <= 5;
    return 0;
}

sub should_sac {
    my ($self) = @_;

    return 0 if $self->monster ne 'acid blob' && $self->estimate_age > 50;

    return 0 if ($self->cannibal eq TAEB->race) && TAEB->align ne 'Cha';

    return 0 if $self->unicorn eq TAEB->align;

    return 0 if $self->failed_to_sacrifice;

    # Don't even try.  Why?  Because, for simplicity, we drop corpses before
    # sacrificing, and permacorpses are no good sitting on an altar.

    return 0 if $self->permanent;

    return 1;
}

sub unicorn {
    my $self = shift;

    return undef unless $self->monster =~ /(.*) unicorn/;

    return 'Law' if $1 eq 'white';
    return 'Neu' if $1 eq 'gray';
    return 'Cha' if $1 eq 'black';

    TAEB->log->item("Bizarrely colored unicorn corpse: " . $self->monster,
                    level => 'error');
    return undef;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

