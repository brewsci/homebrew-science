class Prodigal < Formula
  desc "Microbial gene finding program"
  homepage "http://prodigal.ornl.gov/"
  url "https://github.com/hyattpd/Prodigal/archive/v2.6.3.tar.gz"
  sha256 "89094ad4bff5a8a8732d899f31cec350f5a4c27bcbdd12663f87c9d1f0ec599f"
  head "https://github.com/hyattpd/Prodigal.git"
  # doi "10.1186/1471-2105-11-119"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "79729bb335ac93842f0d06282243184de24e7290ab8fea17bee0e54504f69159" => :sierra
    sha256 "0fadc805dab3dc9ac682bd9bb92555ee5a821906b09c2553aaf781fa4e022409" => :el_capitan
    sha256 "149c2a9a0a23843bd989119e7f80bb93572474645df16271e43415d3734e180f" => :yosemite
  end

  def install
    system "make"
    mv "prodigal2", "prodigal" if build.head?
    bin.install "prodigal"
    doc.install "CHANGES", "LICENSE", "VERSION", "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prodigal -v 2>&1")
  end
end
