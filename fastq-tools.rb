require "formula"

class FastqTools < Formula
  homepage "http://homes.cs.washington.edu/~dcjones/fastq-tools/"
  url "https://homes.cs.washington.edu/~dcjones/fastq-tools/fastq-tools-0.6.tar.gz"
  sha1 "4c4d455e59ec89cc73ffa7701f9ff40c86cee2e0"

  depends_on "pcre" => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/fastq-grep", "--version"
  end
end
