class Ropebwt2 < Formula
  desc "Incremental construction of FM-index for DNA sequences"
  homepage "https://github.com/lh3/ropebwt2"
  url "https://github.com/lh3/ropebwt2/archive/49b280debe54db51d9ca81972a9db76c2f6290f7.tar.gz"
  version "r181"
  sha256 "bcd762ea63d907a52efd573b944ca2d3d1338d1f814ad855124d450916e0d75a"
  head "https://github.com/lh3/ropebwt2.git"
  # doi "10.1093/bioinformatics/btu541"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "407baaadb20ffd53b724b2298ab4c205a76e96f4c3958551939b93c72dcf2215" => :el_capitan
    sha256 "0162fa95c05f37dd58d1fb417f1943704d4f9d28c56b70ccc7aa3311cd310b9d" => :yosemite
    sha256 "0ba8646910d7315a29a073d9c30f420ee42504c38b0e9355c79644247abd3f42" => :mavericks
    sha256 "3d31d89896a16ee30e0bf1d6d0ba2c12694330de80a1bc600a85fc8bdaeb04c7" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "ropebwt2"
    doc.install "README.md", "tex/ropebwt2.tex"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ropebwt2 2>&1", 1)
  end
end
