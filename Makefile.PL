
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Use MongoDB in Mojolicious',
  'AUTHOR' => 'Ben van Staveren <madcat@cpan.org>',
  'BUILD_REQUIRES' => {
    'Module::Build' => '0.38',
    'Mojolicious::Lite' => '0',
    'Test::Mojo' => '0',
    'Test::More' => '0',
    'Try::Tiny' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31',
    'Module::Build' => '0.38'
  },
  'DISTNAME' => 'Mojolicious-Plugin-Mongodb',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Mojolicious::Plugin::Mongodb',
  'PREREQ_PM' => {
    'Mojo::Base' => '0',
    'MongoDB' => '0'
  },
  'VERSION' => '1.07',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



