use strict;
use warnings;
use Text::Markdown qw/markdown/;
use HTML::Template::Compiled;
use File::Copy qw/copy/;

my $dest_dir = shift @ARGV
                or die "Usage: $0 <destination-dir>";

my $t = HTML::Template::Compiled->new(
    filename        => 'web/index.tmpl',
    open_mode       => ':encoding(UTF-8)',
    default_escape  => 'HTML',
    global_vars     => 1,
);

open my $fh, '<', 'answers.md'
    or die "Cannot open 'answers.md' for reading: $!";
my $contents = do { local $/; <$fh> };
close $fh;

$t->param(body          => scalar(markdown($contents)));
$t->param(last_updated  => scalar(localtime +(stat 'answers.md')[9]));

my $fn = "$dest_dir/index.html";
open my $out, '>:encoding(UTF-8)', $fn
    or die "Cannot open '$fn' for writing: $!";
print { $out } $t->output;
close $out;

for (glob 'web/*') {
    next if /\.tmpl$/;
    copy $_, $dest_dir;
}
