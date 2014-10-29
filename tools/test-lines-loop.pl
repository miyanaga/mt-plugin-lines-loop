#!/usr/bin/perl
package MT::SubForm::Test;
use strict;
use warnings;
use FindBin;
use lib ("$FindBin::Bin/../lib", "$FindBin::Bin/../extlib");
use Test::More;

use MT;
use base qw( MT::Tool );
use Data::Dumper;

sub pp { print STDERR Dumper($_) foreach @_ }

my $VERSION = 0.1;
sub version { $VERSION }

sub help {
    return <<'HELP';
OPTIONS:
    -h, --help             shows this help.
HELP
}

sub usage {
    return '[--help]';
}


## options
my ( $blog_id, $user_id, $verbose );

sub options {
    return (
    )
}

sub uses {
    use_ok('MT::LinesLoop::Tags');
}

sub test_template {
    my %args = @_;

    require MT::Builder;
    require MT::Template::Context;
    my $ctx = MT::Template::Context->new;
    my $builder = MT::Builder->new;

    $ctx->stash('sub_form_data', $args{data}) if $args{data};
    $ctx->stash('sub_form_schema', $args{schema}) if $args{schema};

    my $tokens = $builder->compile($ctx, $args{template}) or die $ctx->errstr || 'Feild to compile.';
    defined ( my $result = $builder->build($ctx, $tokens) )
        or die $ctx->errstr || 'Failed to build.';

    $result =~ s/^\n+//gm;
    $result =~ s/\n\s*\n/\n/gm;
    my @nodes = split( /::/, (caller(1))[3] );
    is($result, $args{expect}, pop @nodes);
}

sub template_basic {
    my %args;
    $args{template} = <<'EOT';
<mt:SetVarBlock name="text">
Lorem Ipsum is simply dummy text of the printing and typesetting industry.
Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
when an unknown printer took a galley of type and scrambled it to make a type specimen book.
</mt:SetVarBlock>
<mt:LinesLoop name="text">
<mt:if name="__first__">first: <mt:LinesLoopLine>
<mt:elseif name="__last__">last: <mt:var name="__value__">
<mt:else><mt:LinesLoopLine>
</mt:if>
</mt:LinesLoop>
EOT

    $args{expect} = <<'EOH';
first: Lorem Ipsum is simply dummy text of the printing and typesetting industry.
Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
last: when an unknown printer took a galley of type and scrambled it to make a type specimen book.
EOH

    test_template(%args);
}

sub template_header_footer {
    my %args;
    $args{template} = <<'EOT';
<mt:SetVarBlock name="text">
Lorem Ipsum is simply dummy text of the printing and typesetting industry.
Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
when an unknown printer took a galley of type and scrambled it to make a type specimen book.
</mt:SetVarBlock>
<mt:LinesLoop name="text">
<mt:LinesLoopHeader>START</mt:LinesLoopHeader>
<mt:var name="__value__">
<mt:LinesLoopFooter>FINISH</mt:LinesLoopFooter>
</mt:LinesLoop>
EOT

    $args{expect} = <<'EOH';
START
Lorem Ipsum is simply dummy text of the printing and typesetting industry.
Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
when an unknown printer took a galley of type and scrambled it to make a type specimen book.
FINISH
EOH

    test_template(%args);
}

sub main {
    my $mt = MT->instance;
    my $class = shift;

    $verbose = $class->SUPER::main(@_);

    uses;
    template_basic;
    template_header_footer;
}

__PACKAGE__->main() unless caller;

done_testing();


