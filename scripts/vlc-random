#!/home/fkalter/perl
use v5.14;
use Math::Random::Secure qw( irand );

my $sock = "/home/fkalter/vlc-random.sock";
my $log = "/home/fkalter/log.txt";
open(my $lh, ">>", $log) or die "Could not open $log for writing: $!";

if( -e $sock ) {
    if( system( "echo 'logout' | nc -U $sock" )){
        unlink $sock;                         
        &fork_vlc();
    }   
}else{
    &fork_vlc();
}

opendir( my $dh, "/data/down" );
my @files = grep{ ! /^\.{1,2}/ } readdir($dh); 
 
my $rand =irand(scalar @files);  
print $lh "$#files, $rand\n";

my $to_add = "/data/down/" . $files[$rand];

my $status = `echo "add $to_add" | nc -U $sock`;
if( $status =~ /menu select/ ){
    $status = `echo "pause" | nc -U $sock`;
    $status = `echo "add $to_add" | nc -U $sock`;
}
close($lh);

sub fork_vlc {
    die "could not fork\n" unless defined( my $pid = fork);
    if( ! $pid){
        exec "vlc --extraintf oldrc --rc-unix $sock > /dev/null 2>&1";
    }
    sleep 2;
}
