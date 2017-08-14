class Humann2 < Formula
  desc "HUMAnN2: The HMP Unified Metabolic Analysis Network"
  homepage "https://huttenhower.sph.harvard.edu/humann"
  # doi "10.1371/journal.pcbi.1002358"
  # tag "bioinformatics"
  revision 1

  url "https://bitbucket.org/biobakery/humann2/downloads/humann2_v0.4.0.tar.gz"
  sha256 "a9f5272627de6f6bfd42f18e2d6c918982fe0a9f0e4848e7e8d8ed79c91ca77b"

  bottle do
    cellar :any_skip_relocation
    sha256 "00bd6e0a6329406bd463ecb0e9542a0f0253e5d2542c614360a495e334f399b4" => :sierra
    sha256 "ba21526ddfbca3ea39df41755eae3b787fb911c7ef38e5f4e8525c052a52af1d" => :el_capitan
    sha256 "ba21526ddfbca3ea39df41755eae3b787fb911c7ef38e5f4e8525c052a52af1d" => :yosemite
    sha256 "bf79e0c929a405582ea4551acb70bbcfe1c8f36efb97eb59d161df986101e2d2" => :x86_64_linux
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
