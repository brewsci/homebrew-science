class Sparseassembler < Formula
  homepage "https://sites.google.com/site/sparseassembler/"
  # doi "10.1186/1471-2105-13-S6-S1"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/sparseassembler/SparseAssembler.zip"
  sha1 "9408dd3128ef896ef928dc774295d00d7306ac57"
  version "2012-08-17"

  bottle do
    cellar :any
    sha256 "a9ff1d429f594346583cc42817950a47253793f4c31cb39a364bf122dd3c51b6" => :yosemite
    sha256 "9da917b95c08b35cd3371e5f73d10c8a4f094fc06a142e45931d3c7227726d61" => :mavericks
    sha256 "5127010fd67b7d265220c90d1d26dd945db1100fcda093e00386aa49fb4a1781" => :mountain_lion
  end

  needs :openmp

  def install
    bin.mkdir
    cd "SparseAssemblerCode" do
      system "c++", "-o", bin/"SparseAssembler", "SparseAssembler.cpp",
        *(ENV["CXXFLAGS"] || "").split
    end
    cd "ReadsDenoiserCode" do
      system "c++", "-o", bin/"ReadsDenoiser",
        "ReadsDenoiser.cpp", "ReadsDenoising_Supp.cpp",
        *(ENV["CXXFLAGS"] || "").split
    end
    doc.install "Readme.txt"
  end

  test do
    system "#{bin}/SparseAssembler 2>&1 |grep kmer"
  end
end
