class Swarm < Formula
  desc "Robust and fast clustering method for amplicons"
  homepage "https://github.com/torognes/swarm"
  url "https://github.com/torognes/swarm/archive/v2.1.9.tar.gz"
  sha256 "cf9b580ebd57bbc6d074fbfef42b3ec0f9d24a50436822deb34ee1a9a94044cb"
  head "https://github.com/torognes/swarm.git"
  # doi "10.7717/peerj.1420", "10.7717/peerj.593"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9210c40ca8298f48a6e199f4f0d653b5aa20a804c6981acbaeb7a1f7b3f040b" => :el_capitan
    sha256 "a4063aa6d1255a498e1c010489a38011f37c5454bd84ff39d41668e8e142c44f" => :yosemite
    sha256 "3f46038c3334df0db03ac85a8ba573c099d8d2bbfd3313e358664095c85560cb" => :mavericks
    sha256 "0309262e98ab2e87cf3f5d582e7a450e65ca1ec9442e7a74483a931c444c1c68" => :x86_64_linux
  end

  def install
    system "make", "-C", "src"
    bin.install "bin/swarm"
    man1.install "man/swarm.1"
    doc.install "man/swarm_manual.pdf", "CITATION", "LICENSE", "README.md"
  end

  test do
    assert_match "Quince", shell_output("#{bin}/swarm --version 2>&1", 0)
  end
end
