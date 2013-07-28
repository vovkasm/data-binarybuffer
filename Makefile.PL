use ExtUtils::MakeMaker;
use Config;

my $CCFLAGS = join( ' ', $Config{ccflags}, '-x c++' );

gen_xs();

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

sub gen_xs {
    my $xs_file = 'BinaryBuffer.xs';

    my @APIDEF = (
        [ 'BinaryBuffer*', 'new' ],
        [ 'void',          'DESTROY' ],
        [ 'int',           'size' ],
        [ 'SV*',  'read', 'int len' ],
        [ 'void', 'add',  'SV* sv' ]
    );

    foreach my $meth (qw/uint8 int8 uint16be uint16le int16be int16le uint32be uint32le int32be int32le/) {
        push @APIDEF, [ 'SV*', "read_$meth" ];
        push @APIDEF, [ 'void', "write_$meth", 'SV* sv' ];
    }

    open my $fh, '>', $xs_file or die "Can't open file $xs_file for write: $!";
    print $fh <<ENDXS;
extern "C" {
#include "EXTERN.h"
#include "perl.h"
}

#include "XSUB.h"
#include "binbuffer.h"

MODULE = Data::BinaryBuffer       PACKAGE = Data::BinaryBuffer

BinaryBuffer*
BinaryBuffer::read_buffer(int len)
CODE:
    RETVAL = THIS->read_buffer(len);
    const char* CLASS = "Data::BinaryBuffer";
OUTPUT:
    RETVAL

ENDXS

    foreach my $def (@APIDEF) {
        my ( $ret_type, $meth, @args ) = @$def;
        my $args_line = join( ',', @args );
        print $fh <<ENDXS
$ret_type
BinaryBuffer::$meth($args_line);

ENDXS
    }

    close $fh;
}
