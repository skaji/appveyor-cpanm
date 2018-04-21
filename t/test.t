use strict;
use warnings;
use Test::More;
use lib "t";
use Run;

diag "";
diag "cpanm_V: $_" for split /\n/, cpanm_V;

my ($stdout, $stderr, $exit) = run "App::FatPacker";
is $exit, 0;

diag "stdout: $_" for split /\n/, $stdout;
diag "stderr: $_" for split /\n/, $stderr;
diag "build_log: $_" for split /\n/, last_build_log;

done_testing;
