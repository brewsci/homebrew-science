class Gubbins < Formula
  desc "Detect recombinations in Bacteria"
  homepage "https://github.com/sanger-pathogens/gubbins"
  url "https://github.com/sanger-pathogens/gubbins/archive/v2.1.0.tar.gz"
  sha256 "27d9d26febf8858e038d91d32ec8736d61644e13069c1cc81b8315eb7b32318f"
  revision 1

  head "https://github.com/sanger-pathogens/gubbins.git"
  # tag "bioinformatics"
  # doi "10.1093/nar/gku1196"

  bottle do
    cellar :any
    sha256 "a52959de7545e02d8844a5fb6b5c42f85119c855b5301ca4549e9f8c31176c74" => :el_capitan
    sha256 "169d4b3a81f31837eb3a4c060665a076ca774ec227c30ec95e6e6743f5f2de65" => :yosemite
    sha256 "339b20bfe245bb177a58a0b951c0e2c936e29aa9c52922f380bad83939de09f8" => :mavericks
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "libtool"   => :build
  depends_on "check"     => :build
  depends_on :python3
  depends_on "homebrew/python/numpy" => ["with-python3", "without-python"]
  depends_on "homebrew/python/pillow" => ["with-python3", "without-python"]
  depends_on "zlib" unless OS.mac?
  depends_on "raxml"
  depends_on "fasttree" => ["with-double", :recommended]

  resource "biopython" do
    url "https://pypi.python.org/packages/f4/35/67d779f52870770c228f9edd0c9d1d1b9bc11afad794e220295d7b88a804/biopython-1.67.tar.gz"
    sha256 "1ab322fe4d2f79d2d999c9d8faf8b4e0b4c41c4e8b5f0a97912dfa0e3aa249e6"
  end

  resource "dendropy" do
    url "https://pypi.python.org/packages/65/3a/19556a58c560de488dffbf3c7fe7c9ed34c1a6223f0dfe971224a42aaf39/DendroPy-4.1.0.tar.gz"
    sha256 "c3d4b2780b84fb6ad64a8350855b2d762cabe45ecffbc04318f07214ee3bdfc9"
  end

  resource "nose" do
    url "https://pypi.python.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  resource "reportlab" do
    url "https://pypi.python.org/packages/b8/17/7c5342dfbc9dc856173309270006e34c3bfad59934f0faa1dcc117ac93f1/reportlab-3.3.0.tar.gz"
    sha256 "f48900b9321bcb2871a46543993bd995148d769a11a9e24495f25b4ec0bbe267"
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
    assert_match "recombinations", shell_output("#{bin}/gubbins -h 2>&1")
    assert_match "Rapid", shell_output("#{bin}/run_gubbins.py -h 2>&1")
    assert_match "tree", shell_output("#{bin}/gubbins_drawer.py -h 2>&1")
  end
end
