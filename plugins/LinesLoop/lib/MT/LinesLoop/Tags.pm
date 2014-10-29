package MT::LinesLoop::Tags;

use strict;
use warnings;

sub hdlr_LinesLoop {
    my ( $ctx, $args, $cond ) = @_;
    my $value;
    if ( exists $args->{tag} ) {
        $args->{tag} =~ s/^MT:?//i;
        $value = $ctx->tag( $args->{tag}, $args, $cond );
    }
    elsif ( exists $args->{name} ) {
        $value = $ctx->var( $args->{name} );
    }
    elsif ( exists $args->{var} ) {
        $value = $ctx->var( $args->{var} );
    }

    my $spliter = qr(\n);
    my $blank = $args->{blank};

    my @lines = split $spliter, $value;
    @lines = grep { $_ ne '' } @lines unless $blank;

    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $result = '';
    my $vars = $ctx->{__stash}{vars} ||= {};
    my $size = scalar @lines;
    for( my $i = 0; $i < $size; $i++ ) {
        local $ctx->{__stash}->{lines_loop_line} = $lines[$i];
        local $vars->{__value__} = $lines[$i];
        local $vars->{__first__} = ( $i == 0 )? 1: 0;
        local $vars->{__last__} = ( $i == $size-1 )? 1: 0;
        local $vars->{__odd__} = ( $i % 2 ) == 1;
        local $vars->{__even__} = ( $i % 2 ) == 0;
        local $vars->{__counter__} = $i;

        defined( my $partial = $builder->build($ctx, $tokens, $cond) ) || return;
        $result .= $partial;
    }

    $result;
}

sub hdlr_LinesLoopLine {
    my ( $ctx, $args ) = @_;
    $ctx->stash('lines_loop_line');
}

sub hdlr_LinesLoopHeader {
    my ( $ctx, $args, $cond ) = @_;
    $ctx->var('__first__') ? 1 : 0;
}

sub hdlr_LinesLoopFooter {
    my ( $ctx, $args, $cond ) = @_;
    $ctx->var('__last__') ? 1 : 0;
}

1;