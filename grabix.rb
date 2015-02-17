class Grabix < Formula
  homepage "https://github.com/arq5x/grabix"
  # tag "bioinformatics"
  url "https://github.com/arq5x/grabix/archive/1.4.tar.gz"
  sha1 "687c6874741127c012e84cad4d85a5116afc1034"
  head "https://github.com/arq5x/grabix.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "b10d761ad686e2ea8e86e5fac59cb49f1abc85ff" => :yosemite
    sha1 "627dd3da48e1ba0888a0527e597d271e740e40f8" => :mavericks
    sha1 "ed81ea6340dfefdb5862aac293e7e8a17204ddc1" => :mountain_lion
  end

  def install
    system "make"
    bin.install "grabix"
    doc.install "README.md"
    share.install "simrep.chr1.bed"
  end

  test do
    assert_equal `#{bin}/grabix check #{share}/simrep.chr1.bed`.chomp, "no"
  end
end
