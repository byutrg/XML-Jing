package XML::Jing;
# ABSTRACT: Validate XML files using an RNG schema using the Jing tool
use strict;
use warnings;
# VERSION

use Path::Tiny;
use File::ShareDir 'dist_dir';
my $java_location = dist_dir('XML-Jing');
my $jar_location = path($java_location,'jing.jar');
print $java_location;

require Inline;
Inline->import(
	Java => path($java_location,'RNGValidator.java'),
	CLASSPATH => $jar_location,
	STUDY => ['RNGValidator'],
);

__PACKAGE__->new->_run unless caller;

sub _run {
  my ($application) = @_;
  print { $application->{output_fh} }
    $application->message;
}

sub new {
  my ($class) = @_;
  my $application = bless {}, $class;
  $application->_init;
  $application;
}

sub _init {
  my ($application) = @_;
  $application->{output_fh} = \*STDOUT;
	$application->{input_fh} = \*STDIN;
}

sub output_fh {
	my ( $application, $fh ) = @_;
	if ($fh) {
		if(ref($fh) eq 'GLOB'){
			$application->{output_fh} = $fh;
		}
		else{
			open my $fh2, '>', $fh or die "Couldn't open $fh";
			$application->{output_fh} = $fh2;
		}
	}
	$application->{output_fh};
}

sub input_fh {
	my ( $application, $fh ) = @_;
	if ($fh) {
		if(ref($fh) eq 'GLOB'){
			$application->{input_fh} = $fh;
		}
		else{
			open my $fh2, '<', $fh or die "Couldn't open $fh";
			$application->{input_fh} = $fh2;
		}
	}
	$application->{input_fh};
}

sub message {
  "Your work starts here\n";
}

1;

	