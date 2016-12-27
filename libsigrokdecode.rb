class Libsigrokdecode < Formula
  desc "Library for (streaming) protocol decoding"
  homepage "http://sigrok.org/"

  stable do
    url "http://sigrok.org/download/source/libsigrokdecode/libsigrokdecode-0.4.1.tar.gz"
    sha256 "065f70c10971173d86e03a8cf5534e600c7a622775113997d8061572135d4a95"

    resource "librevisa" do
      url "http://www.librevisa.org/git/librevisa.git", :tag => "alpha-2013-08-12",
                                                        :revision => "3e3e027ac7bcf2679089adc8886bb3c92574a042"
    end

    resource "libserialport" do
      url "http://sigrok.org/download/source/libserialport/libserialport-0.1.1.tar.gz"
      sha256 "4a2af9d9c3ff488e92fb75b4ba38b35bcf9b8a66df04773eba2a7bbf1fa7529d"
    end

    resource "libsigrok" do
      url "http://sigrok.org/download/source/libsigrok/libsigrok-0.4.0.tar.gz"
      sha256 "5f291f3fee36e6dab1336f1c78596e50588831bc5ebd7cddc2a95fe8c71d669e"
    end
  end

  bottle do
    sha256 "286e5f39380dc99e8b5bcdad75a44b1d50f8f6d1cbc86734bbfab25993fc1324" => :sierra
    sha256 "c59683f5fca7bea78843c31a623e25d60318e780fefaf3e2c6b28b7fb78d0acc" => :el_capitan
    sha256 "1beaf120f2a5be8d30e8096b53f4952e24d5e3443c0c0be17846f81541f7f5d8" => :yosemite
    sha256 "69c1b175edcc9d785e254147a98c4739d70d84df5596446deb4cf3c7eb61c79e" => :x86_64_linux
  end

  head do
    url "git://sigrok.org/libsigrokdecode", :shallow => false

    depends_on "libtool" => :build
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
  end

  option "with-libserialport", "Build with libserialport"
  option "with-librevisa", "Build with librevisa"

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
  if build.with?("librevisa")
    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

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
end
