class EMem < Formula
  desc "Efficiently compute MEMs between large genomes"
  homepage "http://www.csd.uwo.ca/~ilie/E-MEM/"
  url "http://www.csd.uwo.ca/~ilie/E-MEM/e-mem.zip"
  version "1.0.0"
  sha256 "dccf8f3fdd397a7ff370593e2efe9fe060d194cf1b279d835502f9008ca34632"
  # doi "10.1093/bioinformatics/btu687"
  # tag "bioinformatics"

  needs :openmp
  depends_on "boost" => :build

  def install
    cd "e-mem_2"
    system "make"
    bin.install "e-mem"
    prefix.install_metafiles
    prefix.install "example"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/e-mem --help")
  end
end
