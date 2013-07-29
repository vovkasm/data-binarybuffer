#!perl
use Test::More;

use Data::BinaryBuffer;

{
    my $s = Data::BinaryBuffer->new;
    is $s->size, 0;

    $s->add("12345");
    is $s->size, 5;

    is $s->read(4), "1234";
    $s->add("67890");
    is $s->size, 6;

    is $s->read(6), "567890";
    is $s->size, 0;

    $s->add("1234");
    is $s->read(6), "1234";
}

{ # uint8
    my $s = Data::BinaryBuffer->new;
    $s->add("0");
    is $s->read_uint8, ord("0");

    $s->write_uint8(5);
    is $s->read_uint8, 5;

    $s->write_uint8(-1);
    is $s->read_uint8, 255;
}

{ # int8
    my $s = Data::BinaryBuffer->new;

    $s->write_int8(5);
    is $s->read_int8, 5;

    $s->write_int8(-1);
    is $s->read_int8, -1;
}

{ #uint16
    my $s = Data::BinaryBuffer->new;

    $s->write_uint16be(0x1234);
    is $s->size, 2, "write_uint16be write 2 bytes";
    is $s->read(2), pack("n", 0x1234), "write_uint16be work";

    $s->add(pack("n", 0x1234));
    is $s->read_uint16be, 0x1234, "read_uint16be work";
    is $s->size, 0, "read_uint16be read 2 bytes";

    $s->write_uint16le(0x1234);
    is $s->size, 2, "write_uint16le write 2 bytes";
    is $s->read(2), pack("v", 0x1234), "write_uint16le work";

    $s->add(pack("v", 0x1234));
    is $s->read_uint16le, 0x1234, "read_uint16le work";
    is $s->size, 0, "read_uint16le read 2 bytes";
}

{ #int16
    my $s = Data::BinaryBuffer->new;

    $s->write_int16be(-7);
    is $s->size, 2, "write_int16be write 2 bytes";
    is $s->read(2), pack("n",unpack("S",pack("s", -7))), "write_int16be work";

    $s->add(pack("n", 0x1234));
    is $s->read_int16be, 0x1234, "read_int16be work";
    is $s->size, 0, "read_int16be read 2 bytes";

    $s->write_int16le(0x1234);
    is $s->size, 2, "write_int16le write 2 bytes";
    is $s->read(2), pack("v", 0x1234), "write_int16le work";

    $s->add(pack("v", 0x1234));
    is $s->read_int16le, 0x1234, "read_int16le work";
    is $s->size, 0, "read_int16le read 2 bytes";
}

{ #uint32
    my $s = Data::BinaryBuffer->new;

    $s->write_uint32be(0x12345678);
    is $s->size, 4, "write_uint32be write 4 bytes";
    is $s->read(4), pack("N", 0x12345678), "write_uint32be work";

    $s->add(pack("N", 0x12345678));
    is $s->read_uint32be, 0x12345678, "read_uint32be work";
    is $s->size, 0, "read_uint32be read 4 bytes";

    $s->write_uint32le(0x12345678);
    is $s->size, 4, "write_uint32le write 4 bytes";
    is $s->read(4), pack("V", 0x12345678), "write_uint32le work";

    $s->add(pack("V", 0x12345678));
    is $s->read_uint32le, 0x12345678, "read_uint32le work";
    is $s->size, 0, "read_uint32le read 4 bytes";
}

{ # int32
    my $s = Data::BinaryBuffer->new;

    $s->write_int32be(0x12345678);
    is $s->size, 4, "write_int32be write 4 bytes";
    is $s->read(4), pack("N", 0x12345678), "write_int32be work";

    $s->add(pack("N", 0x12345678));
    is $s->read_int32be, 0x12345678, "read_int32be work";
    is $s->size, 0, "read_int32be read 4 bytes";

    $s->write_int32le(0x12345678);
    is $s->size, 4, "write_int32le write 4 bytes";
    is $s->read(4), pack("V", 0x12345678), "write_int32le work";

    $s->add(pack("V", 0x12345678));
    is $s->read_int32le, 0x12345678, "read_int32le work";
    is $s->size, 0, "read_int32le read 4 bytes";
}

{ # read_buffer
    my $s = Data::BinaryBuffer->new;

    $s->add("abcdefg012345");
    is $s->size, 13, "initial string 13 bytes long";
    my $s1 = $s->read_buffer(7);
    is $s->size, 6, "remains 6 bytes in original buffer";
    is $s1->size, 7, "new buffer size is 7";
    is $s1->read(7), "abcdefg", "new buffer contains right data";
    is $s->read(6), "012345", "original buffer contains right data";
}

done_testing;
