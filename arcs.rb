class Arcs < Formula
  desc "Scaffold genome sequence assemblies using 10x Genomics data"
  homepage "https://github.com/bcgsc/arcs"
  url "https://github.com/bcgsc/arcs/archive/v1.0.0.tar.gz"
  sha256 "3b104675d49ace02d8241aff82e72192034ecd0ec35f25d611eb560f698750c4"
  head "https://github.com/bcgsc/arcs.git"
  # tag "bioinformatics"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build

  def install
    # Remove broken symlinks.
    rm ["COPYING", "INSTALL"]
    inreplace "autogen.sh", "automake -a", "automake -a --foreign"
    system "./autogen.sh"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/arcs --help")
  end
end
