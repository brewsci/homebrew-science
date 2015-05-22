class XmiMsim < Formula
  homepage "https://github.com/tschoonj/xmimsim"
  url "http://lvserver.ugent.be/xmi-msim/xmimsim-5.0.tar.gz"
  mirror "https://xmi-msim.s3.amazonaws.com/xmimsim-5.0.tar.gz"
  sha1 "cb8f83fe594f8808079d64dfd7e592c710891efc"
  revision 1

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    revision 1
    sha256 "49fc58ca90739c5947aca3120914c5bfce6b7c76a5cbeb6d8fa84e1f0e6df218" => :yosemite
    sha256 "d5d7305dcbc4245a1ca697c264cfa71b325edc7d5fa64146aafb719164b4fdb1" => :mavericks
    sha256 "91bbeef271ed7cacd0e13eb0c37f40d57173bfab4275cab41ffb1c3437d33d81" => :mountain_lion
  end

  depends_on :fortran
  depends_on "gsl"
  depends_on "fgsl"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "glib"
  depends_on "hdf5"
  depends_on "pkg-config" => :build
  depends_on "xraylib" => "with-fortran"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  patch do
    url "https://github.com/tschoonj/xmimsim/commit/682ff5b413fc326c1cc8e9931d34bce3e920c798.diff"
    sha1 "8881ee02307b85a0032373191de1a07104a37d8c"
  end

  def install
    ENV.deparallelize  # fortran modules don't like parallel builds

    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gui",
                          "--disable-updater",
                          "--disable-mac-integration",
                          "--disable-libnotify",
                          "--enable-opencl"
    system "make"

    # this next step can take a long time...
    system "./bin/xmimsim-db"
    system "make", "install"
    (share / "xmimsim").install "xmimsimdata.h5"
  end

  test do
    system "#{bin}/xmimsim", "--version"
  end
end
