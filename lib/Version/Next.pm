# 
# This file is part of Version-Next
# 
# This software is Copyright (c) 2010 by David Golden.
# 
# This is free software, licensed under:
# 
#   The Apache License, Version 2.0, January 2004
# 
use strict;
use warnings;
package Version::Next;
our $VERSION = '0.001';
# ABSTRACT: increment module version numbers simply and correctly

# Dependencies
# use version 0.81 (); # XXX not out yet
use Carp 0 ();

# Exporting
use Sub::Exporter 0 ( -setup => { exports => [ 'next_version' ] } );

sub next_version {
  my $version = shift;
  return 0 unless defined $version;

  # XXX when next version.pm comes out, use version::is_lax
  Carp::croak( "Doesn't look like a version number: '$version'" )
    unless $version =~ m{\Av?[0-9._]+\z};

  my $new_ver;
  my $num_dots =()= $version =~ /(\.)/g;
  my $has_v = $version =~ /^v/;
  my $is_alpha = $version =~ /\A[^_]+_\d+\z/;

  if ( $has_v || $num_dots > 1 ) { # vstring
    $version =~ s{^v}{} if $has_v;
    my @parts = split /\./, $version;
    if ( $is_alpha ) { # vstring with alpha
      push @parts, split /_/, pop @parts;
    }
    my @new_ver;
    while ( @parts ) {
      my $p = pop @parts;
      if ( $p < 999 || ! @parts ) {
        unshift @new_ver, $p+1;
        last;
      }
      else {
        unshift @new_ver, 0;
      }
    }
    $new_ver = $has_v ? 'v' : '';
    $new_ver .= join( ".", map { 0+$_ } @parts, @new_ver );
    if ( $is_alpha ) {
      $new_ver =~ s{\A(.*)\.(\d+)}{$1_$2};
    }
  }
  else { # decimal fraction
    my $alpha_neg_offset;
    if ( $is_alpha ) {
      $alpha_neg_offset = index( $version, "_" ) +1 - length( $version );
      $version =~ s{_}{};
    }
    my ($fraction) = $version =~ m{\.(\d+)$};
    my $n = defined $fraction ? length($fraction) : 0;
    $new_ver = sprintf("%.${n}f",$version + (10**-$n));
    if ( $is_alpha ) {
      substr($new_ver, $alpha_neg_offset, 0, "_");
    }
  }
  return $new_ver;

}

1;



=pod

=head1 NAME

Version::Next - increment module version numbers simply and correctly

=head1 VERSION

version 0.001

=head1 SYNOPSIS

   use Version::Next;
 
   my $new_version = next_version( $old_version );

=head1 DESCRIPTION

This module provides a simple, correct way to increment a Perl module version
number.  It does not attempt to guess what the original version number author
intended, it simply increments in the smallest possible fashion.  Decimals are
incremented like an odometer.  Dotted decimals are incremented piecewise and
presented in a standardized way.

If more complex version manipulation is necessary, you may wish to consider
L<Perl::Version>.

=head1 USAGE

This module uses L<Sub::Exporter> for optional exporting.  Nothing is exported
by default.

=head2 C<<< next_version >>>

   my $new_version = next_version( $old_version );

Given a string, this function make the smallest logical increment and returns
it.  The input string is very minimally checked that it resembles a version
number.  Given C<<< undef >>>, the function returns C<<< 0 >>>.

Decimal versions are incremented like an odometer, preserving the original
number of decimal places.  If an underscore is present (indicating an "alpha"
version), its relative position is preserved.  Examples:

   0.001    ->   0.002
   0.999    ->   1.000
   0.1229   ->   0.1230
   0.12_34  ->   0.12_35
   0.12_99  ->   0.13_00

Dotted-decimal versions have the least significant element incremented by one.
If the result exceeds C<<< 999 >>>, the element resets to C<<< 0 >>> and the next
most significant element is incremented, and so on.  Any leading zero padding
is removed.  Examples:

  v1.2.3     ->  v1.2.4
  v1.2.999   ->  v1.3.0
  v1.999.999 ->  v2.0.0
  v1.2.3_4   ->  v1.2.3_5
  v1.2.3_999 ->  v1.2.4_0

=head1 SEE ALSO

=over

=item *

L<Perl::Version>

=back

=head1 AUTHOR

  David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut


__END__

