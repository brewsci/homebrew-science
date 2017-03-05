class Sambamba < Formula
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba"
  # doi "10.1093/bioinformatics/btv098"
  # tag "bioinformatics"

  stable do
    url "https://github.com/lomereiter/sambamba.git",
        :tag => "v0.6.6",
        :revision => "63cfd5c7b3053e1f7045dec0b5a569f32ef73d06"

    resource "undeaD" do
      url "https://github.com/dlang/undeaD/archive/v1.0.6.tar.gz"
      sha256 "fbdfe2be480e71988599b0d980545892929a899aa76f09de6c4ed8f5558c70c0"
    end
  end

  bottle do
    sha256 "18d33a5ff6dad35ac79bc360f23623ccc910f28b41073e9e1dcd92538f454615" => :sierra
    sha256 "93eb5f7159b8c271985705abf7894dd4651bfa13063aca2f593a4518fdcdf101" => :el_capitan
    sha256 "1d69b9413a45c367c404393ce6ad4881382479c8dd14e3451744dd7fb0a9b666" => :yosemite
    sha256 "ce148c414ef8312b5d76445aa22692b3d2b97bb6cb1b4a06cf73dfcdb22ad8b4" => :x86_64_linux
  end

  head do
    url "https://github.com/lomereiter/sambamba.git"

    resource "undeaD" do
      url "https://github.com/dlang/undeaD.git"
    end
  end

  depends_on "ldc" => :build

  def install
    ENV.deparallelize
    (buildpath/"undeaD").install resource("undeaD")
    system "make", "sambamba-ldmd2-64"
    bin.install "build/sambamba"
    doc.install "README.md"
    pkgshare.install "BioD/test/data/ex1_header.bam"
  end

  test do
    system "#{bin}/sambamba", "sort", "-t2", "-n", "#{pkgshare}/ex1_header.bam",
                              "-o", "ex1_header.nsorted.bam", "-m", "200K"
    assert File.exist?("ex1_header.nsorted.bam")
  end
end
