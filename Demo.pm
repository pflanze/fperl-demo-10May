package Demo;
@ISA="Exporter"; require Exporter;
@EXPORT=qw(foo);
@EXPORT_OK=qw();
%EXPORT_TAGS=(all=>[@EXPORT,@EXPORT_OK]);

use strict; use warnings; use warnings FATAL => 'uninitialized';

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
