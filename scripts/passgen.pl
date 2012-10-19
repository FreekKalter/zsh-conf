#!/home/fkalter/perl 

use v5.14;
use Math::Random::Secure qw( irand );
use Getopt::Long;

my $length       = 10;
my $quantity     = 10;
my $uc           = '1';
my $alpha        = '1';
my $num          = '1';
my $help         = 0;
my $specialchars = "";
my $result       = GetOptions(
    "length=i"       => \$length,
    "quantity=i"     => \$quantity,
    "uppercase!"     => \$uc,
    "alpha!"         => \$alpha,
    "help"           => \$help,
    "numeric!"       => \$num,
    "specialchars=s" => \$specialchars
);
my @alpha   = "a" .. "z";
my @numeric = ( 0 .. 9 );

my @chars = ();

if ($help) {
    print( "
useage:  $0       
      --length       Number of chars in password
      -s
      --numeric      Include numbers in pass (On by default) 
      -n
      --quantity     Number of passwords to generate (default is 10)     
      -q
      --alpha        Include letters (a .. z) (On by default)
      -a
      --uppercase    Include uppercase characters in password (On by defualt)
      -u
      --specialchars Special characters to include, use double quotes like this --specialchars=\"!@#$%\"
      -s

      Use --no-option , to not use it, for example to not include numbers witch are on by default use --no-numeric.
      --help         Print this message
      -h" );

}
else {
    push( @chars, split( //, $specialchars ) );
    if ($alpha) {
        push @chars, @alpha;
        if ($uc) {
            push( @chars, map { uc } @alpha );
        }
    }

    if ($num) {
        push( @chars, @numeric );
    }

    for ( my $j = 0 ; $j < $quantity ; $j++ ) {
        for ( my $i = 0 ; $i < $length ; $i++ ) {
            print $chars[ irand( scalar(@chars) ) ];
        }
        print "\n";
    }
}
