use strict;
use warnings;
use Test::More;
use lib "t";
use Run;

diag "";
diag "cpanm_V: $_" for split /\n/, cpanm_V;

my ($stdout, $stderr, $exit) = run 'CPAN::Test::Dummy::Perl5::Make::Zip', "Plack", ;

diag "stdout: $_" for split /\n/, $stdout;
diag "stderr: $_" for split /\n/, $stderr;
diag "build_log: $_" for split /\n/, last_build_log;

is $exit, 0;

done_testing;
