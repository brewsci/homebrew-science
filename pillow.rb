class Pillow < Formula
  desc "Python Imaging Library fork"
  homepage "https://github.com/python-imaging/Pillow"
  url "https://github.com/python-pillow/Pillow/archive/4.2.0.tar.gz"
  sha256 "d6a292d8332df2b791cd7b04151036b68c318f4875b677c9f0d54b7884f052db"
  head "https://github.com/python-imaging/Pillow.git"

  bottle do
    sha256 "48f02b50a25d74e86ebded01cf8f04468ef5958258bf64b561e1d6c4b5077902" => :sierra
    sha256 "bda0bc8a0c19db21505009fc574e80b4e4a16713048c4b9a614ce8568132d75b" => :el_capitan
    sha256 "5411dc446010193d4a9105399c9d8d31e33e2d4dc2d031012d0122cee9e3bbdf" => :yosemite
    sha256 "ad2935ff738de4833a21671372e36737adeae9f73263d01d62860fa66f977f29" => :x86_64_linux
  end

  # waiting on upstream resolution of JPEG2000 issues
  # https://github.com/python-pillow/Pillow/issues/767
  # option "with-openjpeg", "Enable JPEG2000 support"

  option "without-python", "Build without python2 support"

  depends_on :python unless OS.mac?
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
    rm Dir["Tests/test_file_{fpx,mic}.py"] # require olefile
    Language::Python.each_python(build) do |python, _version|
      system "#{python} -m nose Tests/test_*"
    end
  end
end
