class Iva < Formula
  desc "Iterative Virus Assembler"
  homepage "https://github.com/sanger-pathogens/iva"
  url "https://github.com/sanger-pathogens/iva/archive/v1.0.0.tar.gz"
  sha256 "c2054b7e922accf03e038d5f128b1e2f96c6cabc92c8a67a3b01e0412c29b7d3"
  head "https://github.com/sanger-pathogens/iva.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "486eec6468c9c8fd9d18e7c742401dff0fba1b33dfa5142dfb806d966d2662c8" => :yosemite
    sha256 "7a8c29b61694656a4869163482ad224aac719d4a2799a605ee6b722c89a4a6da" => :mavericks
    sha256 "8b5487cb63eaf6c241c07a139a0e3721e70e6e1ba13241557f92e86573f19f2a" => :mountain_lion
  end

  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btv120"

  depends_on :python3
  depends_on "kmc"
  depends_on "mummer"
  depends_on "smalt"
  depends_on "trimmomatic"
  depends_on "samtools"
  depends_on "homebrew/python/numpy" => ["with-python3"]

  resource "pysam" do
    url "https://pypi.python.org/packages/source/p/pysam/pysam-0.8.3.tar.gz"
    sha256 "343e91a1882278455ef9a5f3c9fc4921c37964341785bf22432381d18e6d115e"
  end

  resource "pyfastaq" do
    url "https://pypi.python.org/packages/source/p/pyfastaq/pyfastaq-3.5.0.tar.gz"
    sha256 "599b28db5a05072335eacd3cea458aff511239e34a9559aaf2e7fe94cce785a9"
  end

  resource "decorator" do
    url "https://pypi.python.org/packages/source/d/decorator/decorator-3.4.2.tar.gz"
    sha256 "7320002ce61dea6aa24adc945d9d7831b3669553158905cdd12f5d0027b54b44"
  end

  resource "networkx" do
    url "https://pypi.python.org/packages/source/n/networkx/networkx-1.10rc2.tar.gz"
    sha256 "bd7a732a3747d94e2e53eebce3ab636cda8cc53dcf53164ecfa39fda20f5e7f6"
  end

  def install
    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"

    %w[pysam pyfastaq decorator networkx].each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "-f reads_fwd -r reads_rev", shell_output("iva -h 2>&1", 0)
  end
end
