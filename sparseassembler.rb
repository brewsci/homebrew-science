class Sparseassembler < Formula
  homepage "https://sites.google.com/site/sparseassembler/"
  # doi "10.1186/1471-2105-13-S6-S1"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/sparseassembler/SparseAssembler.zip"
  sha1 "9408dd3128ef896ef928dc774295d00d7306ac57"
  version "2012-08-17"

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
