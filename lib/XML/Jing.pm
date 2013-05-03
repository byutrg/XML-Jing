package XML::Jing;
# ABSTRACT: Validate XML files using an RNG schema using the Jing tool
use strict;
use warnings;
# VERSION

use Path::Tiny;
use File::ShareDir 'dist_dir';
BEGIN{
	use Config;
	my $separator = $Config{path_sep} || ':';
	my $jar_location = path(dist_dir('XML-Jing'),'jing.jar');
	$ENV{CLASSPATH} .= $separator . $jar_location;
}

require Inline;
Inline->import(
	Java => path(dist_dir('XML-Jing'),'RNGValidator.java'),
	# CLASSPATH => $jar_location,
	STUDY => ['RNGValidator'],
	# PACKAGE => 'main',
);
# __PACKAGE__->new->_run unless caller;

# sub _run {
#   my ($application) = @_;
#   print { $application->{output_fh} }
#     $application->message;
# }

sub new {
  my ($class, $rng_path, $compact) = @_;
  my $self = bless {}, $class;
  $self->{validator} = new XML::Jing::RNGValidator("$rng_path", $compact);
  
  return $self;
}

sub validate {
	my ($self, $xml_path) = @_;
	return $self->{validator}->validate("$xml_path");
}

1;

	