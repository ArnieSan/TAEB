package TAEB::World::Item::Role::Lightable;
use Moose::Role;

has is_lit => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

no Moose::Role;

1;

