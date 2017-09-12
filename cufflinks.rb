class Cufflinks < Formula
  desc "Transcriptome assembly, differential expression analysis for RNA-Seq"
  homepage "https://cole-trapnell-lab.github.io/cufflinks/"
  url "https://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-2.2.1.tar.gz"
  sha256 "e8316b66177914f14b3a0c317e436d386a46c4c212ca1b2326f89f8a2e08d5ae"
  revision 3

  bottle do
    sha256 "d9e4198c221f3cf2a1a81f5dcf6faefa2e272d7ca2616cf2886a229d7513f9ad" => :sierra
    sha256 "04344209d7c17496d1af0d4bd56513dc7a271e2344fa5e1b5d9c1155377799bb" => :el_capitan
    sha256 "0f09fdb99d08dc958242a79e2b37601063d1d77d8f8d111a063f8c608850a39a" => :x86_64_linux
  end

  if OS.mac? && MacOS.version == :mavericks
    depends_on "boost@1.55"
  else
    depends_on "boost"
  end

  depends_on "samtools@0.1" => :build
  depends_on "eigen"

  def install
    inreplace "src/biascorrection.h", "boost/tr1/unordered_map.hpp", "boost/unordered_map.hpp"

    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    ENV["EIGEN_CPPFLAGS"] = "-I#{Formula["eigen"].opt_include}/eigen3"
    ENV.append "LIBS", "-lboost_system-mt -lboost_thread-mt -lboost_serialization-mt"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/cuffdiff 2>&1 |grep -q cuffdiff"
  end
end
