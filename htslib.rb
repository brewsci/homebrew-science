class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/htslib/archive/1.3.tar.gz"
  sha256 "291a54090df3bc367b509890e1cfa34d53b1ee9be42c5fa6c2b1e2ec8f8b13af"
  head "https://github.com/samtools/htslib.git"

  bottle do
    cellar :any
    sha256 "f4da5a770d365c81bd991baa1853115cc7b50ecf80a860edc17f7d00a0172169" => :el_capitan
    sha256 "103cb4591cd062d49d81ae1793fb4ff51a134fa1f12300b2465dffadeea6c765" => :yosemite
    sha256 "6a626435fe905e10d812c3aad2e2efea477279e46b4083714695d624f41ea18b" => :mavericks
  end

  conflicts_with "tabix", :because => "both htslib and tabix install bin/tabix"

  def install
    system "make", "install", "prefix=#{prefix}"
    pkgshare.install "test"
  end

  test do
    sam = share/"htslib/test/ce#1.sam"
    assert_match "SAM", shell_output("htsfile #{sam}")
    system "bgzip -c #{sam} > sam.gz"
    assert File.exist?("sam.gz")
    system "tabix", "-p", "sam", "sam.gz"
    assert File.exist?("sam.gz.tbi")
  end
end
