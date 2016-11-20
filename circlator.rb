class Circlator < Formula
  include Language::Python::Virtualenv

  desc "Tool to circularize genome assemblies"
  homepage "https://sanger-pathogens.github.io/circlator/"
  url "https://github.com/sanger-pathogens/circlator/archive/v1.4.0.tar.gz"
  sha256 "dfd07bed66237adc48417466f44f1953c16bf0da59a752a0ae90b9f5fdefe402"
  head "https://github.com/sanger-pathogens/circlator.git"

  bottle do
    sha256 "7d8300780a21e651dcef00ef8129bd9a1f1bdb37318401372c553a5534f86de3" => :sierra
    sha256 "f10027f6da750911e734462df4ae3345a2c9500d7b4608e6e61e8fd9849c54d7" => :el_capitan
    sha256 "50fd7b4d61fb758f2006713b6eb336a67868208560d6f7b15c3e6d1618ac7135" => :yosemite
    sha256 "944788648b87365a980fe7a48c2e0cea8bd80d51482db1fd8c84aea8c9fd3aef" => :x86_64_linux
  end

  # tag "bioinformatics"

  depends_on :python3
  depends_on "bwa"
  depends_on "mummer"
  depends_on "prodigal"
  depends_on "samtools"
  depends_on "spades"
  depends_on "zlib" unless OS.mac?

  resource "et_xmlfile" do
    url "https://files.pythonhosted.org/packages/22/28/a99c42aea746e18382ad9fb36f64c1c1f04216f41797f2f0fa567da11388/et_xmlfile-1.0.1.tar.gz"
    sha256 "614d9722d572f6246302c4491846d2c393c199cfa4edc9af593437691683335b"
  end

  resource "jdcal" do
    url "https://files.pythonhosted.org/packages/9b/fa/40beb2aa43a13f740dd5be367a10a03270043787833409c61b79e69f1dfd/jdcal-1.3.tar.gz"
    sha256 "b760160f8dc8cc51d17875c6b663fafe64be699e10ce34b6a95184b5aa0fdc9e"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/7e/75/9bb309f80e4f75d139ecc55e9edf65c5844336b5a84966a609267255f961/openpyxl-2.4.0.tar.gz"
    sha256 "21c02df20d626ebd2e92b3c33066ba3ad18520a92d4b6d734f4dee99b4289283"
  end

  resource "pyfastaq" do
    url "https://files.pythonhosted.org/packages/0e/5d/8b39442b62c43da835c89f4c244d037bc7fcd8b47b0c0fff6e8d9097a035/pyfastaq-3.14.0.tar.gz"
    sha256 "54dc8cc8b3d24111f6939cf563833b8e9e78777b9cf7b82ca8ddec04aa1c05f2"
  end

  resource "pymummer" do
    url "https://files.pythonhosted.org/packages/96/04/a67728a727a8214de494b06178bfaca025550156889953d581a141976ec0/pymummer-0.10.1.tar.gz"
    sha256 "04a06d2faecf5b972b3a60e1493520e384cb10dd5c00bf7d643a1d059c4e8f87"
  end

  resource "pysam" do
    url "https://files.pythonhosted.org/packages/27/89/bf8c44d0bfe9d0cadab062893806994c168c9f490f67370fc56d6e8ba224/pysam-0.8.4.tar.gz"
    sha256 "30cf23931edf8a426678811f234bca4a83a53438028b323f2ef55792562d9dea"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/circlator test outdir")
    assert_match "Finished run on test data OK", output
  end
end
