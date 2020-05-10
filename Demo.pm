package Demo;
@ISA="Exporter"; require Exporter;
@EXPORT=qw(mystream foo);
@EXPORT_OK=qw();
%EXPORT_TAGS=(all=>[@EXPORT,@EXPORT_OK]);

use strict; use warnings; use warnings FATAL => 'uninitialized';

use FP::List qw(cons null list);
use FP::Lazy 'lazy';
use FP::Stream; # imports `Weakened`, and also to load the lazy sequence
                # operators so that
                # e.g. `mystream(5,6,7)->map(sub{$_[0]*2})` calculates
                # its result lazily, too.
use v5.16; # __SUB__

sub mystream {
    my @elements= @_;
    sub {
	my ($i)= @_;
	my $__SUB__= __SUB__; # I'd love for this not to be necessary
	lazy {
	    $i <= $#elements
	      ? cons( $elements[$i], $__SUB__->($i+1) )
	      : null # (null is the end of list marker, same as `list()`)
	}
    }->(0)
}

use Chj::TEST;

TEST {
    mystream(5,6,7)->map(sub{$_[0]*2})->list
} list(10, 12, 14);

TEST {
    ref( mystream(5,6,7)->map(sub{$_[0]*2}) )
} 'FP::Lazy::Promise';


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
