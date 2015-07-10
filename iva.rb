class Iva < Formula
  desc "Iterative Virus Assembler"
  homepage "https://github.com/sanger-pathogens/iva"
  url "https://github.com/sanger-pathogens/iva/archive/v0.11.7.tar.gz"
  sha256 "8e2c2e6e627930ab4819c252bcc2f0a373cc85513a33274b997fb1160627589f"
  head "https://github.com/sanger-pathogens/iva.git"
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
