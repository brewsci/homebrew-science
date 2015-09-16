class Circlator < Formula
  desc "A tool to circularize genome assemblies"
  homepage "https://github.com/sanger-pathogens/circlator"
  url "https://github.com/sanger-pathogens/circlator/archive/v0.16.0.tar.gz"
  sha256 "c5331e1a687dacedd134356177671228e592c772df3306d6e037e55bd62d84df"
  head "https://github.com/sanger-pathogens/circlator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d292c6d6bb730ac1574d9ce5bd4eb35cb1a7f785a87e191bb758a832649db1d6" => :el_capitan
    sha256 "61e8c3a5489bd09c7012c2fe325aa557445ef78c1ae27c8a31d2d478b71db209" => :yosemite
    sha256 "7765ab7ce30088c19218285eaf2ad68152a3a4a22c0c059b1ec4c078649e99d3" => :mavericks
  end

  # tag "bioinformatics"

  depends_on "zlib" unless OS.mac?
  depends_on :python3
  depends_on "bwa"
  depends_on "prodigal"
  depends_on "samtools"
  depends_on "spades"
  depends_on "homebrew/python/numpy" => ["with-python3"]
  depends_on "homebrew/python/pymummer"

  resource "pysam" do
    url "https://pypi.python.org/packages/source/p/pysam/pysam-0.8.3.tar.gz"
    sha256 "343e91a1882278455ef9a5f3c9fc4921c37964341785bf22432381d18e6d115e"
  end

  resource "pyfastaq" do
    url "https://pypi.python.org/packages/source/p/pyfastaq/pyfastaq-3.6.0.tar.gz"
    sha256 "3a052466f89db1e1ac6cfb475117fdf8466ed319b62aabf9531e38f569b51588"
  end

  resource "bio_assembly_refinement" do
    url "https://pypi.python.org/packages/source/b/bio_assembly_refinement/bio_assembly_refinement-0.3.3.tar.gz"
    sha256 "3547d54b357702d659d244ed6493b6553eb2e72dcf79e88cdae2c595b933bf91"
  end

  def install
    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"

    %w[pysam pyfastaq bio_assembly_refinement].each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "Available commands", shell_output("circlator -h 2>&1", 0)
  end
end
