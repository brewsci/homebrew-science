require 'formula'

class Masurca < Formula
  homepage 'http://www.genome.umd.edu/masurca.html'
  #doi "10.1093/bioinformatics/btt476"
  url "ftp://ftp.genome.umd.edu/pub/MaSuRCA/v2.2.1/MaSuRCA-2.2.1.tar.gz"
  sha1 "a568d0afc9cf96e5351e8f4ef92c1b89a13011d6"

  keg_only 'MaSuRCA conflicts with jellyfish.'

  depends_on "pkg-config" => :build

  def install
    raise "MaSuRCA fails to build on Mac OS. See https://github.com/Homebrew/homebrew-science/issues/344" if OS.mac?

    # Fix the error ./install.sh: line 46: masurca: No such file or directory
    bin.mkdir
    cp "SuperReads/src/masurca", bin
    chmod 0755, bin/"masurca"

    ENV.deparallelize
    system "DEST=#{prefix} ./install.sh"
  end

  test do
    system "#{bin}/masurca -h"
  end
end
