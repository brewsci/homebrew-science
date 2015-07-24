class Kmergenie < Formula
  desc "Estimates the best k-mer length for genome de novo assembly"
  homepage "http://kmergenie.bx.psu.edu/"
  # doi "10.1093/bioinformatics/btt310"
  # tag "bioinformatics"

  url "http://kmergenie.bx.psu.edu/kmergenie-1.6976.tar.gz"
  sha256 "319db3dab3837347d710088ec203673e14b6751fa10d193f9ecf3afbc06e9d1e"

  bottle do
    cellar :any
    revision 1
    sha256 "f473e4557bb61ed1080ff14bd01e98e9ff0efe018b284d44fb0e25ca8b72a3dd" => :yosemite
    sha256 "08cbf904855f35de632712a0adcdd1a197c5d31226520c2399e7da061e5b496b" => :mavericks
    sha256 "1f811c455d9ed0bc98517c2a238d8cfdc38a24d06fcfd5d5e7fa1c308d417ea1" => :mountain_lion
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
