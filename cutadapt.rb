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
    sha256 "a1d6850badc3e9c7eaced05e8a6dbc0b21cdfef22802cac60c55be1334d363e5" => :sierra
    sha256 "006bad70fcb2e7631aadd048a8ab79c6f51f9862cfb16610a0b988e60b89e8b4" => :el_capitan
    sha256 "95d9d8e8241116abb0ed52456c7473fb87de38a6499201acd28a78f94da98582" => :yosemite
    sha256 "dbeed8e0dc35c5838b3aa2be9a72e71e6d6dbfc76b3574b9f0a3fc1ed76d36f7" => :x86_64_linux
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
