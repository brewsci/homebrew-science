require "formula"

class SspaceLongread < Formula
  homepage "http://www.baseclear.com/lab-products/bioinformatics-tools/sspace-longread/"
  #doi "10.1186/1471-2105-15-211"
  #tag "bioinformatics"

  version "1-1"
  url "http://www.baseclear.com/download.php?file_id=1786"
  sha1 "7fa220ecea3120777ac4f6623e69c8e3404a1a36"

  depends_on "blasr"

  def install
    bin.mkdir
    # Add shebang line to the script
    system "echo '#!/usr/bin/perl' |cat - SSPACE-LongRead.pl >#{bin/"SSPACE-LongRead.pl"}"
    bin.install_symlink "SSPACE-LongRead.pl" => "SSPACE-LongRead"
  end

  test do
    system "#{bin}/SSPACE-LongRead -h 2>&1 |grep SSPACE-LongRead"
  end
end
