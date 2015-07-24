class Poretools < Formula
  desc "Tools for working with nanopore sequencing data"
  homepage "http://poretools.readthedocs.org/"
  url "https://github.com/arq5x/poretools/archive/v0.5.1.tar.gz"
  sha256 "7cd55a8f30290992dcf8d7792401e7f21efadfde02b3f4604d6680d2f8300479"
  head "https://github.com/arq5x/poretools.git"

  bottle do
    cellar :any
    sha256 "45451e7b15182743417c26ca8a185b3e190bf6737f88bd073b05ecfa2f223ec3" => :yosemite
    sha256 "0d13e263e393ef97ed3bc06aeaa73c2c27097ae9c75d517a2acc288ecbaf91ad" => :mavericks
    sha256 "b1ce68410088646e5d23177d6706851c9d1c288dd75c94f8e9b74e680fc3b1e5" => :mountain_lion
  end

  depends_on "hdf5"
  depends_on "r"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"

  resource "rpy2" do
    url "https://pypi.python.org/packages/source/r/rpy2/rpy2-2.5.6.tar.gz"
    sha256 "d0d584c435b5ed376925a95a4525dbe87de7fa9260117e9f208029e0c919ad06"
  end

  resource "Cython" do
    url "http://cython.org/release/Cython-0.22.tar.gz"
    sha256 "14307e7a69af9a0d0e0024d446af7e51cc0e3e4d0dfb10d36ba837e5e5844015"
  end

  resource "h5py" do
    url "https://pypi.python.org/packages/source/h/h5py/h5py-2.5.0.tar.gz#md5=6e4301b5ad5da0d51b0a1e5ac19e3b74"
    sha256 "9833df8a679e108b561670b245bcf9f3a827b10ccb3a5fa1341523852cfac2f6"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz#md5=476881ef4012262dfc8adc645ee786c4"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "watchdog" do
    url "https://pypi.python.org/packages/source/w/watchdog/watchdog-0.8.3.tar.gz"
    sha256 "7e65882adb7746039b6f3876ee174952f8eaaa34491ba34333ddf1fe35de4162"
  end

  resource "pathtools" do
    url "https://pypi.python.org/packages/source/p/pathtools/pathtools-0.1.2.tar.gz"
    sha256 "7c35c5421a39bb82e58018febd90e3b6e5db34c5443aaaf742b3f33d4655f1c0"
  end

  resource "argh" do
    url "https://pypi.python.org/packages/source/a/argh/argh-0.26.1.tar.gz"
    sha256 "06a7442cb9130fb8806fe336000fcf20edf1f2f8ad205e7b62cec118505510db"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz#md5=f50e08ef0fe55178479d3a618efe21db"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "singledispatch" do
    url "https://pypi.python.org/packages/source/s/singledispatch/singledispatch-3.4.0.3.tar.gz#md5=af2fc6a3d6cc5a02d0bf54d909785fcb"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "codetools" do
    url "http://cran.r-project.org/src/contrib/codetools_0.2-11.tar.gz"
    sha256 "b02e8b17ea9173b73c20e84fbd36c420d5a79bb56a6b9d0d45c22a7d540f54d5"
  end

  resource "MASS" do
    url "http://cran.r-project.org/src/contrib/MASS_7.3-40.tar.gz"
    sha256 "9e0c937162cb485511ce77c8519a21558370c20f3c6dc34493b895cb355cb516"
  end

  resource "ggplot2" do
    url "http://cran.r-project.org/src/contrib/ggplot2_1.0.1.tar.gz"
    sha256 "40248e6b31307787e44e45d806e7a33095844a9bbe864cc7583dd311b19c241d"
  end

  resource "test" do
    url "ftp://ftp.sra.ebi.ac.uk/vol1/ERA412/ERA412821/oxfordnanopore_native/MVA_filtered.tar.gz"
    sha256 "76b00286acba1f65c76a3869bc60e099190ce48d0a5822606ce222e80529e523"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "R_LIBS", libexec/"vendor/R/library"
    ENV.prepend_create_path "PATH", libexec/"vendor/bin"

    respy = %w[rpy2 Cython h5py six watchdog pathtools argh PyYAML singledispatch]
    resr = %w[codetools MASS ggplot2]

    # install python dependencies
    respy.each do |rp|
      resource(rp).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # install devtools
    system "R", "-q", "-e", "install.packages('devtools', lib='" + libexec/"vendor/R/library" + "', repos='http://cran.r-project.org')"

    # install r dependencies
    ENV.prepend "LDFLAGS", "-L" + Formula["openssl"].lib
    ENV.prepend "CPPFLAGS", "-I" + Formula["openssl"].include
    resr.each do |rr|
      resource(rr).stage do
        system "R", "-q", "-e", "library(devtools); install(pkg='.', lib='" + libexec/"vendor/R/library" + "')"
      end
    end

    # install poretools
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    libexec.install Dir[libexec/"bin/*"]
    libexec.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    (bin/"poretools").write_env_script(libexec+"bin/poretools", :R_LIBS => ENV["R_LIBS"], :PYTHONPATH => ENV["PYTHONPATH"])

    resource("test").stage { (share/"test_data").install Dir["*"] }
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

    assert_equal result, shell_output("#{bin}/poretools stats #{share}/test_data/")
  end
end
