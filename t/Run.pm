package Run;
use strict;
use base qw(Exporter);
our @EXPORT = qw(cpanm_V run run_L last_build_log);

use Capture::Tiny qw(capture);
use File::Temp qw(tempdir);
use File::Which qw(which);
use Win32::ShellQuote qw(quote_native);

my $executable = which "cpanm";

delete $ENV{PERL_CPANM_OPT};
$ENV{PERL_CPANM_HOME} = tempdir(CLEANUP => 1);

sub cpanm_V {
    my $cmd = quote_native $executable, "-V";
    `$cmd`;
}

sub run_L {
    run("-L", "$ENV{PERL_CPANM_HOME}/perl5", @_);
}

sub run {
    my @args = @_;

    # use metacpan's mirror in the tests
    my @mirrors;
    unless (grep /--mirror($|=)/, @args) {
        @mirrors = ('--mirror', 'http://cpan.metacpan.org/');
    }

    my @notest = $ENV{TEST} ? ("--no-notest") : ("--notest");
    my $cmd = quote_native($^X, $executable, @notest, "--quiet", "--reinstall", @mirrors, @args);
    ::diag("Running $cmd");
    my($stdout, $stderr, $exit) = capture {
        system $cmd;
    };
    ::diag($stderr) if $stderr and !$ENV{NODIAG};  # Some tests actually want stderr
    return wantarray ? ($stdout, $stderr, $exit) : $stdout;
}

sub last_build_log {
    open my $log, "<", "$ENV{PERL_CPANM_HOME}/latest-build/build.log";
    join '', <$log>;
}

1;
