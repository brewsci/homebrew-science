class Stacks < Formula
  desc "Pipeline for building loci from short-read sequences"
  homepage "http://creskolab.uoregon.edu/stacks/"
  # doi "10.1111/mec.12354"
  # tag "bioinformatics

  url "http://creskolab.uoregon.edu/stacks/source/stacks-1.37.tar.gz"
  sha256 "11be4417504e4f14d64d0c022e1a9c7ced822ce529f251defbd1b83b34fc288d"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bbae5b0bfd0bb6401335ef96b428fd289e88f3ecc9aee914aff4663a5ad67c1" => :el_capitan
    sha256 "ecca3422bd1fe4b591dbdc356507a7fae4a240ee7d82ec7b624d1c179c247470" => :yosemite
    sha256 "644cb0b2ed7052f4853bdbb9bba435911f27cb41b254b15d0fadf328557a3391" => :mavericks
  end

  depends_on "htslib"

  if MacOS.version < :mavericks
    depends_on "google-sparsehash" => [:recommended, "c++11"]
  else
    depends_on "google-sparsehash" => :recommended
  end

  needs :cxx11

  def install
    ENV.libcxx

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-sparsehash" if build.with? "google-sparsehash"

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      For instructions on setting up the web interface:
          #{prefix}/README

      The PHP and MySQL scripts have been installed to:
          #{share}
    EOS
  end

  test do
    system "#{bin}/ustacks", "--version"
  end
end
