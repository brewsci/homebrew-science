class Gubbins < Formula
  desc "Detect recombinations in Bacteria"
  homepage "https://github.com/sanger-pathogens/gubbins"
  url "https://github.com/sanger-pathogens/gubbins/archive/v2.2.2.tar.gz"
  sha256 "26d9931688835eb9c0d029ffdc8512953be3ec53bed4fd64629b98ac32b040c9"
  head "https://github.com/sanger-pathogens/gubbins.git"
  # tag "bioinformatics"
  # doi "10.1093/nar/gku1196"

  bottle do
    cellar :any
    sha256 "1759d93437efa27dff286bc213538532dbe6f99bc51f01cfd88ad56c02376557" => :sierra
    sha256 "a092891886dcdd4dce1ce100be397a0a4c06f5ac70db1fc8e60d43a3cbca67c5" => :el_capitan
    sha256 "3e9e87949ec9ffb77c493885ac8b0d6b4ec12926cc9bea06d224af89a5ea239d" => :yosemite
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "libtool"   => :build
  depends_on "check"     => :build
  depends_on :python3
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "numpy"
  depends_on "raxml"
  depends_on "webp"
  depends_on "fasttree" => :recommended
  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "zlib"
  end

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/72/6c/e1e13b9df73f9c2539b67d12bc22be6b19779230cadbed04c24f3f3e5ef4/biopython-1.68.tar.gz"
    sha256 "d1dc09d1ddc8e90833f507cf09f80fa9ee1537d319058d1c44fe9c09be3d0c1f"
  end

  resource "DendroPy" do
    url "https://files.pythonhosted.org/packages/65/3a/19556a58c560de488dffbf3c7fe7c9ed34c1a6223f0dfe971224a42aaf39/DendroPy-4.1.0.tar.gz"
    sha256 "c3d4b2780b84fb6ad64a8350855b2d762cabe45ecffbc04318f07214ee3bdfc9"
  end

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/55/aa/f7f983fb72710a9daa4b3374b7c160091d3f94f5c09221f9336ade9027f3/Pillow-4.2.1.tar.gz"
    sha256 "c724f65870e545316f9e82e4c6d608ab5aa9dd82d5185e5b2e72119378740073"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/b8/17/7c5342dfbc9dc856173309270006e34c3bfad59934f0faa1dcc117ac93f1/reportlab-3.3.0.tar.gz"
    sha256 "f48900b9321bcb2871a46543993bd995148d769a11a9e24495f25b4ec0bbe267"
  end

  def install
    ENV["LANG"] = "en_US.UTF-8"
    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", "#{HOMEBREW_PREFIX}/lib/python#{version}/site-packages"

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS::CLT.installed? ? "" : MacOS.sdk_path
        s.gsub! "openjpeg.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None", "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None", "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end

      begin
        # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
        deleted = ENV.delete "SDKROOT"
        ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers" unless MacOS::CLT.installed?
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      ensure
        ENV["SDKROOT"] = deleted
      end
    end

    %w[nose biopython DendroPy reportlab].each do |r|
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
