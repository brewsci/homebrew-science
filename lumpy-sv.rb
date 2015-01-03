require "formula"

class LumpySv < Formula
  homepage "https://github.com/arq5x/lumpy-sv"
  url "https://github.com/arq5x/lumpy-sv/releases/download/0.2.8/lumpy-sv-0.2.8.tar.gz"
  sha1 "d337c6871c1ecc374ff274af04978cadbf364b54"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "a5a489043b490388f615f62ab0b1c10edeaf60f5" => :yosemite
    sha1 "6d8b7dc39b39e0cb351fb67254562f25b8e4deca" => :mavericks
    sha1 "b7d514ef6a9f96feaeab07bda98a17d1c53cc608" => :mountain_lion
  end

  depends_on "bamtools" => :recommended
  depends_on "samtools" => :recommended
  depends_on "bedtools" => :recommended
  depends_on "bwa" => :optional
  depends_on "novoalign" => :optional
  depends_on "yaha" => :optional

  def install
    ENV.deparallelize
    system "make"
    bin.install "bin/lumpy"
    (share/"lumpy-sv").install Dir["scripts/*"]
  end

  test do
    system "lumpy 2>&1 |grep -q structural"
  end
end
