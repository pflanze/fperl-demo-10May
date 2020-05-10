package Demo;
@ISA="Exporter"; require Exporter;
@EXPORT=qw(mystream foo);
@EXPORT_OK=qw();
%EXPORT_TAGS=(all=>[@EXPORT,@EXPORT_OK]);

use strict; use warnings; use warnings FATAL => 'uninitialized';

use FP::List qw(cons null);
use FP::Lazy 'lazy';
use FP::Stream; # imports `Weakened`, and also to load the lazy sequence
                # operators so that
                # e.g. `mystream(5,6,7)->map(sub{$_[0]*2})` calculates
                # its result lazily, too.

sub mystream {
    my @elements= @_;
    my $next; $next= sub {
	my ($i)= @_;
	my $next= $next; # I'd love for this not to be necessary
	lazy {
	    $i <= $#elements
	      ? cons( $elements[$i], &$next($i+1) )
	      : null # (null is the end of list marker, same as `list()`)
	}
    };
    Weakened($next)->(0)  # I'd love for the `Weakened` not to be necessary
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
