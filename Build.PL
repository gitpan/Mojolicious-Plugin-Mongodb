
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'Module::Build' => '0.3601',
    'Mojolicious::Lite' => '0',
    'Test::Mojo' => '0',
    'Test::More' => '0'
  },
  'configure_requires' => {
    'ExtUtils::MakeMaker' => '6.31',
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'Use MongoDB in Mojolicious',
  'dist_author' => [
    'Ben van Staveren <madcat@cpan.org>'
  ],
  'dist_name' => 'Mojolicious-Plugin-Mongodb',
  'dist_version' => '1.06',
  'license' => 'perl',
  'module_name' => 'Mojolicious::Plugin::Mongodb',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Mojo::Base' => '0',
    'MongoDB' => '0'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
