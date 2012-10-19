#!/home/fkalter/perl
use v5.12;
use strict;
use warnings;

use Cwd;
use Path::Class;
use File::stat;
use File::Find;
use File::Path    qw(remove_tree);
#use File::Remove  qw(trash);
use Time::HiRes   qw(gettimeofday tv_interval);
use Getopt::Long;

my $print='';

#accept command line argumenst, if none present use stdin
chomp(@ARGV = <STDIN>) unless @ARGV;
my $dir;
my ($count , $size) = (0,0);
my @to_delete;
while($dir = shift){
    next unless (-e $dir);
    my $t0 = [gettimeofday];
    ($count, $size) = (0,0);
    @to_delete = 0;
    say ""; # print empty line, for cleaner sabnzb overview
    say "dir: $dir";

    finddepth( \&wanted , $dir);

    for my $file(@to_delete){
      if( ref($file) eq "Path::Class::File" ){
         unlink $file or print "Could not unlink '$file': $!\n";
      }elsif( ref($file) eq "Path::Class::Dir" ){
         remove_tree( "$file"  ) or print "Could not rmtree '$file': $!\n";
      }
    }

    #Just remove them. If they're not empty, rmdir will fail. In this case, you don't care that it fails, ignore the error, and keep going.
    finddepth(sub {rmdir $_ if -d} , $dir);

    printf("$count items deleted: %.2f MB %.2f seconds\n", , $size, tv_interval($t0));
    print( "Done ($count)\n" );
}


sub wanted{
   #$File::Find::dir is the current directory name,
   #$_ is the current filename within that directory
   #$File::Find::name is the complete pathname to the file.
   my $filename = $_;
   my $full_filename = '';

   if(-f $File::Find::name){
      $full_filename = file($File::Find::name);
      if($File::Find::name =~ m/(?:jpg|png|gif|pdf|jpeg|html|nfo|doc)$/i){

         opendir(my $dh, $File::Find::dir) || die "Can't opendir $File::Find::dir: $!";
         my @files = grep {!/^\.\.?$/} readdir($dh);
         #get max file size in this directory
         my $max =0;
         for my $file (@files){
             my $size = stat($file)->size;
             $max = $size if $size>$max;
         }

         if( scalar(@files) > 1 && $max > 50*(1024*1024) ){
            my $s =  stat($File::Find::name)->size / (1024*1024);
            $size += $s; 
            $count++;

            printf ("%-170.170s\t%.2f\tMB\n", $full_filename, $s);
            push @to_delete , $full_filename;
         }

      }elsif($full_filename =~ /(.+)\.(\w{3})$/i){
         my $file_name  = "\Q$1"; #this contains whole paht, so to avoid later problems with pattern matching metaqoute this data with \Q
         my $extension  = "\Q$2";
         my $file_name_old  = "$1"; #this contains whole paht, so to avoid later problems with pattern matching metaqoute this data with \Q
         my $extension_old  = "$2";

         opendir(my $dh, $File::Find::dir) || die "Can't opendir $File::Find::dir: $!";
         my @files = map  { file($File::Find::dir , $_) } 
                     grep { !/^\.\.?$/} 
                     readdir($dh);

         my ($sample) = grep{ /$file_name \. 1 \. $extension/x || /$file_name . sample . $extension/x } @files;
         #check for files in this dir with a 1 at the end of the file name (maria.wmv maria.1.wmv)
         if($sample){
            my $s =  stat("$sample")->size / (1024*1024);
            $size += $s; 
            $count++;

            printf ("%-170.170s\t%.2f\tMB\tSAMPLE\n", $sample, $s);
            push @to_delete , $sample;
         }
          
      }
   
   }elsif(-d $File::Find::name) {# recurse if its a dir 
      $full_filename = dir($File::Find::name);
      #say "dir $File::Find::name";
      if( $filename =~ m/^_FAILED_.*/){
         $count++;
         say $full_filename;
         push @to_delete, $full_filename;
      }
   }
   
}
