package TAEB::Role::Subscription;
use Moose::Role;

requires 'initialize';
before initialize => sub { TAEB->publisher->subscribe(shift) };

no Moose::Role;

1;

