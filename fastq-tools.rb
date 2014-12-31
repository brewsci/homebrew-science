class FastqTools < Formula
  homepage "http://homes.cs.washington.edu/~dcjones/fastq-tools/"
  #tag "bioinformatics"

  url "https://homes.cs.washington.edu/~dcjones/fastq-tools/fastq-tools-0.7.tar.gz"
  sha1 "75540e322543041c9005f248b2b9bcdba5be728a"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "5850c1fbf7847d0158bb7577bd0f2b587c847ba8" => :yosemite
    sha1 "78d9148bca44a47567599e5fecfe5876d60b7242" => :mavericks
    sha1 "6ef44b63c4fbb3b488b843211d913bc66be635fa" => :mountain_lion
  end

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
