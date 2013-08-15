use Test::More;
my $test_pod_ok = eval "use Test::Pod; 1";
plan skip_all => 'Test::Pod not installed' unless $test_pod_ok;

all_pod_files_ok();

done_testing;
