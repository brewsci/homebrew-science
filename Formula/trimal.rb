class Trimal < Formula
  desc "Automated alignment trimming in phylogenetic analyses"
  homepage "http://trimal.cgenomics.org/"
  # doi "10.1093/bioinformatics/btp348"
  # tag "bioinformatics"
  url "https://github.com/scapella/trimal/archive/v1.4.1.tar.gz"
  sha256 "cb8110ca24433f85c33797b930fa10fe833fa677825103d6e7f81dd7551b9b4e"

  head "https://github.com/scapella/trimal"

  bottle do
    cellar :any
    rebuild 1
    sha256 "76b6694d725d1f3a65bd4d1f775dc237da52bd8f2a5262ff2f9072e16f8b13e2" => :yosemite
    sha256 "16ce4cf3b913dce9483a546a9c5d72c773055c9761dc4335bf50d6c3e4c1a144" => :mavericks
    sha256 "6bd8489fb354901de7a24ea46267d5d2011690b420561fded76277fd73694eea" => :mountain_lion
    sha256 "a6a56fa1b72caab44c38ce60c1d59a837562b31c2c44e28b50d9eb674b6409dc" => :x86_64_linux
  end

  def install
    system "make", "-C", "source", "CC=c++"
    bin.install "source/readal", "source/trimal", "source/statal"
    pkgshare.install "dataset"
    doc.install %w[AUTHORS CHANGELOG LICENSE README]
  end

  test do
    assert_match "Salvador", shell_output("#{bin}/trimal 2>&1", 0)
    assert_match "Salvador", shell_output("#{bin}/readal 2>&1", 0)
    assert_match "Salvador", shell_output("#{bin}/statal 2>&1", 0)
  end
end
