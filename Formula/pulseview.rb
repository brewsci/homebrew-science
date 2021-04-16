class Pulseview < Formula
  desc "Qt-based LA/scope/MSO GUI for sigrok"
  homepage "https://sigrok.org/"
  url "https://sigrok.org/download/source/pulseview/pulseview-0.4.0.tar.gz"
  sha256 "78f8291045c6f65b4827b12e83c8e68cea2d5e7268b15a51aaca9726c8100eb9"
  revision 2

  head do
    url "git://sigrok.org/pulseview", shallow: false
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "glib"
  end

  bottle :disable, "needs to be rebuilt with latest boost"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "libsigrokdecode"
  depends_on "python3"
  depends_on "qt"

  def install
    ENV.delete "PYTHONPATH"
    ENV.append_path("PKG_CONFIG_PATH", lib / "pkgconfig")
    ENV.append_path "PKG_CONFIG_PATH", HOMEBREW_PREFIX / "Frameworks/Python.framework/Versions/3.4/lib/pkgconfig"

    qt = Formula["qt"].opt_prefix
    args = std_cmake_args + %W[
      -DALTERNATIVE_QT_INCLUDE_DIR=#{qt}/include
    ]

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pulseview", "-V"
  end
end
