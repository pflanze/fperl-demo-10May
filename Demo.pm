package Demo;
@ISA="Exporter"; require Exporter;
@EXPORT=qw(mystream foo);
@EXPORT_OK=qw();
%EXPORT_TAGS=(all=>[@EXPORT,@EXPORT_OK]);

use strict; use warnings; use warnings FATAL => 'uninitialized';

use FP::List qw(cons null);
use FP::Lazy 'lazy';
use FP::Stream; # to load the lazy sequence operators so that
		# e.g. `mystream(5,6,7)->map(sub{$_[0]*2})` calculates
		# its result lazily, too.

sub mystream_iterate {
    my ($elements, $i)= @_;
    lazy {
	$i <= $#$elements
	  ? cons( $$elements[$i], mystream_iterate($elements, $i+1) )
	  : null # (null is the end of list marker, same as `list()`)
    }
}

sub mystream {
    mystream_iterate [@_], 0
}

use FP::Repl;

sub foo {
    my ($x)=@_;
    if ($x < 100) {
	foo( $x+1 )
    } else {
	repl;
	#die "hi"
    }
}

1
