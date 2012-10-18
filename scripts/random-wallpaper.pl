#!/home/fkalter/perl

use v5.14;
use Path::Class;
use Math::Random::Secure qw( irand );

my $path = dir("/home/fkalter/Pictures/wallpapers");
opendir( my $dh, $path );
my @lefts = grep { /-0\.[a-z]{3}$/ } readdir($dh); 

my $current = `xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path`;
chomp $current;
say $current;
my $left = file( $path , $lefts[ irand(scalar @lefts) ] );
while($left eq $current){
    $left = file( $path , $lefts[ irand(scalar @lefts) ] );
}
say $left;
my $right = $left =~ s/^(.+)-(0)(\.[a-z]{3})$/$1-1$3/r; 

`xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s $left`;
`xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor1/image-path -s $right`;

