class Cutadapt < Formula
  include Language::Python::Virtualenv

  desc "Removes adapter sequences, primers, and poly-A tails"
  homepage "https://github.com/marcelm/cutadapt"
  url "https://files.pythonhosted.org/packages/16/e3/06b45eea35359833e7c6fac824b604f1551c2fc7ba0f2bd318d8dd883eb9/cutadapt-1.14.tar.gz"
  sha256 "f32990a8b2f8b53f8f4c723ada3d256a8e8476febdd296506764cc8e83397d3d"
  head "https://github.com/marcelm/cutadapt.git"
  # doi "10.14806/ej.17.1.200"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "c069f5025f5b1b63df75a95a187d6af3ea6b64bffa7dccf4e0fb5c2253ef3027" => :sierra
    sha256 "5ed3d933438e9e63325a0ec832f7d4ce341d309d513a6c80b7042c24b651996c" => :el_capitan
    sha256 "85ca64bc5fd24d2137b6d61d3fce4bc9c54574747b9beece23b47bdd59a9ea8c" => :yosemite
    sha256 "60cd4273e6f64c2f3968ac06244c0492551cd65d0046dc932c2202d0fc4dae4a" => :x86_64_linux
  end

  depends_on :python3

  resource "xopen" do
    url "https://files.pythonhosted.org/packages/53/1f/01d32269f01fccf1a6d8d5d795f939cb56274c82f7520cc25152ee8de486/xopen-0.2.1.tar.gz"
    sha256 "9b054f8c1c906ca416412e8b7430bac4e683a2c5ce1a59e7e62d667418165dfe"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    assert_match "interleaved", shell_output("#{bin}/cutadapt -h 2>&1")
  end
end
