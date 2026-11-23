#!/usr/bin/env bash
# Print the text of a Word (.docx) file: one paragraph per block, list items as "- ".
# Claude Code can't read .docx files directly; this lets a project brief sent as a Word attachment be read
# and saved as BRIEF.md. Needs only perl (it comes with Git for Windows and macOS); falls back to unzip if
# perl's zip module is missing.
# Usage: bash docx-to-text.sh "<path to file.docx>"
f="$1"
if [ -z "$f" ] || [ ! -f "$f" ]; then echo "docx-to-text: file not found: $f" >&2; exit 1; fi

xml="$(perl -MIO::Uncompress::Unzip=unzip -e \
  'unzip($ARGV[0] => \my $x, Name => "word/document.xml", Transparent => 0) or exit 3; binmode STDOUT; print $x' "$f" 2>/dev/null)"
if [ -z "$xml" ] && command -v unzip >/dev/null 2>&1; then
  xml="$(unzip -p "$f" word/document.xml 2>/dev/null)"
fi
if [ -z "$xml" ]; then echo "docx-to-text: couldn't open $f as a Word document" >&2; exit 2; fi

printf '%s' "$xml" | perl -0777 -ne '
  while (/<w:p[ >].*?<\/w:p>/gs) {
    my $p = $&; my $list = ($p =~ /<w:numPr>|<w:pStyle w:val="List/);
    $p =~ s/<w:tab\/>/\t/g; $p =~ s/<w:br\/>/\n/g; $p =~ s/<[^>]+>//g;
    $p =~ s/&lt;/</g; $p =~ s/&gt;/>/g; $p =~ s/&quot;/"/g; $p =~ s/&apos;/\x27/g; $p =~ s/&amp;/&/g;
    next unless $p =~ /\S/;
    print "\n" if $prev && !$list; $prev = $list;
    print(($list ? "- " : ""), $p, ($list ? "\n" : "\n\n")); $n++;
  }
  END { exit($n ? 0 : 4) }'
rc=$?
if [ $rc -eq 4 ]; then echo "docx-to-text: no text found in $f" >&2; exit 2; fi
exit $rc
