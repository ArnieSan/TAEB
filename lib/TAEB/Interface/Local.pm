package TAEB::Interface::Local;
use TAEB::OO;
use IO::Pty::Easy;
use Time::HiRes 'sleep';

use constant ping_wait => 0.2;

=head1 NAME

TAEB::Interface::Telnet - how TAEB talks to a local nethack

=cut

extends 'TAEB::Interface';

has name => (
    isa     => 'Str',
    default => 'nethack',
);

has pty => (
    isa     => 'IO::Pty::Easy',
    lazy    => 1,
    handles => ['is_active'],
    builder => '_build_pty',
);

sub _build_pty {
    my $self = shift;

    chomp(my $pwd = `pwd`);
    local $ENV{NETHACKOPTIONS} = '@' . join '/', $pwd, 'etc', 'TAEB.nethackrc';
    local $ENV{TERM} = 'xterm-color';

    # TAEB requires 80x24
    local $ENV{LINES} = 24;
    local $ENV{COLUMNS} = 80;

    # this has to be done in BUILD because it needs name
    my $pty = IO::Pty::Easy->new;
    $pty->spawn($self->name);
    return $pty;
}

=head2 read -> STRING

This will read from the pty. It will die if an error occurs.

It will return the input read from the pty.

=cut

sub read {
    my $self = shift;

    # this is about the best we can do for consistency
    # in Telnet we have a complicated ping/pong that scales with network latency
    sleep($self->ping_wait);

    die "Pty inactive." unless $self->is_active;
    my $out = $self->pty->read(1);
    return '' if !defined($out);
    die "Pty closed." if $out eq '';

    # sysread likes to give me blocks of 1024 characters. this is the best
    # fix I could come up with. I think it'll work even if NetHack sends
    # precisely 1024 bytes because it'll just time out after 1.2s or whatever.
    if (length($out) == 1024) {
        $out .= $self->read(@_);
    }

    return $out;
}

=head2 write STRING

This will write to the pty. It will die if an error occurs.

=cut

sub write {
    my $self = shift;
    my $text = shift;

    TAEB->log->interface("Called TAEB->write with no text.",
                         level => 'error')
        if length($text) == 0;

    die "Pty inactive." unless $self->is_active;
    my $chars = $self->pty->write($text, 1);
    return if !defined($chars);

    die "Pty closed." if $chars == 0;
    return $chars;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

