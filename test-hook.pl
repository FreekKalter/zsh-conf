#!/usr/bin/env perl
use v5.14;
use Path::Class;
use File::Spec;
use Cwd;

my $dir = dir( File::Spec->rel2abs( getcwd ), ".git" );
my %tmpENV = (
          'GIT_AUTHOR_NAME' => 'Freek Kalter',
          'PWD' => '/home/fkalter/github/zsh-conf',
          'GIT_PREFIX' => '',
          'PATH' => '/usr/lib/git-core:/home/fkalter/perl5/perlbrew/bin:/home/fkalter/perl5/perlbrew/perls/perl-5.16.1/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/fkalter/scripts:/home/fkalter/scripts',
          'GIT_DIR' => $dir,
          'GIT_AUTHOR_EMAIL' => 'freek@kalteronline.org',
          'GIT_INDEX_FILE' => '.git/index',
          'GIT_EDITOR' => ':',
          'OLDPWD' => '/home/fkalter/github/zsh-conf/.git/hooks',
          '_' => '/usr/bin/git',
          'GIT_AUTHOR_DATE' => '@1351534578 +0100'
);
local %ENV = (%ENV, %tmpENV);
`$ARGV[0]`;
