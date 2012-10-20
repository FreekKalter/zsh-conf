#!/home/fkalter/perl

use v5.14;
use Path::Class;
use Math::Random::Secure qw( irand );

# prepare enviroment for calling xfconf-query from crontab
# this requires acces to the dbus (which isn't available in the crontab session)
# The bit below extracts the info from ~/.dbus/session-bus and makes it enviroment variables for its child processes
my $machine_id = `cat /var/lib/dbus/machine-id`;
chomp $machine_id;
my $dbus_session_file = "/home/fkalter/.dbus/session-bus/${machine_id}-0";
if( -e $dbus_session_file ) {
    open(my $fh , "<" , $dbus_session_file) or die "Could not open $dbus_session_file: $!";
    while(<$fh>){
        my ($var, $val) = /([A-Z_]+)=(.*)/;
        $ENV{$var} = $val if($var); 
    }
    close($fh);
}

# The path where the wallpapers can be found they schould be in the format
# background-0.jpg background-1.jpg
# 0 being the left monitor, and 1 being the right

my $path = dir("/home/fkalter/Pictures/wallpapers");
opendir( my $dh, $path );
my @lefts = grep { /-0\.[a-z]{3}$/ } readdir($dh); 

my $current = `xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path`;
chomp $current;

# make sure it always changes ( the one picked at random should not be same as the current one )
my $left = file( $path , $lefts[ irand(scalar @lefts) ] );
while($left eq $current){
    $left = file( $path , $lefts[ irand(scalar @lefts) ] );
}
my $right = $left =~ s/^(.+)-(0)(\.[a-z]{3})$/$1-1$3/r; 

# call xfconf-query 
`xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s $left`;
`xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor1/image-path -s $right`;

