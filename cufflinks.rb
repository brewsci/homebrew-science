class Cufflinks < Formula
  homepage "http://cufflinks.cbcb.umd.edu/"
  url "http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-2.2.1.tar.gz"
  sha256 "e8316b66177914f14b3a0c317e436d386a46c4c212ca1b2326f89f8a2e08d5ae"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "68750a99e5cf104666cfc068c4bfddf8c2aebe2cb44bf5360aac2b5f4e181000" => :yosemite
    sha256 "3313084062765bee932d05d0bc8477887ec6a61e788c9a465c907cc363b44370" => :mavericks
    sha256 "d1e789b72fe73af8cb46aa71feeedea398df2c4b1e9fce5604492a7945143487" => :mountain_lion
  end

  depends_on "homebrew/versions/boost155" => :build
  depends_on "samtools-0.1" => :build
  depends_on "eigen"

  def install
    ENV["EIGEN_CPPFLAGS"] = "-I#{Formula["eigen"].opt_include}/eigen3"
    ENV.append "LIBS", "-lboost_system-mt -lboost_thread-mt -lboost_serialization-mt"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.j1
    system "make", "install"
  end

  test do
    system "#{bin}/cuffdiff 2>&1 |grep -q cuffdiff"
  end
end
