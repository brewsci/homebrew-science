class Bcalm < Formula
  desc "de Bruijn graph compaction in low memory"
  homepage "https://github.com/GATB/bcalm"
  # doi "10.1093/bioinformatics/btw279"
  # tag "bioinformatics"

  url "https://github.com/GATB/bcalm/releases/download/v2.0.0/bcalm-2.0.0.zip"
  sha256 "6d1d1d8b3339fff7cd0ec04b954a30e49138c1470efbcbcbf7b7e91f3c5b6d18"

  head "https://github.com/GATB/bcalm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "275e8b52ba361c7b709bea9ad8d321cd72c3771d76fabe86054cea9c7dfbf9a9" => :el_capitan
    sha256 "6850356f860b9e9a52f97303b64fa8d63c32d9448df7961ccce17decbd383c8a" => :yosemite
    sha256 "35e0e2996bb345741d4c74165664df68e10507d9b007afd41e5a886a08f845ce" => :mavericks
    sha256 "d7dcaebe036421cac51f91f5962d13b442b5b9afb52605c4e48ff2212fe2bdbd" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "bcalm", "bglue"
    end
    doc.install "README.md"
  end

  test do
    system bin/"bcalm"
    system bin/"bglue"
  end
end
