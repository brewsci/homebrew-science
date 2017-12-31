class EMem < Formula
  desc "Efficiently compute MEMs between large genomes"
  homepage "https://www.csd.uwo.ca/~ilie/E-MEM/"
  url "https://github.com/lucian-ilie/E-MEM/archive/v1.0.1.tar.gz"
  sha256 "70a5a1e8b4e190d117b8629fff3493a4762708c8c0fe9eae84da918136ceafea"
  # doi "10.1093/bioinformatics/btu687"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "39a2643a1cf154afbd6c170ab3d086caca3128dc71b65c7edbfd99fe8a08214a" => :high_sierra
    sha256 "f491c76bbbc316320e11f7321f5640e44a4ef089c1caf6e7e53e013cf428ff6d" => :sierra
    sha256 "d703dfcd20a6667d7dada62734ce3c88630337a64f3c2e6d470e29f579da1c01" => :el_capitan
    sha256 "584a65212d0555912b150574310a846e7a546d93695dcd2592301998ed5f76fa" => :x86_64_linux
  end

  needs :openmp
  depends_on "boost" => :build

  def install
    bin.mkpath
    system "make", "BIN_DIR=#{bin}"
    pkgshare.install "example"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/e-mem --help")
  end
end
