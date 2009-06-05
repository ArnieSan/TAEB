package TAEB::Debug;
use TAEB::OO;
use TAEB::Debug::Console;
use TAEB::Debug::Map;
use TAEB::Debug::Sanity;
use TAEB::Debug::IRC;
use TAEB::Debug::Profiler;

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

has sanity => (
    is      => 'ro',
    isa     => 'TAEB::Debug::Sanity',
    default => sub { TAEB::Debug::Sanity->new },
);

has debug_map => (
    is      => 'ro',
    isa     => 'TAEB::Debug::Map',
    default => sub { TAEB::Debug::Map->new },
);

has profiler => (
    is      => 'ro',
    isa     => 'TAEB::Debug::Profiler',
    default => sub { TAEB::Debug::Profiler->new },
    handles => ['add_category_time'],
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;
