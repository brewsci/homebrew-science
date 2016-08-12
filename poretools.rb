class Poretools < Formula
  desc "Tools for working with nanopore sequencing data"
  homepage "http://poretools.readthedocs.org/"
  url "https://github.com/arq5x/poretools/archive/v0.5.1.tar.gz"
  sha256 "5f547b014c6208ca14a2f95cc10eecc34f9a69edf44e693eade31f083da36b18"
  head "https://github.com/arq5x/poretools.git"
  revision 5

  bottle do
    sha256 "13d37f2ca149f6b6460052a431d1913ac91efae1d95a02f51b7fcf7b8538cecf" => :el_capitan
    sha256 "04d5158bf0764d51d671ae3cd2c62ba4c6299f7c47ad645ab8c9b41c8351b344" => :mavericks
  end

  depends_on "pkg-config" => :build  # for h5py
  depends_on "freetype"  # for matplotlib
  depends_on "hdf5"
  depends_on :fortran  # for scipy
  depends_on :python if MacOS.version <= :snow_leopard

  cxxstdlib_check :skip

  resource "Cycler" do
    url "https://pypi.python.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "Cython" do
    url "https://pypi.python.org/packages/b1/51/bd5ef7dff3ae02a2c6047aa18d3d06df2fb8a40b00e938e7ea2f75544cac/Cython-0.24.tar.gz"
    sha256 "6de44d8c482128efc12334641347a9c3e5098d807dd3c69e867fa8f84ec2a3f1"
  end

  resource "h5py" do
    url "https://pypi.python.org/packages/22/82/64dada5382a60471f85f16eb7d01cc1a9620aea855cd665609adf6fdbb0d/h5py-2.6.0.tar.gz"
    sha256 "b2afc35430d5e4c3435c996e4f4ea2aba1ea5610e2d2f46c9cae9f785e33c435"
  end

  resource "matplotlib" do
    url "https://pypi.python.org/packages/8f/f4/c0c7e81f64d5f4d36e52e393af687f28882c53dcd924419d684dc9859f40/matplotlib-1.5.1.tar.gz"
    sha256 "3ab8d968eac602145642d0db63dd8d67c85e9a5444ce0e2ecb2a8fedc7224d40"
  end

  resource "numpy" do
    url "https://pypi.python.org/packages/1a/5c/57c6920bf4a1b1c11645b625e5483d778cedb3823ba21a017112730f0a12/numpy-1.11.0.tar.gz"
    sha256 "a1d1268d200816bfb9727a7a27b78d8e37ecec2e4d5ebd33eb64e2789e0db43e"
  end

  resource "pandas" do
    url "https://pypi.python.org/packages/11/09/e66eb844daba8680ddff26335d5b4fead77f60f957678243549a8dd4830d/pandas-0.18.1.tar.gz"
    sha256 "d2e483692c7915916dffd1b83256ea9761b4224c8d45646ceddf48b977ee77b2"
  end

  resource "pyparsing" do
    url "https://pypi.python.org/packages/41/45/1f1b5e0f58d9f5c4e60ca062704c033700d866958f5dc02531996239f5da/pyparsing-2.1.2.tar.gz"
    sha256 "57754e38d618fb47fdd17d1ce7a2dc8cbb7986ab07363ce8dcfc57270e6c9a2a"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/f4/7d/7c0c85e9c64a75dde11bc9d3e1adc4e09a42ce7cdb873baffa1598118709/pytz-2016.4.tar.bz2"
    sha256 "ee7c751544e35a7b7fb5e3fb25a49dade37d51e70a93e5107f10575d7102c311"
  end

  resource "scipy" do
    url "https://pypi.python.org/packages/16/87/fdd4d069b1e784d4598605c20d8a7c535883b298aef960dc286b395359d7/scipy-0.17.0.tar.gz"
    sha256 "f600b755fb69437d0f70361f9e560ab4d304b1b66987ed5a28bdd9dd7793e089"
  end

  resource "seaborn" do
    url "https://pypi.python.org/packages/05/70/727aea83084506060c5fe2b35b6a640ddf66e926a4b54d752542e031b3c3/seaborn-0.7.0.tar.gz"
    sha256 "15a8b2747becfdb86cfa60b5fcfa9bb934e42ef0ced660e0d57e8aea741f7145"
  end

  resource "six" do
    url "https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "test" do
    url "ftp://ftp.sra.ebi.ac.uk/vol1/ERA412/ERA412821/oxfordnanopore_native/MVA_filtered.tar.gz"
    sha256 "76b00286acba1f65c76a3869bc60e099190ce48d0a5822606ce222e80529e523"
  end

  def install
    ENV.delete("SDKROOT")

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python2.7/site-packages"
    ENV.prepend_create_path "PATH", libexec/"vendor/bin"
    ENV.prepend_create_path "PATH", buildpath/"cython/bin"
    ENV["HDF5_DIR"] = Formula["hdf5"].opt_prefix

    res = resources.map(&:name).to_set - ["numpy", "Cython", "test"]
    res = ["numpy"] + res.to_a

    resource("Cython").stage do
      system "python", *Language::Python.setup_install_args(buildpath/"cython")
    end

    res.each do |rp|
      resource(rp).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # install poretools
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    resource("test").stage { (pkgshare/"test_data").install Dir["*"] }
  end

  test do
    result = <<-EOS.undent
    total reads	297
    total base pairs	260131
    mean	875.86
    median	795
    min	325
    max	3602
    N25	965
    N50	830
    N75	741
    EOS

    assert_equal result, shell_output("#{bin}/poretools stats #{pkgshare}/test_data/")
  end
end
