class Tasr < Formula
  desc "Targeted assembler of short sequence reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/tasr"
  # doi "10.1371/journal.pone.0019816"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/tasr/releases/1.5.1/tasr_v1-5-1.tar.gz"
  version "1.5.1"
  sha256 "2101283f6a58b1ce83d29f09ac55d52a6ac863170ebafb3b4844be33a87cbcc1"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "6ace4ae6c67642df9f438b036bb165f7401a4eb527be28f8134b344e40992ada" => :el_capitan
    sha256 "6c683e53fb273c4d463370bbdcdabe3d88b29eb49445b4c1e0bf660c24bb01a6" => :yosemite
    sha256 "f84b4a6362d2a4b795ece3a6d67faab21f482be64535bd2dac24f164dd225dbc" => :mavericks
    sha256 "20946e2ba76babddeda1f5024bc461c876351e8f22130ecb24c1f55f5730a323" => :x86_64_linux
  end

  def install
    bin.install "TASR"
    doc.install "TASR.readme"
    pkgshare.install %W[test tools]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/TASR", 255)
  end
end
