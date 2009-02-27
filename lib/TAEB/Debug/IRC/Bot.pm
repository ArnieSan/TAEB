package TAEB::Debug::IRC::Bot;
use TAEB::OO;
use Time::HiRes qw/time/;
BEGIN {
    # POE::Kernel and POE::Component::IRC use eval/die a bunch without
    # localizing it
    local $SIG{__DIE__};
    require POE::Kernel;
    POE::Kernel->import;
    extends 'Bot::BasicBot';
}

with 'TAEB::Debug::Bot';

sub initialize {
    # does nothing (the irc component isn't initialized yet), but shuts up
    # warnings about run never being called
    $poe_kernel->run;
}

sub speak {
    my $self = shift;
    my $msg  = shift;

    $self->say(
        channel => $self->channels,
        body    => $msg,
    );
}

sub tick {
    my $self = shift;

    TAEB->log->irc("Iterating the IRC component");

    do {
        TAEB->log->irc("IRC: running a timeslice at ".time);
        local $SIG{__DIE__};
        $self->schedule_tick(0.05);
        $poe_kernel->run_one_timeslice;
    } while ($poe_kernel->get_next_event_time - time < 0);
}

sub said {
    my $self = shift;
    my %args = %{ $_[0] };
    return unless $args{address};

    TAEB->log->irc("Somebody is talking to us! ($args{who}, $args{body})");
    return $self->response_to($args{body});
}

sub log {
    my $self = shift;
    for (@_) {
        chomp;
        TAEB->log->irc($_);
    }
}

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
no TAEB::OO;

1;
