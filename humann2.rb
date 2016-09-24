class Humann2 < Formula
  desc "HUMAnN2: The HMP Unified Metabolic Analysis Network"
  homepage "https://huttenhower.sph.harvard.edu/humann"
  # doi "10.1371/journal.pcbi.1002358"
  # tag "bioinformatics"

  url "https://bitbucket.org/biobakery/humann2/downloads/humann2_v0.4.0.tar.gz"
  sha256 "a9f5272627de6f6bfd42f18e2d6c918982fe0a9f0e4848e7e8d8ed79c91ca77b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9dffd7689f34089b0d0f1189b7b13cce9ef34a61c99c1965c0741b6539b58bd" => :el_capitan
    sha256 "f173e0be965d44a9370032ba9472abab787b4310dbfa4e3bd84297f6a48abbcf" => :yosemite
    sha256 "252aa105284d46b58ce213d9ef901b75554b5471c903ad45ffa3ab73ee6acd0a" => :x86_64_linux
  end

  depends_on "bowtie2"
  depends_on "diamond"
  depends_on "metaphlan"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *(Language::Python.setup_install_args(libexec) + ["--bypass-dependencies-install"])
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    system "#{bin}/humann2", "--version"
  end
end
