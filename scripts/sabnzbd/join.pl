#!/home/fkalter/perl 
use v5.14;
use warnings;
use strict;

#accept command line argumenst, if none present use stdin
chomp(@ARGV = <STDIN>) unless @ARGV;
my $dir;
while($dir = shift){
    next unless (-e $dir);
    &join($dir);
    &repair($dir);
}

sub join{
    my $dir = shift;
    say $dir;
    opendir(my $dh, $dir) or die "Can't open dir $dir: $!";
    chdir($dir);
    my @avis = sort( grep { /avi\.\d{0,4}$/ } readdir($dh) ) ;
    close($dh);
    my $outputfile = $avis[0] =~ s/\.\d{0,4}$//r ; 
    say "outpufile:\t\t$outputfile";
    open(my $output, ">", $outputfile);

    for my $input(@avis){
        open(my $avi, "<", $input);
        while(<$avi>){
            print $output $_;
        }
        close($avi);
    }
    close $output;
}

#repair files
sub repair{
    my $dir = shift;
    opendir(my $dh, $dir) or die "Can't open dir $dir: $!";
    chdir($dir);
    my ($par2file) = grep { /par2$/ && !/vol\d{2,3}\+\d{2,3}/ } readdir($dh);
    close($dh);
    if( `par2repair "$par2file" | tail -1` =~ /(^All files are correct, repair is not required) || (^Repair complete)/){
        say "par2:\t\t\tFiles are good.";
        &cleanup($dir);
    }else{
        say "Repair unsuccesfull";
    }
    
}

sub cleanup{
    my $dir = shift;
    #remove par2 and avi-part files
    opendir(my $dh, $dir) or die "Can't open dir $dir: $!";
    chdir($dir);
    my @files = sort( grep { /avi\.\d{0,4}$/ || /par2$/} readdir($dh) ) ;
    for my $file (@files){
        unlink $file or die "Could not unlink $file: $!";        
    }
    say "avi/par cleanup:\tDone";
    print "cleanup:\t\t" , `/home/fkalter/sabnzb-scripts/cleanup.pl $dir`;
}

