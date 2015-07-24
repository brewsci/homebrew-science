class Sparseassembler < Formula
  homepage "https://sites.google.com/site/sparseassembler/"
  # doi "10.1186/1471-2105-13-S6-S1"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/sparseassembler/SparseAssembler.zip"
  sha1 "9408dd3128ef896ef928dc774295d00d7306ac57"
  version "2012-08-17"

  bottle do
    cellar :any
    sha1 "209503883314cd020633fc0f6e859bd3a33439b7" => :yosemite
    sha1 "1281430fd29de1d589a7b9607b636434b9a3d2ef" => :mavericks
    sha1 "3e7d67740a382e860934191fa731b4334cc10ed6" => :mountain_lion
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
