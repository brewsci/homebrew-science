class Libsigrokdecode < Formula
  desc "Library for (streaming) protocol decoding"
  homepage "https://sigrok.org/"

  stable do
    url "https://sigrok.org/download/source/libsigrokdecode/libsigrokdecode-0.5.0.tar.gz"
    sha256 "4aa8579ecea9b421b8ac048a9b18c27e63206839f269374398d89c14a47bd1c1"

    resource "librevisa" do
      url "http://www.librevisa.org/git/librevisa.git", :tag => "alpha-2013-08-12",
                                                        :revision => "3e3e027ac7bcf2679089adc8886bb3c92574a042"
    end

    resource "libserialport" do
      url "https://sigrok.org/download/source/libserialport/libserialport-0.1.1.tar.gz"
      sha256 "4a2af9d9c3ff488e92fb75b4ba38b35bcf9b8a66df04773eba2a7bbf1fa7529d"
    end

    resource "libsigrok" do
      url "https://sigrok.org/download/source/libsigrok/libsigrok-0.5.0.tar.gz"
      sha256 "4c8c86779b880a5c419f6c77a08b1147021e5a19fa83b0f3b19da27463c9f3a4"
    end

    resource "fx2lafw" do
      url "https://sigrok.org/download/source/sigrok-firmware-fx2lafw/sigrok-firmware-fx2lafw-0.1.5.tar.gz"
      sha256 "ca74096b93baed48ef3e59ce0c97111153b9a2a8841c40019500b09b897f6d2d"
    end
  end

  bottle do
    sha256 "60a432705edac4a617e2260de724056518c7a90285291558f76a62b3fa0d33c0" => :sierra
    sha256 "52c241ba07cdd486946af95fa541e6ca1144546d0378df163a899df26a9a27f1" => :el_capitan
    sha256 "df65b728fe688324cdf6ce2fa82e342b40036f495410bd31d54a8176ca0d6a05" => :yosemite
    sha256 "502d100193fe55bf3aeb5576cf5c5b4540f51e38188eb8e9d9a0f5346b2b4e35" => :x86_64_linux
  end

  head do
    url "git://sigrok.org/libsigrokdecode", :shallow => false

    depends_on "libtool" => :build unless OS.mac?
    depends_on "autoconf" => :build
    depends_on "automake" => :build

    resource "librevisa" do
      # currently needed for librevisa due to errors in released alpha build
      url "http://www.librevisa.org/git/librevisa.git"
    end

    resource "libserialport" do
      url "git://sigrok.org/libserialport", :shallow => false
    end

    resource "libsigrok" do
      url "git://sigrok.org/libsigrok", :shallow => false
    end

    resource "fx2lafw" do
      url "git://sigrok.org/sigrok-firmware-fx2lafw.git", :shallow => false
    end
  end

  option "with-libserialport", "Build with libserialport"
  option "with-librevisa", "Build with librevisa"
  option "with-fx2lafw", "Build with fx2lafw"

  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "glibmm"
  depends_on :java
  depends_on "libzip"
  depends_on :python3
  depends_on "check"    => :optional
  depends_on "libftdi0" => :optional
  depends_on "libusb"   => :optional

  # currently needed for librevisa due to errors in released alpha build
  depends_on "libtool" => :build if build.with?("librevisa")

  depends_on "sdcc" => :build if build.with?("fx2lafw")

  def install
    common_args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    ENV.delete "PYTHONPATH"
    ENV.append_path "PKG_CONFIG_PATH", lib / "pkgconfig"
    ENV.append_path "PKG_CONFIG_PATH", HOMEBREW_PREFIX / "Frameworks/Python.framework/Versions/3.4/lib/pkgconfig"

    if build.with? "libserialport"
      resource("libserialport").stage do
        system "./autogen.sh" if build.head?
        system "./configure", *common_args
        system "make", "install"
      end
    end

    if build.with? "fx2lafw"
      resource("fx2lafw").stage do
        system "./autogen.sh" if build.head?
        system "./configure", "--prefix=#{prefix}"
        system "make", "install"
      end
    end

    if build.with? "librevisa"
      resource("librevisa").stage do
        # needed for 2013-08-12. fixed on HEAD
        # patch version https://gist.github.com/tduehr/3b4257251c7ed720225c
        inreplace "autogen.sh", "libtoolize", "glibtoolize" unless build.head?
        system "./autogen.sh"
        system "./configure", *common_args
        system "make", "install"
      end
    end

    # not strictly needed for libsigrokdecode but both sigrok-cli and pulseview
    # need it so we install it here as a resource to avoid collisions
    resource("libsigrok").stage do
      system "./autogen.sh" if build.head?
      system "./configure", *common_args
      system "make", "install"
    end

    ENV.deparallelize

    system "./autogen.sh" if build.head?
    system "./configure", *common_args
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libsigrokdecode/libsigrokdecode.h>
      int main() {
        if (srd_init(NULL) != SRD_OK || srd_exit() != SRD_OK)
          return 1;
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-I#{Formula["glib"].opt_include}/glib-2.0", "-I#{Formula["glib"].opt_lib}/glib-2.0/include", "-L#{Formula["glib"].opt_lib}", "-lsigrokdecode"
    system "./test"
  end
end
