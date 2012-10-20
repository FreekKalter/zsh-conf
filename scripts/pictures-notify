#!/home/fkalter/perl
use v5.16;

use Linux::Inotify2;
use Path::Class;

my $not = new Linux::Inotify2 or die "unable to create new inotify object: $!";
my $path = dir("/home/fkalter/Pictures");
$not->watch( $path , IN_CREATE, \&handle );

sub handle {
    my $e = shift;
    sleep 1;
    my $file = file($path , $e->{name});
    my $res = `identify -format "\%w" $file`;
    chomp $res;
    if($res == 3840){
        `/home/fkalter/scripts/split-image.pl $file`;
    }
}

1 while $not->poll;
