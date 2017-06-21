class Analysis < Formula
  desc "Programs for the (pre-NGS-era) analysis of population-genetic data."
  homepage "https://github.com/molpopgen/analysis"
  url "https://github.com/molpopgen/analysis/archive/0.8.8.tar.gz"
  sha256 "f9ef9e0a90fce2c0f4fe462d6c05e22fef22df1c23b63a7c64ad7b538f6e8bb0"
  revision 3
  # tag "bioinformatics"

  bottle do
    sha256 "8ef5508260edfc8a4f9f0110a3b9e139ac5d5f9f240e25095a9f9c6085a84824" => :sierra
    sha256 "81ac46c9cdc2148018026aacd0cf8deb7a33e96be154bf457cb2d1de67b99097" => :el_capitan
    sha256 "35284aca3f7cffeb41bcfc5a70e0c3f67dd1a4f41e15c80ba55ad0951e7336ab" => :yosemite
    sha256 "914c84eab0cf8c3450821b3018696b1770ccfacc1e2fe90f492d3b7edd8a6e56" => :x86_64_linux
  end

  depends_on "gsl"
  depends_on "boost"
  depends_on "zlib" unless OS.mac?

  # vendor an older version of libsequence as analysis no longer
  # tracks libsequence updates and API changes
  resource "libsequence" do
    url "https://github.com/molpopgen/libsequence/archive/1.8.7.tar.gz"
    sha256 "07fd87a8454b107afabc00a5b359f84f3766fd5a3629885bc87be17d25a937f1"
  end

  needs :cxx11

  def install
    ENV.cxx11

    resource("libsequence").stage do
      system "./configure", "--prefix=#{libexec}/libsequence",
        "CPPFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0"
      system "make"
      ENV.deparallelize { system "make", "check" }
      system "make", "install"
    end

    ldflags = "LDFLAGS=-L#{libexec}/libsequence/lib"
    ldflags += " -Wl,-rpath=#{libexec}/libsequence/lib" unless OS.mac?
    system "./configure", "--prefix=#{prefix}", ldflags,
      "CPPFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0",
      "CXXFLAGS=-I#{libexec}/libsequence/include"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "codon", shell_output("#{bin}/gestimator 2>&1", 1)
  end
end
