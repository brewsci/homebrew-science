class Tasr < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/tasr"
  # doi "10.1371/journal.pone.0019816"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/tasr/releases/1.5.1/tasr_v1-5-1.tar.gz"
  version "1.5.1"
  sha256 "2101283f6a58b1ce83d29f09ac55d52a6ac863170ebafb3b4844be33a87cbcc1"

  bottle do
    cellar :any
    sha256 "3e5f480a3d5b9121acb526f8b444cd4b52f47698763c02fe65e07de1df70d1b5" => :yosemite
    sha256 "c3d1d87211da6d353c3aa88f5370baf6104474eecff571fc011d7c228d222349" => :mavericks
    sha256 "7707c5fcdf98f4ebf64e1f828dc824bf5b839571bf7b76c248e0d8275d001e1c" => :mountain_lion
  end

  def install
    bin.install "TASR"
    doc.install "TASR.readme"
    prefix.install "test", "tools"
  end

  test do
    system "#{bin}/tasr |grep tasr"
  end
end
