class Kmergenie < Formula
  desc "Estimates the best k-mer length for genome de novo assembly"
  homepage "http://kmergenie.bx.psu.edu/"
  # doi "10.1093/bioinformatics/btt310"
  # tag "bioinformatics"

  url "http://kmergenie.bx.psu.edu/kmergenie-1.6976.tar.gz"
  sha256 "319db3dab3837347d710088ec203673e14b6751fa10d193f9ecf3afbc06e9d1e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "740048e294ca177c2ed1ad74d83a760057c64b7f9d0bb5cbd23f7ee8b2339090" => :el_capitan
    sha256 "a1df7810b31ab2d720722ecd4a570129ffe06eed4dcba6859bea952780081555" => :yosemite
    sha256 "1e3b96f7fa34fcaa59a6cdd0f4c12c16fa2462b0aec304c4ed06f3c04a2b1662" => :mavericks
    sha256 "620e31d5a64a7ec429d002fb2df5e409467064c210a6a6600fc5902d622f79bd" => :x86_64_linux
  end

  option "with-maxkmer=", "Specify maximum supported k-mer length (default: 121)"

  depends_on "r"

  def install
    ENV.deparallelize

    maxkmer = ARGV.value("with-maxkmer") || 121
    args = ["k=#{maxkmer}"]
    args << "osx=1" if OS.mac?
    system "make", *args

    libexec.install "kmergenie", "specialk", "scripts", "third_party"
    bin.install_symlink "../libexec/kmergenie"
    doc.install "CHANGELOG", "LICENSE", "README"
  end

  test do
    system "#{bin}/kmergenie 2>&1 | grep -q threads"
    system "#{libexec}/specialk 2>&1 | grep -q threads"
  end
end
