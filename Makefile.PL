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
        [ 'int',      "size" ],
        [ 'uint8_t',  "read_uint8" ],
        [ 'uint16_t', "read_uint16be" ],
        [ 'uint16_t', "read_uint16le" ],
        [ 'uint32_t', "read_uint32be" ],
        [ 'uint32_t', "read_uint32le" ],
        [ 'int8_t',   "read_int8" ],
        [ 'int16_t',  "read_int16be" ],
        [ 'int16_t',  "read_int16le" ],
        [ 'int32_t',  "read_int32be" ],
        [ 'int32_t',  "read_int32le" ],
        [ 'void', "write_uint8",    'uint8_t' ],
        [ 'void', "write_uint16be", 'uint16_t' ],
        [ 'void', "write_uint16le", 'uint16_t' ],
        [ 'void', "write_uint32be", 'uint32_t' ],
        [ 'void', "write_uint32le", 'uint32_t' ],
        [ 'void', "write_int8",     'int8_t' ],
        [ 'void', "write_int16be",  'int16_t' ],
        [ 'void', "write_int16le",  'int16_t' ],
        [ 'void', "write_int32be",  'int32_t' ],
        [ 'void', "write_int32le",  'int32_t' ]
    );

    open my $fh, '>', $xs_file or die "Can't open file $xs_file for write: $!";
    print $fh <<ENDXS;
#define PERL_NO_GET_CONTEXT

extern "C" {
#include "EXTERN.h"
#include "perl.h"
}

#include "XSUB.h"
#include "binbuffer.h"

MODULE = Data::BinaryBuffer       PACKAGE = Data::BinaryBuffer

BinaryBuffer*
BinaryBuffer::new();

void
BinaryBuffer::DESTROY();

BinaryBuffer*
read_buffer(BinaryBuffer* THIS, int len)
CODE:
    RETVAL = THIS->read_buffer(len);
    const char* CLASS = "Data::BinaryBuffer";
OUTPUT:
    RETVAL

SV*
read(BinaryBuffer* THIS, int len)
CODE:
    RETVAL = newSV(len);
    SvUPGRADE(RETVAL, SVt_PV);
    int actual_len = THIS->read(SvPVX(RETVAL), len);
    SvCUR_set(RETVAL, actual_len);
    SvPOK_only(RETVAL);
    *SvEND(RETVAL) = (char)0;
OUTPUT:
    RETVAL

void
add(BinaryBuffer* THIS, SV* sv)
CODE:
    STRLEN len;
    const char* src = SvPVbyte(sv, len);
    THIS->add(src, len);

ENDXS

    foreach my $def (@APIDEF) {
        my ( $ret_type, $meth, @args ) = @$def;
        unshift @args, 'BinaryBuffer* THIS' unless @args && $args[0] =~ /THIS/;
        my ( @arg_names, @xs_args );
        for ( my $i = 0 ; $i < @args ; $i++ ) {
            my ( $type, $name );
            if ( $args[$i] =~ /^(.+)\s(\S+)$/ ) {
                $type = $1;
                $name = $2;
            }
            else {
                $type = $args[$i];
                $name = 'arg' . ( $i + 1 );
            }
            push @arg_names, $name;
            push @xs_args,   $type . ' ' . $name;
        }
        my $xs_args_l = join( ',', @xs_args );
        my $c_args_l  = join( ',', @arg_names[ 1 .. $#arg_names ] );
        my ( $code_section, $output_section );
        if ( $ret_type eq 'void' ) {
            $code_section = <<ENDXS;
CODE:
    THIS->$meth($c_args_l);
ENDXS
            $output_section = "";
        }
        else {
            $code_section = <<ENDXS;
CODE:
    RETVAL = THIS->$meth($c_args_l);
ENDXS
            $output_section = <<ENDXS;
OUTPUT:
    RETVAL
ENDXS
        }
        my $xs = <<ENDXS;
$ret_type
$meth($xs_args_l)
$code_section$output_section

ENDXS
        print $fh $xs;
    }

    close $fh;
}
