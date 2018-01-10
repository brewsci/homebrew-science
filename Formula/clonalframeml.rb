class Clonalframeml < Formula
  desc "Efficient Inference of Recombination in Bacterial Genomes"
  homepage "https://github.com/xavierdidelot/ClonalFrameML"
  # tag "bioinformatics"
  # doi "10.1371/journal.pcbi.1004041"

  url "https://github.com/xavierdidelot/ClonalFrameML/archive/v1.11.tar.gz"
  sha256 "395e2f14a93aa0b999fa152d25668b42450c712f3f4ca305b34533317e81cc84"

  head "https://github.com/xavierdidelot/ClonalFrameML.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "757cfd2bb691170354a55247a3ae4aef4cc970de45b1e983f14da48968fbb40f" => :sierra
    sha256 "8cf24a620451d7aae8313dceab7165c3471cb6a5675a98d7f0aa8c48d443826c" => :el_capitan
    sha256 "f253671f7c06e01516b0217bccbaf65000de54b7f1c37f6afbef1201b2fa9ac8" => :yosemite
    sha256 "4fbde640ea7c4f5e49683737f967d29b3f88d3579477790c3cab31df4592c19e" => :x86_64_linux
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
