class Stacks < Formula
  homepage "http://creskolab.uoregon.edu/stacks/"
  #doi "10.1111/mec.12354"
  #tag "bioinformatics

  url "http://creskolab.uoregon.edu/stacks/source/stacks-1.22.tar.gz"
  sha1 "4c22bfc1ad313875050cd76666d1c500b351ecc5"

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
