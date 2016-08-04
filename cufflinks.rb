class Cufflinks < Formula
  homepage "http://cufflinks.cbcb.umd.edu/"
  url "https://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-2.2.1.tar.gz"
  sha256 "e8316b66177914f14b3a0c317e436d386a46c4c212ca1b2326f89f8a2e08d5ae"
  revision 1

  bottle do
    sha256 "3260dd2b456cdfe3c426383f41b03548126f84e2557e9e500a705b5daeb65d76" => :el_capitan
    sha256 "e15378aae804c77f2814228f6d134a92bc9f8945b47f6ff0160a2c64fb930076" => :yosemite
    sha256 "e08041daa9d87a3636239170b5c4c59ae5c8da8fb6f43862f3a87bb267e0aea8" => :mavericks
    sha256 "e75b0f1ea0163be81054855c2e63c1ad9d4f7e60b2630383f40e32f6890c46b7" => :x86_64_linux
  end

  if OS.mac? && MacOS.version == :mavericks
    depends_on "homebrew/versions/boost155"
  else
    depends_on "boost"
  end

  depends_on "samtools-0.1" => :build
  depends_on "eigen"

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

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
