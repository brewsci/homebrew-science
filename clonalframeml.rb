class Clonalframeml < Formula
  desc "Efficient Inference of Recombination in Bacterial Genomes"
  homepage "https://github.com/xavierdidelot/ClonalFrameML"
  # tag "bioinformatics"
  # doi "10.1371/journal.pcbi.1004041"

  url "https://github.com/xavierdidelot/ClonalFrameML/archive/v1.11.tar.gz"
  sha256 "395e2f14a93aa0b999fa152d25668b42450c712f3f4ca305b34533317e81cc84"

  head "https://github.com/xavierdidelot/ClonalFrameML.git"

  bottle do
    cellar :any
    sha256 "09ccaab46eea44a62ffc6e2bda598099a6f83ba36c10855be99796529976a344" => :yosemite
    sha256 "d927b125595ec16af0e5e4b7f483dbd538737cf8b932c441baadcfeef235c9c0" => :mavericks
    sha256 "9215a9f0a8bcb333f6be6c9986c8a5d62dcf9160b690d5ad7937005e8cfc0daa" => :mountain_lion
    sha256 "bbd38c6efff78aff6e692d996aff80f4b978f9fabd0519986d529622fdbf2b96" => :x86_64_linux
  end

  def install
    cd "src" do
      exe = "ClonalFrameML"
      # https://github.com/xavierdidelot/ClonalFrameML/issues/56
      File.write("version.h", "#define ClonalFrameML_GITRevision #{version}\n")
      system ENV.cxx, "-O3", "main.cpp", "-o", exe, "-I.", "-Imyutils", "-Icoalesce"
      bin.install exe
    end
  end

  test do
    assert_match "recombination", shell_output("#{bin}/ClonalFrameML -h 2>&1", 13)
  end
end
