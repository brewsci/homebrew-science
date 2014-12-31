class FastqTools < Formula
  homepage "http://homes.cs.washington.edu/~dcjones/fastq-tools/"
  #tag "bioinformatics"

  url "https://homes.cs.washington.edu/~dcjones/fastq-tools/fastq-tools-0.7.tar.gz"
  sha1 "75540e322543041c9005f248b2b9bcdba5be728a"

  depends_on "pcre" => :build

  def install
    system "./configure",
      "--disable-debug", "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fastq-grep", "--version"
  end
end
