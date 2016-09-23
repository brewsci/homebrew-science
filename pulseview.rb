class Pulseview < Formula
  homepage "http://sigrok.org/"
  url "http://sigrok.org/download/source/pulseview/pulseview-0.2.0.tar.gz"
  sha256 "feb5d33a0a91c989bfc39fa758195755e78e87c3cf445bb135a8c8d4f86bc1dd"
  revision 2

  bottle do
    cellar :any
    sha256 "442c04e94baf9c0fcbbef377bb652e04eb704b9faef6b96be48fdd005ea08ddf" => :el_capitan
    sha256 "18f7496ed1a453457fcefb414b975227fb12f3e9687f69df8e0f37bde8c21ed0" => :yosemite
    sha256 "3b59b1204f5eaddfc2669357467b7e36b0b48ef4291526b1a13db18544617efd" => :mavericks
  end

  head do
    url "git://sigrok.org/pulseview", shallow: false
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
