require "formula"

class Pulseview < Formula
  url "http://sigrok.org/download/source/pulseview/pulseview-0.2.0.tar.gz"
  homepage "http://sigrok.org/"
  head "git://sigrok.org/pulseview", :shallow => false
  sha1 "92be17ef8196fb98162d27b5c0fca382d92dee31"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "libsigrokdecode"
  depends_on "qt"
  depends_on :python3

  if build.head?
    depends_on "glib"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

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
