class Trimal < Formula
  homepage "http://trimal.cgenomics.org/"
  # doi "10.1093/bioinformatics/btp348"
  # tag "bioinformatics"
  head "https://github.com/scapella/trimal"

  url "https://github.com/scapella/trimal/archive/v1.4.1.tar.gz"
  sha256 "cb8110ca24433f85c33797b930fa10fe833fa677825103d6e7f81dd7551b9b4e"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "2331c8c379260be28d7e5257aa3c5e3247c6ed2559d128ed203de27dcfa8f687" => :yosemite
    sha256 "0c7b37a4c4e046101f4d65906502006b2bc10abaeb27e2917c9f476de72ad9f6" => :mavericks
    sha256 "1c5deb720c4e9638094fd4c323219e092e32863c841fda10639619ca85e5ba68" => :mountain_lion
  end

  def install
    system "make", "-C", "source", "CC=c++"
    bin.install "source/readal", "source/trimal", "source/statal"
    share.install "dataset"
    doc.install %w[AUTHORS CHANGELOG LICENSE README]
  end

  test do
    assert_match "Salvador", shell_output("trimal 2>&1", 0)
    assert_match "Salvador", shell_output("readal 2>&1", 0)
    assert_match "Salvador", shell_output("statal 2>&1", 0)
  end
end
