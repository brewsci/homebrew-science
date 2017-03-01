class Tasr < Formula
  desc "Targeted assembler of short sequence reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/tasr"
  # doi "10.1371/journal.pone.0019816"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/tasr/releases/1.6.2/tasr_v1-6-2.tar.gz"
  version "1.6.2"
  sha256 "8e92f58a4f0a5b986f581299b81c9447a2805b3da2a7b8afa1f5254ba8126207"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ace4ae6c67642df9f438b036bb165f7401a4eb527be28f8134b344e40992ada" => :el_capitan
    sha256 "6c683e53fb273c4d463370bbdcdabe3d88b29eb49445b4c1e0bf660c24bb01a6" => :yosemite
    sha256 "f84b4a6362d2a4b795ece3a6d67faab21f482be64535bd2dac24f164dd225dbc" => :mavericks
    sha256 "20946e2ba76babddeda1f5024bc461c876351e8f22130ecb24c1f55f5730a323" => :x86_64_linux
  end

  def install
    bin.install "TASR"
    bin.install "TASR-Bloom"
    doc.install "TASR-readme.txt"
    pkgshare.install %w[test tools lib]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/TASR", 255)
  end
end
