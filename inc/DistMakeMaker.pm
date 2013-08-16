package inc::DistMakeMaker;
use Moose;
use Config ();
use Text::ParseWords 'shellwords';

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_WriteMakefile_args => sub {
    my $self = shift;
    +{
        %{ super() },
        $self->_custom_mm_args
    };
};

sub _custom_mm_args {
    my @CCFLAGS = shellwords($Config::Config{ccflags});
    my @LDDLFLAGS = shellwords($Config::Config{lddlflags});

    push @CCFLAGS, qw/-x c++/;

    return (
        TYPEMAPS => ['perlobject.map'],
        LIBS     => ['-lstdc++'],
        CCFLAGS  => join(' ', @CCFLAGS),
        LDDLFLAGS => join(' ', @LDDLFLAGS),
    );
}

__PACKAGE__->meta->make_immutable;
