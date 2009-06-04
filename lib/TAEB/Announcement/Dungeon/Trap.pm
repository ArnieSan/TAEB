package TAEB::Announcement::Dungeon::Trap;
use TAEB::OO;
extends 'TAEB::Announcement::Dungeon';

with 'TAEB::Announcement::Dungeon::Feature' => {
    tile_type   => 'trap',
    target_type => 'local',
};

has type => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

