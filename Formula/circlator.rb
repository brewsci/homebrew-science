class Circlator < Formula
  include Language::Python::Virtualenv

  desc "Tool to circularize genome assemblies"
  homepage "https://sanger-pathogens.github.io/circlator/"
  url "https://github.com/sanger-pathogens/circlator/archive/v1.5.3.tar.gz"
  sha256 "61ed44698b2eda9c32715b3a43b1143474a1251df77599e9510db4358874d93d"
  head "https://github.com/sanger-pathogens/circlator.git"

  bottle do
    cellar :any
    sha256 "33bb5772afb4ee8ee43ee0e8158f04631fe3abc42de7696f8cc5920a743e407e" => :high_sierra
    sha256 "e29a175734459b543ad1747d5d6011970fb5a04a0e769063e418bd99e7fbbfcb" => :sierra
    sha256 "44805e75c6e20e48916b3d0390f82b09e1801f330534d12a27081be025d9be19" => :el_capitan
    sha256 "0e065988fb9607b36ae338b480f8a510d5c9e0355c46af8d6020ecbe04302012" => :x86_64_linux
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
    url "https://files.pythonhosted.org/packages/8c/75/c4e557207c7ff3d217d002d4fee32b4e5dbfc5498e2a2c9ce6b5424c5e37/openpyxl-2.4.9.tar.gz"
    sha256 "95e007f4d121f4fd73f39a6d74a883c75e9fa9d96de91d43c1641c103c3a9b18"
  end

  resource "pyfastaq" do
    url "https://files.pythonhosted.org/packages/91/5e/cd2a8b4e3b601b89b9af2ecd706ffade96b6b2c89b2f8d50ab8a8bac3fed/pyfastaq-3.16.0.tar.gz"
    sha256 "368f3f1752668283f5d1aac4ea80e9595a57dc92a7d4925d723407f862af0e4e"
  end

  resource "pymummer" do
    url "https://files.pythonhosted.org/packages/79/4c/15ef3401217379fcc53e33e67a9aa1b89449825d7246fa527879892b5305/pymummer-0.10.3.tar.gz"
    sha256 "986555d36828bd90bf0e63d9d472e5b20c191f0e51123b5252fa924761149fc2"
  end

  resource "pysam" do
    url "https://files.pythonhosted.org/packages/31/17/31d317006a74941d2caddac97c5106601fe4da467653d0f061702e9ead95/pysam-0.13.tar.gz"
    sha256 "1829035f58bddf26b0cb6867968178701c2a243518ea697dcedeebff487979af"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"
    output = shell_output("#{bin}/circlator test outdir")
    assert_match "Finished run on test data OK", output
  end
end
