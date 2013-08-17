package inc::DistMakeMaker;
use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_MakeFile_PL_template => sub {
    my $self = shift;
    my $full_tmpl = super();
    my $configure_tmpl = $self->_configure_tmpl();

    $full_tmpl =~ s/(^WriteMakefile\(.+?\);\s*$)/$configure_tmpl\n$1/ms;
    return $full_tmpl;
};

sub _configure_tmpl {
    my $self = shift;
    my $tmpl = <<'TEMPLATE';
use Config ();
use Text::ParseWords 'shellwords';

$WriteMakefileArgs{CONFIGURE} = sub {
    my %args;

    my @CCFLAGS = shellwords($Config::Config{ccflags});
    push @CCFLAGS, qw/-x c++/;
    $args{CCFLAGS} = join(' ', @CCFLAGS);

    $args{TYPEMAPS} = ['perlobject.map'];
    $args{LIBS} = ['-lstdc++'];

    return \%args;
};
TEMPLATE
    return $tmpl;
}

__PACKAGE__->meta->make_immutable;
