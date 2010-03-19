
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Version::Next',
                       'DISTNAME' => 'Version-Next',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.11'
                                               },
                       'AUTHOR' => 'David Golden <dagolden@cpan.org>',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'increment module version numbers simply and correctly',
                       'EXE_FILES' => [],
                       'VERSION' => '0.001',
                       'PREREQ_PM' => {
                                        'Test::More' => '0.88',
                                        'Test::Exception' => '0.29',
                                        'File::Find' => '0',
                                        'File::Temp' => '0',
                                        'Sub::Exporter' => '0',
                                        'Carp' => '0'
                                      },
                       'LICENSE' => 'apache'
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



