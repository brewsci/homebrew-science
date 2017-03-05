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
    sha256 "a318c66f32dc429455d9ff113d17a23bcb3d631460f8e843395b01bd02bb9b7d" => :sierra
    sha256 "5fc0ff69ace3b2e0eab82440f1ba7bcfc669b0a06ceda4c34674bb2a41204773" => :el_capitan
    sha256 "d6a0041d900da0d3c27ad2ee9807c6ab909d541b0d833948b538d5d064ca0459" => :yosemite
    sha256 "073869bb50a8d5fba8faea2cc46f64b63315077b2fff6099b9fa963636c2936f" => :x86_64_linux
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
