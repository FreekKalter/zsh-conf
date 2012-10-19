#!/home/fkalter/perl
#===============================================================================
#         FILE: ls.pl
#
#        USAGE: ./ls.pl  
#
#  DESCRIPTION: Color output of folders with dirty git work dir.
#
#       AUTHOR: Freek Kalter, 
#      COMPANY: Kalter&Co 
#      VERSION: 1.0
#      CREATED: 09/19/2012 05:12:45 PM
#===============================================================================
use v5.16;
use Path::Class;
use Cwd ;
use File::Basename;
use Term::ANSIColor;
use Parallel::ForkManager;

sub print_s($){
    my $var = shift;
    print $var . '  ';
}
my $pm = new Parallel::ForkManager(30);

my $dir = cwd();

opendir( my $dh, $dir ) or die "Can't open $dir $!";

my @files = map{ file($dir, $_) }
            grep{ !/^.{1,2}$/ } 
            readdir($dh);
my @output =();

for my $file (@files){
    $pm->start and next;
    my $filename = basename($file);
    if( -d $file){
        if( -e dir($file, ".git") ){
            my $git_command = "git --git-dir=$filename/.git --work-tree=$filename ";
            # under version control

            my $git_status = `$git_command status`;

            if( $git_status =~ /nothing to commit/ ){
                if( `$git_command fetch 2>&1` =~ /ERROR/ ){
                    print_s $filename;
                    next;
                }

                $git_status = `$git_command  status`;
                if( $git_status =~ /branch is ahead of/ ){
                    print_s colored($filename, 'green bold on_yellow');
                    next;
                }elsif( $git_status =~ /branch is behind/ ){
                    print_s colored($filename, 'red on_yellow');
                    next;
                }
            }else{ # uncommitted changes (dirty working dir)
                print_s colored($filename ,'red bold');
                next;
            }
        }else{
            # not under version control
            print_s colored($filename, 'blue bold');
            next;
        }
    }
    print_s $filename;
}continue{
    $pm->finish;
}
$pm->wait_all_children;
print "\n";

=cut
color scheme
    Not under version control:  blue
    Uncommitted changes:        red

    behind remote:              red on yellow
    ahead of remote:            green on yellow