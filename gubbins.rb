class Gubbins < Formula
  desc "Detect recombinations in Bacteria"
  homepage "https://github.com/sanger-pathogens/gubbins"
  url "https://github.com/sanger-pathogens/gubbins/archive/v1.4.7.tar.gz"
  sha256 "6fdc2798a271114f8126d16e09bf6a1da2a616c7decdaeb436633629859fbfce"
  head "https://github.com/sanger-pathogens/gubbins.git"
  # tag "bioinformatics"
  # doi "10.1093/nar/gku1196"

  bottle do
    cellar :any
    sha256 "5a2152aed0b0cd26100f081086ec8c291fada21ebbf48eabc9936539ce05b977" => :el_capitan
    sha256 "20f7e8bf997f535b4f9f6a65e5ac239e05247efd19ce125af3b4744e431adbd5" => :yosemite
    sha256 "bb2fe1cd64a74d87de3650450b027f9e58b61f04a773d1e4ad368e3e946f458e" => :mavericks
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "libtool"   => :build
  depends_on "check"     => :build
  depends_on :python3
  depends_on "homebrew/python/numpy" => ["with-python3"]
  depends_on "homebrew/python/pillow" => ["with-python3"]
  depends_on "zlib" unless OS.mac?
  depends_on "raxml"
  depends_on "fasttree" => ["with-double", :recommended]
  depends_on "fastml"   => :recommended

  resource "biopython" do
    url "https://pypi.python.org/packages/source/b/biopython/biopython-1.66.tar.gz"
    sha256 "171ad726f50528b514f9777e6ea54138f6e35792c5b128c4ab91ce918a48bbbd"
  end

  resource "dendropy" do
    url "https://pypi.python.org/packages/source/D/DendroPy/DendroPy-4.0.3.tar.gz"
    sha256 "a2c074eb91e2866120521c076587983900c5b312879832c3559effb730bd4465"
  end

  resource "nose" do
    url "https://pypi.python.org/packages/source/n/nose/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  resource "reportlab" do
    url "https://pypi.python.org/packages/source/r/reportlab/reportlab-3.2.0.tar.gz"
    sha256 "72e687662bd854776407b9108483561831b45546d935df8b0477708199086293"
  end

  def install
    ENV["LANG"] = "en_US.UTF-8"
    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", "#{HOMEBREW_PREFIX}/lib/python#{version}/site-packages"

    %w[nose biopython dendropy reportlab].each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    if OS.mac?
      inreplace "src/Makefile.am", "-lrt", ""
      inreplace "configure.ac", "PKG_CHECK_MODULES([zlib], [zlib])", "AC_CHECK_LIB(zlib, zlib)"
    end

    inreplace "Makefile.am", "SUBDIRS=src release python", "SUBDIRS=src release"

    system "autoreconf", "-i"
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"

    cd "python" do
      system "python3", *Language::Python.setup_install_args(libexec)
    end
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "recombinations", shell_output("gubbins -h 2>&1", 0)
    assert_match "Rapid", shell_output("run_gubbins.py -h 2>&1", 0)
    assert_match "tree", shell_output("gubbins_drawer.py -h 2>&1", 0)
  end
end
