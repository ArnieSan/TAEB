#!/usr/bin/env perl
package TAEB::Knowledge::Item;
use Moose;

has _identities => (
    metaclass => 'Collection::Hash',
    is        => 'rw',
    isa       => 'HashRef',
    provides  => {
        delete => 'exclude_possibility',
        exists => 'has_possibility',
        keys   => 'possibilities',
    },
);

sub BUILD {
    my $self = shift;

    $self->_identities({ map { $_ => 1 } $self->all_identities });
}

# if we narrow it down to one final possibility, exclude it from all others
after exclude_possibility => sub {
    my $self = shift;

    if ($self->possibilities == 1) {
        my ($type) = map { lc } blessed($self) =~ /::(\w+)$/;
        for my $appearance (values %{ TAEB::Knowledge->appearances->{$type} }) {
            next if $appearance == $self;
            $appearance->rule_out($self->possibilities);
        }
    }
};

sub rule_out {
    my $self = shift;
    $self->exclude_possibility($_) for @_;
}

sub rule_out_all_but {
    my $self = shift;
    my %include = map { $_ => 1 } @_;

    for ($self->possibilities) {
        $self->rule_out($_) unless $include{$_};
    }
}

sub identify_as {
    my $self = shift;
    $self->rule_out_all_but(shift);
}

# XXX: price-id code

1;

