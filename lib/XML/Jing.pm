package XML::Jing;
# ABSTRACT: Validate XML files using an RNG schema using the Jing tool
use strict;
use warnings;
# VERSION

=head1 NAME

XML::Jing- validate XML files against RNG using Jing

=head1 SYNOPSIS

	use XML::Jing;
	my $jing = XML::Jing->new('path/to/rng','use compact RNG');
	my $error = $jing->validate('path/to/xml');
	if(!$error){
		print 'no errors!';
	}else{
		print $error;
	}

=head1 DESCRIPTION

This module is a simple interface to Jing which allows checking XML files for validity using an RNG file.

=cut

use Path::Tiny;
use File::ShareDir 'dist_dir';

#add the Jing jar to the system classpath
BEGIN{
	use Config;
	my $separator = $Config{path_sep} || ':';
	my $jar_location = path(dist_dir('XML-Jing'),'jing.jar');
	$ENV{CLASSPATH} .= $separator . $jar_location;
}

require Inline;
Inline->import(
	Java => path(dist_dir('XML-Jing'),'RNGValidator.java'),
	STUDY => ['RNGValidator'],
);

=head1 METHODS

=head2 C<new>

Arguments: the path to the RNG file to use in validation, and a boolean indicating whether or not the given
RNG file uses compact syntax (false means XML syntax)

Creates a new instance of C<XML::Jing>.

=cut

sub new {
  my ($class, $rng_path, $compact) = @_;
  my $self = bless {}, $class;
  $self->{validator} = new XML::Jing::RNGValidator("$rng_path", $compact);
  
  return $self;
}

=head2 C<validate>

Argument: path to the XML file to validate 

Returns: The first error found in the document, or C<undef> if no errors were found.

=cut

sub validate {
	my ($self, $xml_path) = @_;
	return $self->{validator}->validate("$xml_path");
}

1;

=TODO

Jing has more functionality and options than what I have interfaced with here.

Also, it would be nice to be able to get ALL of the errors in an XML file, instead of jut the first one.
 
=head1 SEE ALSO
 
Jing homepage: L<http://www.thaiopensource.com/relaxng/jing.html>

Inline::Java was used to interface with Jing: L<Inline::Java>
