class Stacks < Formula
  homepage "http://creskolab.uoregon.edu/stacks/"
  #doi "10.1111/mec.12354"
  #tag "bioinformatics

  url "http://creskolab.uoregon.edu/stacks/source/stacks-1.23.tar.gz"
  sha1 "392607a195191d3f11f1db70a665ba33e9df0551"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "62926c850a22ff8c4da00a320d05de253c02ccab" => :yosemite
    sha1 "9c64ae474370d2bf60394edd6f110a8048cda863" => :mavericks
  end

  depends_on "google-sparsehash" => :recommended
  depends_on "htslib"

  needs :cxx11

  def install
    # OpenMP doesn't yet work on OS X with Apple-provided compilers.
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
