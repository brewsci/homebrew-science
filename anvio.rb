class Anvio < Formula
  include Language::Python::Virtualenv
  desc "Analysis and visualization platform for ‘omics data."
  homepage "http://merenlab.org/projects/anvio/"
  url "https://pypi.python.org/packages/2f/2a/d89cabfc28119f06d992b7b2101f5c77a75f447f7a74eac14a80ec4e8fd8/anvio-2.2.2.tar.gz"
  sha256 "d794f168df8b069b0b42067d37cb1802a828f6e01333ce887a481a3d8b373cef"
  head "https://github.com/merenlab/anvio.git"

  bottle do
    sha256 "d95e3bf37a6f8342d3c4d23a33da3d2f785d15c18b39c35742c89f9a20fcf0de" => :sierra
    sha256 "e4e3a14611d0bf945f0ef7202643440cbe56fa5e22ad5e4858ce0df3d883d614" => :el_capitan
    sha256 "f29e42b617ac81497e0059cabbb538f03ea3cedd274c1b4b061ce6225e2e8e28" => :yosemite
  end

  # doi "10.7717/peerj.1319"
  # tag "bioinformatics"

  depends_on :python3
  depends_on :fortran
  depends_on "prodigal"
  depends_on "hmmer"
  depends_on "sqlite"
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "diamond"
  depends_on "mcl"
  depends_on "muscle"
  depends_on "blast"
  depends_on "numpy" => "with-python3"
  depends_on "scipy" => "with-python3"

  resource "bottle" do
    url "https://pypi.python.org/packages/a1/f6/0db23aeeb40c9a7c5d226b1f70ce63822c567178eee5b623bca3e0cc3bef/bottle-0.12.11.tar.gz"
    sha256 "a1958f9725042a9809ebe33d7eadf90d1d563a8bdd6ce5f01849bff7e941a731"
  end

  resource "pysam" do
    url "https://pypi.python.org/packages/de/03/02934438b204565bc5231f38a11da840a3c3e4b2beac8c8770d675770668/pysam-0.9.1.4.tar.gz"
    sha256 "56ee7f8d07fa9d78b5c00dfbf335c95edbfed1518a2c14f8f108e58599922dc4"
  end

  resource "ete3" do
    url "https://pypi.python.org/packages/f0/c5/e1bb20c02f0e7cd924eab783901b4e2acf8fda79c0f7c7303b740bf7b98e/ete3-3.0.0b35.tar.gz"
    sha256 "f9f055f5865d00afb8882e0ea128dea2df6fba2e31e3486392a282a2aa90dc18"
  end

  resource "scikit-learn" do
    url "https://pypi.python.org/packages/f1/dc/5fb2834511eef6f86e17b6ec41c0c7a60733f79633827e75aaa55029a9fa/scikit-learn-0.18.1.tar.gz"
    sha256 "1eddfc27bb37597a5d514de1299981758e660e0af56981c0bfdf462c9568a60c"
  end

  resource "Django" do
    url "https://pypi.python.org/packages/3b/14/6c1e7508b1342afde8e80f50a55d6b305c0755c702f741db6094924f7499/Django-1.10.4.tar.gz"
    sha256 "fff7f062e510d812badde7cfc57745b7779edb4d209b2bc5ea8d954c22305c2b"
  end

  resource "Cython" do
    url "https://pypi.python.org/packages/b7/67/7e2a817f9e9c773ee3995c1e15204f5d01c8da71882016cac10342ef031b/Cython-0.25.2.tar.gz"
    sha256 "f141d1f9c27a07b5a93f7dc5339472067e2d7140d1c5a9e20112a5665ca60306"
  end

  resource "h5py" do
    url "https://pypi.python.org/packages/22/82/64dada5382a60471f85f16eb7d01cc1a9620aea855cd665609adf6fdbb0d/h5py-2.6.0.tar.gz"
    sha256 "b2afc35430d5e4c3435c996e4f4ea2aba1ea5610e2d2f46c9cae9f785e33c435"
  end

  resource "cherrypy" do
    url "https://pypi.python.org/packages/56/aa/91005730bdc5c0da8291a2f411aacbc5c3729166c382e2193e33f28044a3/CherryPy-8.9.1.tar.gz"
    sha256 "dfad2f34e929836d016ae79f9e27aff250a8a71df200bf87c3e9b23541e091c5"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/5b/0b/34be574b1ec997247796e5d516f3a6b6509c4e064f2885a96ed885ce7579/requests-2.12.4.tar.gz"
    sha256 "ed98431a0631e309bb4b63c81d561c1654822cb103de1ac7b47e45c26be7ae34"
  end

  resource "psutil" do
    url "https://pypi.python.org/packages/78/0a/aa90434c6337dd50d182a81fe4ae4822c953e166a163d1bf5f06abb1ac0b/psutil-5.1.3.tar.gz"
    sha256 "959bd58bdc8152b0a143cb3bd822d4a1b8f7230617b0e3eb2ff6e63812120f2b"
  end

  def install
    ENV["HTSLIB_CONFIGURE_OPTIONS"] = "--disable-libcurl"
    ENV["HAVE_LIBCURL"] = "False"

    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/anvi-profile", "--version"
  end
end
