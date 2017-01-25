class Pillow < Formula
  desc "Python Imaging Library fork"
  homepage "https://github.com/python-imaging/Pillow"
  url "https://github.com/python-pillow/Pillow/archive/3.4.2.tar.gz"
  sha256 "0ee762ab924e004b7e69643b44e82cf65e0fa1f16862e11bd821950dbbc5f3d3"
  head "https://github.com/python-imaging/Pillow.git"

  bottle do
    cellar :any
    sha256 "e0af236e5bc5c494056e73b3f97370f39d533ed00819778636f1f331c9eb1e59" => :sierra
    sha256 "48806ad12659065b05a0f185adf6278f7a958f500d63aedb470b6bfdf0ed5ae6" => :el_capitan
    sha256 "08ff7bbc836dbdf006cbf5674cb71c1559c6df1e9cdd1c927090b690dfa31f7f" => :yosemite
  end

  # waiting on upstream resolution of JPEG2000 issues
  # https://github.com/python-pillow/Pillow/issues/767
  # option "with-openjpeg", "Enable JPEG2000 support"

  option "without-python", "Build without python2 support"

  depends_on :python3 => :optional
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libtiff" => :recommended
  depends_on "little-cms2" => :recommended
  depends_on "webp" => :recommended
  depends_on "openjpeg" => :optional

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  def install
    inreplace "setup.py" do |s|
      sdkprefix = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
      s.gsub! "LCMS_ROOT = None", "LCMS_ROOT = ('#{Formula["little-cms2"].opt_prefix}/lib', '#{Formula["little-cms2"].opt_prefix}/include')" if build.with? "little-cms2"
      s.gsub! "JPEG_ROOT = None", "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
      s.gsub! "JPEG2K_ROOT = None", "JPEG2K_ROOT = ('#{Formula["openjpeg"].opt_prefix}/lib', '#{Formula["openjpeg"].opt_prefix}/include')" if build.with? "openjpeg"
      s.gsub! "TIFF_ROOT = None", "TIFF_ROOT = ('#{Formula["libtiff"].opt_prefix}/lib', '#{Formula["libtiff"].opt_prefix}/include')" if build.with? "libtiff"
      s.gsub! "FREETYPE_ROOT = None", "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
    end

    # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
    ENV.delete "SDKROOT"
    ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers" unless MacOS::CLT.installed?

    Language::Python.each_python(build) do |python, version|
      resource("nose").stage do
        system python, *Language::Python.setup_install_args(libexec)
        nose_path = libexec/"lib/python#{version}/site-packages"
        dest_path = lib/"python#{version}/site-packages"
        mkdir_p dest_path
        (dest_path/"homebrew-pillow-nose.pth").atomic_write(nose_path.to_s + "\n")
        ENV.append_path "PYTHONPATH", nose_path
      end
      system python, "setup.py", "build_ext"
      system python, *Language::Python.setup_install_args(prefix)
    end

    prefix.install "Tests"
  end

  test do
    cp_r prefix/"Tests", testpath
    Language::Python.each_python(build) do |python, _version|
      system "#{python} -m nose Tests/test_*"
    end
  end
end
