use 5.20.0;
use warnings;

use Encode qw( encode_utf8 );
use FindBin qw( $Bin $Script );
use lib "$Bin/lib";

my $SKIP_INITIAL_LINES = 300;
my $MAX_LINES = $SKIP_INITIAL_LINES + 1100;


my $file_path = $ARGV[0];

die "No file path supplied!" unless $file_path;

clean($file_path);



sub clean {
    my ($file_path) = @_;

    # Trim out leading and trailing spaces
    # Exclude empty lines
    # Skip first 100 lines, usually just metadata

    open(my $fh, '<:encoding(UTF-8)', $file_path)
        or die "Could not open file '$file_path': $!";

    my $skip = 0;
    my $max_lines = 0;

    my @lines;

    while (my $line = <$fh>) {
        next if $skip++ < $SKIP_INITIAL_LINES; # Usually just metadata
        last if $max_lines++ == $MAX_LINES;    # Limit sizes 

        $line = trim($line);
        $line = remove_footnote_markers($line);

        next if (!$line || $line eq '');       # Trash empty lines

        # With Gutenberg text files, especially plays, a line marker
        # is significant to differentiate sentences.
        push @lines, $line . "\n";
    }

    # Instead of working with lines, we wish to work with sentences.
    # A simple heuristic is to use common punctuation marks as sentence
    # separators.
    my $sentences_text = to_sentences(\@lines);
    print encode_utf8($sentences_text);
}

sub trim {
    my ($s) = @_;

    # Remove trailing and leading whitespace
    $s =~ s/^\s+|\s+$//g;

    # Remove more than 1 consecutive whitespace with a single space
    $s =~ s/\s\s//g;

    return $s;
}

sub remove_footnote_markers {
    my ($s) = @_;

    # '[12]' -> ''
    $s =~ s/\[[0-9]+\]//g;

    return $s;
}

sub to_sentences {
    my ($lines_ref) = @_;

    my $text = join('', @{$lines_ref});

    # We wish to retain punctuation marks after splitting, capture groups
    # add an extra field, but no clue how to use it in the result, it just
    # dumps it out as a split item
    # So we split in distinct steps, one for each punctuation mark.
    my $marker = '<cleanfile.pl>';
    my $sentences = join($marker, split(/\. /, $text . "."));
    $sentences = join($marker, split(/\? /, $sentences . "?"));
    $sentences = join($marker, split(/\! /, $sentences . "!"));

    # Finally, we split into lines
    $sentences = join("\n", split(/$marker/, $sentences));

    return $sentences;
}