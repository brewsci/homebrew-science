class Anvio < Formula
  include Language::Python::Virtualenv
  desc "Analysis and visualization platform for ‘omics data."
  homepage "http://merenlab.org/projects/anvio/"
  url "https://files.pythonhosted.org/packages/1a/f4/e75b895b3348ec7d0d21e220735d0f9dd0ea2e67ef9a6ebb9c92bd1d7593/anvio-2.4.0.tar.gz"
  sha256 "0f2b3dfe92dc94f097bc9690f4d3e5d9b9320621404fc9cf7c752827e9d09e93"
  head "https://github.com/merenlab/anvio.git"

  bottle do
    sha256 "dc58f4fef58489b6c2e86fdfb33ac694dcfd1c8c28e0f6331c72fb823c83b9cb" => :sierra
    sha256 "9d33d7084820fcaa1025c925ddb5f3cde28228cec4b79d55ac03be107cdfec40" => :el_capitan
    sha256 "a9e06b5f9380d59164e593349a88f7db897e26e8486fd4853a7556287436b01f" => :yosemite
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
