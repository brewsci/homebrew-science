require "formula"

class Pulseview < Formula
  homepage "http://sigrok.org/"
  url "http://sigrok.org/download/source/pulseview/pulseview-0.2.0.tar.gz"
  sha1 "92be17ef8196fb98162d27b5c0fca382d92dee31"

  head do
    url "git://sigrok.org/pulseview", :shallow => false
    depends_on "glib"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "libsigrokdecode"
  depends_on "qt"
  depends_on :python3

  def install
    ENV.delete "PYTHONPATH"
    ENV.append_path("PKG_CONFIG_PATH", lib / "pkgconfig")
    ENV.append_path "PKG_CONFIG_PATH", HOMEBREW_PREFIX / "Frameworks/Python.framework/Versions/3.4/lib/pkgconfig"

    qt = Formula["qt"].opt_prefix
    args = std_cmake_args + %W(
      -DPNG_INCLUDE_DIR=#{MacOS::X11.include}
      -DALTERNATIVE_QT_INCLUDE_DIR=#{qt}/include
    )

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pulseview", "-V"
  end
end
