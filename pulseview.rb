class Pulseview < Formula
  homepage "http://sigrok.org/"
  url "http://sigrok.org/download/source/pulseview/pulseview-0.3.0.tar.gz"
  sha256 "5ffe2cb7a602fcdc60933d400c77bcd66e6ce529bc4f6e97d6a5e5a86f2f530e"

  bottle do
    cellar :any
    sha256 "63b2d68ec757998244dcd8aba72c4862877b9392048888ffa10c71c6700b82d6" => :sierra
    sha256 "2dfacfba2ea9e5767e0600ee21ed8e1ce5220532ee403b08421d1896cb2acc7f" => :el_capitan
    sha256 "22ad2013d06095a0294caa63189ace8a26dbfabcb21646ba4b54099073ff363e" => :yosemite
  end

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
  depends_on "qt5"
  depends_on :python3

  def install
    ENV.delete "PYTHONPATH"
    ENV.append_path("PKG_CONFIG_PATH", lib / "pkgconfig")
    ENV.append_path "PKG_CONFIG_PATH", HOMEBREW_PREFIX / "Frameworks/Python.framework/Versions/3.4/lib/pkgconfig"

    qt = Formula["qt5"].opt_prefix
    args = std_cmake_args + %W[
      -DPNG_INCLUDE_DIR=#{MacOS::X11.include}
      -DALTERNATIVE_QT_INCLUDE_DIR=#{qt}/include
    ]

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pulseview", "-V"
  end
end
