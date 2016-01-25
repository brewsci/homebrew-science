class Edirect < Formula
  homepage "http://www.ncbi.nlm.nih.gov/books/NBK179288/"
  # tag "bioinformatics"

  url "ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz"
  sha256 "2d108d780cef39bc4fdfd265d97ebaafe59ec937667061f54274f17a40a1a74f"
  version "3.60"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ce62b8ffb5735b8155c701080c8e8436783b37f284544020bb28430cf4c2f55" => :el_capitan
    sha256 "ecb86895b52fa5d77aca9868a3c1a303bd86a37d701cb01cb283417ba1fb3217" => :yosemite
    sha256 "205623c6f64a0c761a10c825249a9a0db6627d5bd6f8c6b7cfc2f822bfa8c81a" => :mavericks
  end

  def install
    doc.install "README"
    libexec.install "setup.sh", "setup-deps.pl"
    bin.install Dir["*"]
  end

  test do
    system "#{bin}/esearch", "-version"
  end
end
