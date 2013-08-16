package Data::BinaryBuffer;
use strict;
use warnings;

our $VERSION = '0.01_1';

require XSLoader;
XSLoader::load('Data::BinaryBuffer', $VERSION);

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Data::BinaryBuffer - the module to work with binary data effectively

=head1 SYNOPSIS

    use Data::BinaryBuffer;

    my $buf = Data::BinaryBuffer->new;

    $buf->write($some_data); # PSD file for ex

    my $sig = $buf->read(4);
    die "This is not PSD file" if $sig ne '8BPS';

    my $version = $buf->read_uint16be;

    # etc...

=head1 DESCRIPTION

NOTE: This module is in very alpha state. Api may change without any notice until version 0.5.

Perl is good for strings, bug not very nice to binary data. This class exactly for that.

Data::BinaryBuffer is a data structure similar to the queue, but optimized to work with blocks of arbitrary size.
You can write data to one end of buffer and read from another. Data can be written or readed in various formats.

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

=head2 write_*

  $buf->write_uint8(255);
  $buf->write_int32be($value);

Write one integer to the buffer.

Real name of the method looks like write_<sign>int<size><endian>, where

=over

=item <sign>

Optional simbol 'u' for unsigned conversion.

=item <size>

Amount of bits to write. Can be 8,16 and 32 for now.

=item <endian>

Can be 'be' or 'le'.

=back

=head2 read

  my $data = $read($size);

Read $size bytes to Perl scalar.

=head2 read_*

  my $num1 = $buf->read_uint32be;

Read integer from buffer.
For methods naming see C<write_*>.

=head2 read_buffer

  my $buf2 = $buf->read_buffer($size);

Same as C<read>, but return another buffer.
This method is very fast for big data.

=head1 SEE ALSO

=over 4

=item *

pack/unpack functions in perldoc

=item *

L<File::Binary>

=item *

L<Parse::Binary>

=item *

L<Convert::Binary::C>

=back

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the isuue tracker
at L<https://github.com/vovkasm/p5-Data-BinaryBuffer/issues>.

=head2 Source Code

L<https://github/vovkasm/p5-Data-BinaryBuffer>

  git clone https://github.com/vovkasm/p5-Data-BinaryBuffer.git

=head1 AUTHOR

Vladimir Timofeev <vovkasm@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Vladimir Timofeev

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
 
=cut


