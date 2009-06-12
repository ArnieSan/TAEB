package TAEB::Announcement::Item;
use TAEB::OO;
extends 'TAEB::Announcement';

has item => (
    is       => 'ro',
    isa      => 'NetHack::Item',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

