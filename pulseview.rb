class Pulseview < Formula
  desc "Qt-based LA/scope/MSO GUI for sigrok"
  homepage "https://sigrok.org/"
  url "https://sigrok.org/download/source/pulseview/pulseview-0.4.0.tar.gz"
  sha256 "78f8291045c6f65b4827b12e83c8e68cea2d5e7268b15a51aaca9726c8100eb9"

  bottle do
    cellar :any
    sha256 "6626478407fc744baad10a7babdec4995a1e84ec11b1964ebce34881214e9866" => :sierra
    sha256 "7d1c89c789781b902a85e3ab6eec7807d9b8316feafed05c3b7b865024699800" => :el_capitan
    sha256 "efe7608bd349f30889384d32c33e4632739c7a9c5cc0c5d3ad7c13bd5657d79f" => :yosemite
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
  depends_on "qt"
  depends_on :python3

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
