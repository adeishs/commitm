package DescriptionGenerator;

use 5.20.0;
use warnings;

use Function::Parameters;
use List::Util qw( max min );
use Text::Fold;

my $DEBUG = 0;
my $MAX_LINES = 7;

fun random_from($descriptions_dir) {
    my @files = _get_files($descriptions_dir);
    my $file_count = scalar @files;

    # Given the use case, instead of croaking, we return
    # error messages as commit descriptions. Now that's
    # out of the box thinking.
    return "No description data files, setup via tools/get-files.sh"
        if $file_count == 0;

    my $file_idx = _randint($file_count);
    my $file_path = $files[$file_idx];

    open(my $fh, '<:encoding(UTF-8)', $file_path)
        or return "Could not open data file '$file_path': $!";

    my ($lines, $start, $end) = _select_lines(
        fh => $fh,
        filename => $file_path
    )->@{ qw(lines start end) };

    close($fh);

    my $text = fold_text( join("\n", @{$lines}) );
    $text = $text . "\n[$file_path:$start-$end]" if $DEBUG;
    return $text;
}


fun _get_files($dir) {
    return glob($dir . '/*.txt.clean');
}

fun _select_lines(:$fh, :$filename) {
    my $result_fn = fun ($lines, $start, $end) {
        return {
            lines => $lines,
            # start/end are line numbers for human debugging, make it 1-based.
            start => $start + 1,
            end => $end + 1
        };
    };

    chomp(my @lines = <$fh>);

    my $len = scalar @lines;

    return result_fn->(["[$filename]: empty data file"], -1, -1) if $len == 0;

    # We can have up to 7 lines of description.
    my $max_lines = $MAX_LINES;

    # Start: Give space for max lines of selection, but not
    # enough, than start at 0
    my $start_idx = max(0, _randint($len) - $max_lines);

    # End: Must >= Start, but no more than last line
    my $end_idx = min($len, $start_idx + _randint($max_lines));

    my @selection = @lines[$start_idx .. $end_idx];

    return $result_fn->(\@selection, $start_idx, $end_idx);
}

fun _randint($max_exclusive) {
    return int(rand($max_exclusive));
}

1;
