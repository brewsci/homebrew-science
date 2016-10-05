class Tagdust < Formula
  desc "Generic method to extract reads from sequencing data"
  homepage "http://tagdust.sourceforge.net"
  url "https://downloads.sourceforge.net/tagdust/files/tagdust-2.33.tar.gz"
  sha256 "8825e2975eae11e19033f233b5951517b5126bd19e049a500b1e048eaa215f84"
  # tag "bioinformatics"
  # doi "10.1186/s12859-015-0454-y"

  option "without-test", "Skip build-time tests (not recommended)"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "#{bin}/tagdust", "-v"
  end
end
