class Anvio < Formula
  include Language::Python::Virtualenv
  desc "Analysis and visualization platform for ‘omics data."
  homepage "http://merenlab.org/projects/anvio/"
  url "https://files.pythonhosted.org/packages/16/45/a0378836eb14fceed15f8179da5dee6edf6e63bacaa5f9a062bca1f7ad57/anvio-3.tar.gz"
  sha256 "d5790f60e221fffcbea4bb310dd672eaeb253e8d3f280e15b3da4a779e30fc49"
  head "https://github.com/merenlab/anvio.git"

  bottle do
    sha256 "3ff362032485cb6ff1ba4c43fd26a1dba5dbcd552320840d5effaebaf19b504f" => :high_sierra
    sha256 "aaf48b8a3076b502d9aa22039cd432a184eb49c77897aecf0c9472e9d6b03177" => :sierra
    sha256 "9d7de798440c50f5a2931a46b3ad82493a42f7822222895d1561b8da003883f4" => :el_capitan
    sha256 "1f7e306feebde84d6a298cbbd9cc6c21641ec79af376af465330d2967ced61a9" => :x86_64_linux
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
  depends_on "numpy"
  depends_on "scipy"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/a1/f6/0db23aeeb40c9a7c5d226b1f70ce63822c567178eee5b623bca3e0cc3bef/bottle-0.12.11.tar.gz"
    sha256 "a1958f9725042a9809ebe33d7eadf90d1d563a8bdd6ce5f01849bff7e941a731"
  end

  resource "pysam" do
    url "https://files.pythonhosted.org/packages/be/70/16cdd6c5ef799b2db2af4fd5f9720df0f3206b0a06ed40e03692aa80ae25/pysam-0.11.1.tar.gz"
    sha256 "fbc710f82cb4334b3b88be9b7a9781547456fdcb2135755b68e041e96fc28de1"
  end

  resource "ete3" do
    url "https://files.pythonhosted.org/packages/f0/c5/e1bb20c02f0e7cd924eab783901b4e2acf8fda79c0f7c7303b740bf7b98e/ete3-3.0.0b35.tar.gz"
    sha256 "f9f055f5865d00afb8882e0ea128dea2df6fba2e31e3486392a282a2aa90dc18"
  end

  resource "scikit-learn" do
    url "https://files.pythonhosted.org/packages/f1/dc/5fb2834511eef6f86e17b6ec41c0c7a60733f79633827e75aaa55029a9fa/scikit-learn-0.18.1.tar.gz"
    sha256 "1eddfc27bb37597a5d514de1299981758e660e0af56981c0bfdf462c9568a60c"
  end

  resource "Django" do
    url "https://files.pythonhosted.org/packages/3b/14/6c1e7508b1342afde8e80f50a55d6b305c0755c702f741db6094924f7499/Django-1.10.4.tar.gz"
    sha256 "fff7f062e510d812badde7cfc57745b7779edb4d209b2bc5ea8d954c22305c2b"
  end

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/b7/67/7e2a817f9e9c773ee3995c1e15204f5d01c8da71882016cac10342ef031b/Cython-0.25.2.tar.gz"
    sha256 "f141d1f9c27a07b5a93f7dc5339472067e2d7140d1c5a9e20112a5665ca60306"
  end

  resource "h5py" do
    url "https://files.pythonhosted.org/packages/22/82/64dada5382a60471f85f16eb7d01cc1a9620aea855cd665609adf6fdbb0d/h5py-2.6.0.tar.gz"
    sha256 "b2afc35430d5e4c3435c996e4f4ea2aba1ea5610e2d2f46c9cae9f785e33c435"
  end

  resource "cherrypy" do
    url "https://files.pythonhosted.org/packages/56/aa/91005730bdc5c0da8291a2f411aacbc5c3729166c382e2193e33f28044a3/CherryPy-8.9.1.tar.gz"
    sha256 "dfad2f34e929836d016ae79f9e27aff250a8a71df200bf87c3e9b23541e091c5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5b/0b/34be574b1ec997247796e5d516f3a6b6509c4e064f2885a96ed885ce7579/requests-2.12.4.tar.gz"
    sha256 "ed98431a0631e309bb4b63c81d561c1654822cb103de1ac7b47e45c26be7ae34"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/78/0a/aa90434c6337dd50d182a81fe4ae4822c953e166a163d1bf5f06abb1ac0b/psutil-5.1.3.tar.gz"
    sha256 "959bd58bdc8152b0a143cb3bd822d4a1b8f7230617b0e3eb2ff6e63812120f2b"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/25/a4/12a584c0c59c9fed529f8b3c47ca8217c0cf8bcc5e1089d3256410cfbdbc/mistune-0.7.4.tar.gz"
    sha256 "8517af9f5cd1857bb83f9a23da75aa516d7538c32a2c5d5c56f3789a9e4cd22f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/a4/09/c47e57fc9c7062b4e83b075d418800d322caa87ec0ac21e6308bd3a2d519/pytz-2017.2.zip"
    sha256 "f5c056e8f62d45ba8215e5cb8f50dfccb198b4b9fbea8500674f3443e4689589"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/34/fd/0cb98ea4df08c82af3de93da5b9f79d573c6ecc05098905f9cd6b0bece51/pandas-0.20.1.tar.gz"
    sha256 "42707365577ef69f7c9c168ddcf045df2957595a9ee71bc13c7997eecb96b190"
  end

  def install
    ENV["HTSLIB_CONFIGURE_OPTIONS"] = "--disable-libcurl"
    ENV["HAVE_LIBCURL"] = "False"
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_lib/"python#{version}/site-packages"
    ENV.prepend_path "PYTHONPATH", Formula["scipy"].opt_lib/"python#{version}/site-packages"

    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/anvi-profile", "--version"
  end
end
