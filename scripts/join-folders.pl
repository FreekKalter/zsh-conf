#!/home/fkalter/perl
use v5.14;
use utf8;

use Cwd;
use File::Copy;
use File::Spec;
use Path::Class;
use Getopt::Long;

my $test= '';
GetOptions(
   test  => \$test,
);

my $pattern = shift or die "No pattern!";
my $dir     = shift || getcwd;

$dir = dir( File::Spec->rel2abs( $dir ) ); #make dir a absolute path

opendir my $dh, "$dir" or die "Could not open $dir for reading: $!";
chdir "$dir";
my @wanted = map{ dir($dir, $_) } #make it absolute pahts
             grep{ -d $_    &&
                  !/^\.{1,2}/ &&
                  /$pattern/
               }
             readdir($dh);
closedir($dh);

my $target = dir($dir, "${pattern}_joined");
mkdir( $target ) if not $test;

for my $folder (@wanted){
    opendir my $fh , $folder or die "Could not open $folder: $!";
    my @files = map{ if(-d){dir($folder, $_)}else{file($folder, $_)} } #make it a full absolute path
                grep{ !/^\.{1,2}$/ } readdir($fh);
    close($fh);

    for my $file (@files){
       if( $test ){
          say "$file \t -->\t $target";
       }else{
          move($file, $target) or die "can not move $file: $!";
          rmdir($folder) or die "Can not delete $folder"  if not $test;
       }
    }
}
