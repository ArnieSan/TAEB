#!/usr/bin/env perl
package TAEB::AI::Senses;
use Moose;

has role => (
    is  => 'rw',
    isa => 'Role',
);

has race => (
    is  => 'rw',
    isa => 'Race',
);

has align => (
    is  => 'rw',
    isa => 'Align',
);

has gender => (
    is  => 'rw',
    isa => 'Gender',
);

has hp => (
    is  => 'rw',
    isa => 'Int',
);

has maxhp => (
    is  => 'rw',
    isa => 'Int',
);

has power => (
    is  => 'rw',
    isa => 'Int',
);

has maxpower => (
    is  => 'rw',
    isa => 'Int',
);

has nutrition => (
    is      => 'rw',
    isa     => 'Int',
    default => 700,
);

has in_wereform => (
    is  => 'rw',
    isa => 'Bool',
);

has can_kick => (
    is      => 'rw',
    isa     => 'Bool',
    default => 1,
);

has is_blind => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

has is_stunned => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

has is_confused => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

has is_hallucinating => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

has level => (
    is      => 'rw',
    isa     => 'Int',
    default => 1,
);

has turn => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);

has max_god_anger => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);

sub update {
    my $self   = shift;
    my $status = TAEB->vt->row_plaintext(22);
    my $botl   = TAEB->vt->row_plaintext(23);
    local $_ = TAEB->topline;

    if ($botl =~ /HP:(\d+)\((\d+)\)/) {
        $self->hp($1);
        $self->maxhp($2);
    }
    else {
        TAEB->error("Unable to parse HP from '$botl'");
    }

    if ($botl =~ /Pw:(\d+)\((\d+)\)/) {
        $self->power($1);
        $self->maxpower($2);
    }
    else {
        TAEB->error("Unable to parse power from '$botl'");
    }

    if ($botl =~ m{Xp:(\d+)/(\d+)}) {
        $self->level($1);
    }

    if ($botl =~ m{T:(\d+)}) {
        $self->turn($1);
    }
    else {
        TAEB->error("Unable to parse turncount from '$botl'");
    }

    $self->in_wereform($status =~ /^TAEB the Were/ ? 1 : 0);

    if (/You can't move your leg/ || /You are caught in a bear trap/) {
        $self->can_kick(0);
    }
    # XXX: there's no message when you leave a bear trap. I'm not sure of the
    # best solution right now. a way to say "run this code when I move" maybe

    # we lose 1 nutrition per turn. good enough for now
    $self->nutrition($self->nutrition - 1);

    # we can definitely know some things about our nutrition
    if ($botl =~ /\bSat/) {
        $self->nutrition(1000) if $self->nutrition < 1000;
    }
    elsif ($botl =~ /\bHun/) {
        $self->nutrition(149)  if $self->nutrition > 149;
    }
    elsif ($botl =~ /\bWea/) {
        $self->nutrition(49)   if $self->nutrition > 49;
    }
    elsif ($botl =~ /\bFai/) {
        $self->nutrition(-1)   if $self->nutrition > -1;
    }
    else {
        $self->nutrition(999) if $self->nutrition > 999;
        $self->nutrition(150) if $self->nutrition < 150;
    }

    $self->is_blind($botl =~ /\bBli/);
    $self->is_stunned($botl =~ /\bStun/);
    $self->is_confused($botl =~ /\bConf/);
    $self->is_hallucinating($botl =~ /\bHal/);
}

sub msg_god_angry {
    my $self      = shift;
    my $max_anger = shift;

    $self->max_god_anger($max_anger);
}

sub can_pray {
    my $self = shift;
    return $self->max_god_anger == 0;
}

make_immutable;

1;

