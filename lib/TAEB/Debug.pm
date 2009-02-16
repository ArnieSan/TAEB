package TAEB::Debug;
use TAEB::OO;
use TAEB::Debug::Console;
use TAEB::Debug::Map;
use TAEB::Debug::IRC;

has irc => (
    is      => 'ro',
    isa     => 'TAEB::Debug::IRC',
    default => sub { TAEB::Debug::IRC->new },
);

has console => (
    is      => 'ro',
    isa     => 'TAEB::Debug::Console',
    default => sub { TAEB::Debug::Console->new },
);

has debug_map => (
    isa     => 'TAEB::Debug::DebugMap',
    default => sub { TAEB::Debug::DebugMap->new },
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;
