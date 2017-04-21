class Analysis < Formula
  desc "Programs for the (pre-NGS-era) analysis of population-genetic data."
  homepage "https://github.com/molpopgen/analysis"
  url "https://github.com/molpopgen/analysis/archive/0.8.8.tar.gz"
  sha256 "f9ef9e0a90fce2c0f4fe462d6c05e22fef22df1c23b63a7c64ad7b538f6e8bb0"
  revision 2
  # tag "bioinformatics"

  bottle do
    sha256 "2dcdbb025d1a1c68d6ec551bf1a6a6af663c0e94e19ff1faacea2f106bc7a790" => :sierra
    sha256 "825c7efb29eb13e9d85a4841a7f16788e1aa7d6eec92c43c47f943216ec181c3" => :el_capitan
    sha256 "a8fb8144516347f9722b79044108e41a668152fc6649b01dcb02efff2fc1a2e0" => :yosemite
    sha256 "fa8c4a067de7239f06910d6af45daa7decffceb56475b300f5c8947f78d27190" => :x86_64_linux
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
