#!/usr/bin/perl 
use v5.14;
use File::Basename;

my $img = shift;
my ( $base, $form ) = basename($img) =~ /(.+)\.(.+)/;
say `convert "$img" -crop %50x0% +repage "/home/fkalter/Pictures/wallpapers/$base-\%d.$form"`; 
