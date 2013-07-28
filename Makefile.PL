use ExtUtils::MakeMaker;
use Config;

my $CCFLAGS = join( ' ', $Config{ccflags}, '-x c++' );

WriteMakefile(
    NAME         => "Data::BinaryBuffer",
    VERSION_FROM => "BinaryBuffer.pm",
    TYPEMAPS     => ['perlobject.map'],
    LIBS         => ['-lstdc++'],
    CCFLAGS      => $CCFLAGS,
    clean        => {
        FILES => 'BinaryBuffer.xs'
    },
);
