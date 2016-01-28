class Cufflinks < Formula
  homepage "http://cufflinks.cbcb.umd.edu/"
  url "https://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-2.2.1.tar.gz"
  sha256 "e8316b66177914f14b3a0c317e436d386a46c4c212ca1b2326f89f8a2e08d5ae"

  bottle do
    revision 1
    sha256 "5fc3c25ec82ac08f4f6698293ae541314a276a0866c1c745ae4c621d92dfc357" => :el_capitan
    sha256 "1877762ec375968e508f5ab07c586b50ab7032ca92ffc2661cca1a767572e855" => :yosemite
    sha256 "5929896c71cdb5866f6cfb8da6d2c6b8a43ce4d4833529484aedef79a4a58ed3" => :mavericks
  end

  if OS.mac? && MacOS.version == :mavericks
    depends_on "homebrew/versions/boost155"
  else
    depends_on "boost"
  end

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
