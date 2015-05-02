class Kmergenie < Formula
  homepage "http://kmergenie.bx.psu.edu/"
  # doi "10.1093/bioinformatics/btt310"
  # tag "bioinformatics"

  url "http://kmergenie.bx.psu.edu/kmergenie-1.6976.tar.gz"
  sha256 "319db3dab3837347d710088ec203673e14b6751fa10d193f9ecf3afbc06e9d1e"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "61a4897c10b8e2cafb6a5cd823cf9ddac5f0826ff6abe7c331ac6d1c2a4e7d01" => :yosemite
    sha256 "f832032cdabffe987bc576226b9fb9a9c5e0ef682a5ccf8e18d78beb65e663c3" => :mavericks
    sha256 "18e7b379c41f80e7f064f1d96230b9c0632d4ca0f27e109633260444cee676a4" => :mountain_lion
  end

  depends_on "r"

  def install
    ENV.deparallelize
    system "make"
    libexec.install "kmergenie", "specialk",
      "scripts", "third_party"
    bin.install_symlink "../libexec/kmergenie"
    doc.install "CHANGELOG", "LICENSE", "README"
  end

  test do
    system "#{bin}/kmergenie 2>&1 |grep -q kmergenie"
    system "#{libexec}/specialk"
  end
end
