class Bpel2owfn < Formula
  desc "WS-BPEL to oWFN translator"
  homepage "https://www.gnu.org/software/bpel2owfn"
  url "http://download.gna.org/service-tech/bpel2owfn/bpel2owfn-2.4.tar.gz"
  sha256 "1a6e49673bb9c30491d26904a26f8f71fc310676833c4e8c5d89aca8dfa43ad6"

  head do
    url "http://svn.gna.org/svn/service-tech/trunk/bpel2owfn"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "flex" => :build
    depends_on "bison" => :build
    depends_on "gengetopt" => :build
    depends_on "help2man" => :build
    depends_on "kimwitu++" => :build
    depends_on "gnu-sed" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-assert",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bpel2owfn", "--help"
  end
end
