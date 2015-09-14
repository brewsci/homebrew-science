class Gubbins < Formula
  desc "Detect recombinations in Bacteria"
  homepage "https://github.com/sanger-pathogens/gubbins"
  url "https://github.com/sanger-pathogens/gubbins/archive/v1.4.1.tar.gz"
  sha256 "dcc98f70fb91357d4cb2cd0d8d37a03c77b3d2287a61e40ea21e0aee85d4d8ca"
  head "https://github.com/sanger-pathogens/gubbins.git"
  revision 1

  bottle do
    cellar :any
    sha256 "107eee089eb4958a2a09d7a4bcce226021c6b6278cebd37181ac60b129f71564" => :yosemite
    sha256 "7a757509f482a02c51d4273f11cd38f360ac4e585aff92a31480ce55bd8e7c26" => :mavericks
  end

  # tag "bioinformatics"
  # doi "10.1093/nar/gku1196"

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "libtool"   => :build
  depends_on "check"     => :build
  depends_on :python3
  depends_on "homebrew/python/numpy" => ["with-python3"]
  depends_on "homebrew/python/pillow" => ["with-python3"]
  depends_on "zlib"  unless OS.mac?
  depends_on "raxml"
  depends_on "fasttree" => ["with-double", :recommended]
  depends_on "fastml"   => :recommended

  resource "biopython" do
    url "https://pypi.python.org/packages/source/b/biopython/biopython-1.65.tar.gz"
    sha256 "6d591523ba4d07a505978f6e1d7fac57e335d6d62fb5b0bcb8c40bdde5c8998e"
  end

  resource "dendropy" do
    url "https://pypi.python.org/packages/source/D/DendroPy/DendroPy-4.0.2.tar.gz"
    sha256 "b118c9e3e9408f2727e374032f6743a630e8a9239d84f898ed08cd5e68c5238d"
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
