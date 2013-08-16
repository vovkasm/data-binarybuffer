use ExtUtils::MakeMaker;
use Config;
use Getopt::Long qw(:config pass_through);
use Text::ParseWords;

my $coverage;

GetOptions(
    'coverage!' => \$coverage,
);

my @CCFLAGS = shellwords($Config{ccflags});
my @LDDLFLAGS = shellwords($Config{lddlflags});

push @CCFLAGS, qw/-x c++/;

if ($coverage) {
    push @CCFLAGS, qw/--coverage/;
    push @LDDLFLAGS, qw/--coverage/;
}

WriteMakefile(
    NAME         => "Data::BinaryBuffer",
    VERSION_FROM => "BinaryBuffer.pm",
    TYPEMAPS     => ['perlobject.map'],
    LIBS         => ['-lstdc++'],
    CCFLAGS      => join(' ',@CCFLAGS),
    LDDLFLAGS    => join(' ',@LDDLFLAGS),
);

