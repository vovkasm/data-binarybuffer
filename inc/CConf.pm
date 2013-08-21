package inc::CConf;
use strict;
use warnings;
use ExtUtils::CBuilder;
use File::Temp ();

sub new {
    my $class = shift;

    my $cbuilder = ExtUtils::CBuilder->new();

    my $self = bless {
        cbuilder => $cbuilder,

        ccflags => [],
        ldflags => [],
        libs => [],
    }, $class;

    return $self;
}

sub makemaker_args {
    my $self = shift;
    my %args;
    if (@{$self->{ccflags}}) {
        $args{CCFLAGS} = join(' ',@{$self->{ccflags}});
    }
    if (@{$self->{libs}}) {
        $args{LIBS} = [join(' ',map { "-l$_" } @{$self->{libs}})];
    }
    if (@{$self->{ldflags}}) {
        $args{dynamic_lib}{OTHERLDFLAGS} = join(' ',@{$self->{ldflags}});
    }
    return (%args);
}

sub merge_args {
    my $self = shift;
    my %args = @_;
    $self->{ccflags} = [@{$self->{ccflags}}, @{$args{ccflags}}] if @{$args{ccflags}||[]};
    $self->{ldflags} = [@{$self->{ldflags}}, @{$args{ldflags}}] if @{$args{ldflags}||[]};
    $self->{libs} = [@{$self->{libs}}, @{$args{libs}}] if @{$args{libs}||[]};
    return;
}

sub cbuilder_compile_args {
    my $self = shift;
    my %args = @_;
    return (
        source => $args{source},
        extra_compiler_flags => [@{$self->{ccflags}},@{$args{ccflags}||[]}],
    );
}

sub cbuilder_linker_args {
    my $self = shift;
    my %args = @_;
    return (
        objects => $args{objects},
        extra_linker_flags => [@{$self->{ldflags}},@{$args{ldflags}||[]},map { "-l$_" } (@{$self->{libs}},@{$args{libs}||[]})],
    );
}

sub need_cplusplus {
    my $self = shift;

    my $code = <<'ENDCODE';
class SomeClass {
public:
    int test() { return 0; }
};

int main() {
    SomeClass c;
    return c.test();
}
ENDCODE

    my $fh = File::Temp->new(SUFFIX => '.c'); # same as file created from .xs
    $fh->print($code);

    my $obj;
    foreach my $try_args ({ccflags=>['-xc++']},{ccflags=>['-Tp']}) {
        my %args = $self->cbuilder_compile_args(source => $fh->filename, %$try_args);
        $obj = eval { $self->{cbuilder}->compile(%args) };
        if ($obj) {
            $self->merge_args(%$try_args);
            last;
        }
    }
    unless ($obj) {
        die("Can't compile C++ programs on this platform");
    }

    my $exe;
    my %args = $self->cbuilder_linker_args(objects => $obj);
    $exe = eval { $self->{cbuilder}->link_executable(%args); };
    unless ($exe) {
        die("Can't link C++ program on this platform");
    }

    unless ( system($exe) == 0 ) {
        die("Can't link C++ program on this platform (can't run)");
    }
}

sub need_stl {
    my $self = shift;

    my $code = <<'ENDCODE';
#include <vector>

int main() {
    std::vector<int> c(10);
    c[0] = 1;
    return c[0] - 1;
}
ENDCODE

    my $fh = File::Temp->new(SUFFIX => '.c'); # same as file created from .xs
    $fh->print($code);

    my $obj;
    my %args = $self->cbuilder_compile_args(source => $fh->filename);
    $obj = eval { $self->{cbuilder}->compile(%args) };
    unless ($obj) {
        die("Can't compile C++ program with STL on this platform");
    }

    my $exe;
    foreach my $try_args ({libs=>['stdc++']},{libs=>['c++']}) {
        my %args = $self->cbuilder_linker_args(objects => $obj, %$try_args);
        $exe = eval { $self->{cbuilder}->link_executable(%args) };
        if ($exe) {
            $self->merge_args(%$try_args);
            last;
        }
    }
    unless ($exe) {
        die("Can't link C++ program with STL on this platform");
    }

    unless ( system($exe) == 0 ) {
        die("Can't link C++ program with STL on this platform (can't run)");
    }
}

1;
