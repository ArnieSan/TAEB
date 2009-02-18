package TAEB::World::Tile::Trap;
use TAEB::OO;
extends 'TAEB::World::Tile';
use TAEB::Util ':colors';

has trap_type => (
    is  => 'rw',
    isa => 'TAEB::Type::Trap',
);

augment debug_color => sub { Curses::A_BOLD | Curses::COLOR_PAIR(COLOR_BLUE) };

sub reblessed {
    my $self = shift;
    my $old_class = shift;
    my $trap_type = shift;

    if ($trap_type) {
        $self->trap_type($trap_type);
        return;
    }

    $trap_type = $TAEB::Util::trap_colors{$self->color};
    if (ref $trap_type) {
        if ($self->level->branch eq 'sokoban') {
            $self->trap_type(grep { /^(?:pit|hole)$/ } @$trap_type);
            return;
        }
        TAEB->enqueue_message(check => tile => $self);
    }
    else {
        $self->trap_type($trap_type);
    }
}

sub farlooked {
    my $self = shift;
    my $msg  = shift;

    if ($msg =~ /trap.*\((.*?)\)/) {
        $self->trap_type($1);
    }
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

