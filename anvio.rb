class Anvio < Formula
  include Language::Python::Virtualenv
  desc "Analysis and visualization platform for ‘omics data."
  homepage "http://merenlab.org/projects/anvio/"
  url "https://pypi.python.org/packages/83/14/763c5ea56342005ddf24a03973ca32e5636a3cebaaacebc75116e93a9ad1/anvio-2.1.0.tar.gz"
  sha256 "4b21457130275bbede9ae21651fad1f56e38935f2f4bf1d8046350fe6e4f9a62"
  head "https://github.com/merenlab/anvio.git"
  bottle do
    cellar :any
    sha256 "e2958a9fcd66a670e85ca844fa2e3ec6828c89d669a5dc399fc75c573b79e158" => :sierra
    sha256 "251a3071888df4a3e223db0405a1d1a745451f8c22ff75e96b7b57a12972182f" => :el_capitan
    sha256 "08b0671d60ff1670a42ebadf9f47eede218eaf9a4fcb619cbcf1c2c3c17dd1ff" => :yosemite
  end

  # doi "10.7717/peerj.1319"
  # tag "bioinformatics"

  depends_on :python if MacOS.version <= :snow_leopard
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
  depends_on "scipy"
  depends_on "numpy"

  resource "bottle" do
    url "https://pypi.python.org/packages/a1/f6/0db23aeeb40c9a7c5d226b1f70ce63822c567178eee5b623bca3e0cc3bef/bottle-0.12.11.tar.gz"
    sha256 "a1958f9725042a9809ebe33d7eadf90d1d563a8bdd6ce5f01849bff7e941a731"
  end

  resource "pysam" do
    url "https://pypi.python.org/packages/40/15/20b22dc3d017ec123e533d062b982b111b0214168905de3221b5caf5f766/pysam-0.9.1.tar.gz"
    sha256 "2969e080d435c62c4dd497294dfdb36eb92cd31f551c1030c0159481a5ef101e"
  end

  resource "ete2" do
    url "https://pypi.python.org/packages/60/50/0287c4a6cd11bd62fe3bcaa859bbbc18b48bb71b92dc027d439451fe10c1/ete2-2.3.10.tar.gz"
    sha256 "fc48a46976128c1d6610338cc8426974773796150dd99f3efd660facf32de2a1"
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
    url "https://pypi.python.org/packages/c8/c5/f8b8c7f17b5b55a0506a1e3b2e6fce7a727905bdfe05b3ef0c797c5235ff/CherryPy-8.1.3.tar.gz"
    sha256 "e75d94393ef24a47e70fb7539c07abac11be7cb76780c3151f94f6a9f5b2c3da"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/5b/0b/34be574b1ec997247796e5d516f3a6b6509c4e064f2885a96ed885ce7579/requests-2.12.4.tar.gz"
    sha256 "ed98431a0631e309bb4b63c81d561c1654822cb103de1ac7b47e45c26be7ae34"
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
