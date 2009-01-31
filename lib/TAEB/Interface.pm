package TAEB::Interface;
use TAEB::OO;

=head1 NAME

TAEB::Interface - how TAEB talks to NetHack

=head2 read -> STRING

This will read from the interface. It's quite OK to block and throw errors
in this method.

It should just return the string read from the interface.

Your subclass B<must> override this method.

=cut

sub read    { die "You must override the 'read' method in TAEB::Interface."  }

=head2 write STRING

This will write to the interface. It's quite OK to block and throw errors
in this method.

Its return value is currently ignored.

Your subclass B<must> override this method.

=cut

sub write   { die "You must override the 'write' method in TAEB::Interface." }

__PACKAGE__->meta->make_immutable;
no Moose;

1;

