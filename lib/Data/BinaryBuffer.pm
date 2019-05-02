package Data::BinaryBuffer;
use strict;
use warnings;

# ABSTRACT: The module to work with binary data effectively

our $VERSION = '0.006';

require XSLoader;
XSLoader::load('Data::BinaryBuffer', $VERSION);

1;

__END__

=pod

=encoding utf-8

=head1 SYNOPSIS

    use Data::BinaryBuffer;

    my $buf = Data::BinaryBuffer->new;

    $buf->write($some_data); # PSD file for ex

    my $sig = $buf->read(4);
    die "This is not PSD file" if $sig ne '8BPS';

    my $version = $buf->read_uint16be;

    # etc...

=head1 DESCRIPTION

NOTE: This module is in very alpha state. API may change without any notice until version 0.1.

Perl is good for strings, bug not very nice to binary data. This class exactly for that.

Data::BinaryBuffer is a data structure similar to the queue, but optimized to work with blocks of arbitrary size.
You can write data to one end of buffer and read from another. Data can be written or read in various formats.

=head1 METHODS

=head2 new

  my $buf = Data::BinaryBuffer->new;

Creates empty buffer object.

=head2 size

  my $size = $buf->size;

Returns current amount of bytes stored in buffer.

=head2 write

  $buf->write($data);

Write scalar to the buffer.

=head2 write_uint8

=head2 write_uint16be

=head2 write_uint16le

=head2 write_uint32be

=head2 write_uint32le

=head2 write_int8

=head2 write_int16be

=head2 write_int16le

=head2 write_int32be

=head2 write_int32le

  $buf->write_uint8(255);
  $buf->write_int32be($value);

Write one integer to the buffer.

=head2 read

  my $data = $read($size);

Read $size bytes to Perl scalar.

=head2 read_uint8

=head2 read_uint16be

=head2 read_uint16le

=head2 read_uint32be

=head2 read_uint32le

=head2 read_int8

=head2 read_int16be

=head2 read_int16le

=head2 read_int32be

=head2 read_int32le

  my $num1 = $buf->read_uint32be;

Read integer from buffer.

=head2 read_buffer

  my $buf2 = $buf->read_buffer($size);

Same as C<read>, but return another buffer.
This method is very fast for big data.

=head1 SEE ALSO

=for :list
* pack/unpack functions in perldoc
* L<File::Binary>
* L<Parse::Binary>
* L<Convert::Binary::C>

=cut


