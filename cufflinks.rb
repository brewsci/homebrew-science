class Cufflinks < Formula
  desc "Transcriptome assembly, differential expression analysis for RNA-Seq"
  homepage "https://cole-trapnell-lab.github.io/cufflinks/"
  url "https://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-2.2.1.tar.gz"
  sha256 "e8316b66177914f14b3a0c317e436d386a46c4c212ca1b2326f89f8a2e08d5ae"
  revision 1

  bottle do
    rebuild 1
    sha256 "e20dea99324c0d39e570741a643d3f7d75e5d3ece9c278d2102480bf5be01bf9" => :sierra
    sha256 "0a25110bb25213a1260bb635c5ca4195c08d4203d8efa266d36707b6925258b1" => :el_capitan
    sha256 "789fd165d673c2c1dfefe2ed403b28781a0f5f608edb588c3af781a4670b9555" => :yosemite
  end

  if OS.mac? && MacOS.version == :mavericks
    depends_on "boost@1.55"
  else
    depends_on "boost"
  end

  depends_on "samtools@0.1" => :build
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
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/cuffdiff 2>&1 |grep -q cuffdiff"
  end
end
