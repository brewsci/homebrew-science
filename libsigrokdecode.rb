require "formula"

class Libsigrokdecode < Formula
  url "http://sigrok.org/download/source/libsigrokdecode/libsigrokdecode-0.3.0.tar.gz"
  homepage "http://sigrok.org/"
  head "git://sigrok.org/libsigrokdecode", :shallow => false
  sha1 "a75f2839cf62d965281bac22919e761c5210e32e"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libzip"
  depends_on :python3

  depends_on "check"    => :optional
  depends_on "libftdi0" => :optional
  depends_on "libusb"   => :recommended

  option "with-libserialport", "Build with libserialport"
  option "with-librevisa", "Build with librevisa"

  # currently needed for librevisa due to errors in released alpha build
  if build.with?("librevisa")
    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  head do
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

  stable do
    resource "librevisa" do
      url "http://www.librevisa.org/git/librevisa.git", :tag => "alpha-2013-08-12"
      sha1 "1bb24a6721cc994494f294fd86c78594ba4f8b40"
    end

    resource "libserialport" do
      url "http://sigrok.org/download/source/libserialport/libserialport-0.1.0.tar.gz"
      sha1 "f8677c9e63caf1f6e6cb6aa39a8ae3a256516d78"
    end

    resource "libsigrok" do
      url "http://sigrok.org/download/source/libsigrok/libsigrok-0.3.0.tar.gz"
      sha1 "140db550820f98042d95432a87a9d7e3078b1490"
    end
  end

  def install
    common_args = %W(
      --disable-dependency-tracking
      --prefix=#{prefix}
    )

    ENV.delete "PYTHONPATH"
    ENV.append_path "PKG_CONFIG_PATH", lib / "pkgconfig"
    ENV.append_path "PKG_CONFIG_PATH", HOMEBREW_PREFIX / "Frameworks/Python.framework/Versions/3.4/lib/pkgconfig"

    resource("libserialport").stage do
      system "./autogen.sh" if build.head?
      system "./configure", *common_args
      system "make", "install"
    end if build.with? "libserialport"

    resource("librevisa").stage do
      # needed for 2013-08-12. fixed on HEAD
      # patch version https://gist.github.com/tduehr/3b4257251c7ed720225c
      inreplace "autogen.sh", "libtoolize", "glibtoolize" unless build.head?
      system "./autogen.sh"
      system "./configure", *common_args
      system "make", "install"
    end if build.with? "librevisa"

    # not strictly needed for libsigrokdecode but both sigrok-cli and pulseview
    # need it so we install it here as a resource to avoid collisions
    resource("libsigrok").stage do
      system "./autogen.sh" if build.head?
      system "./configure", *common_args
      system "make", "install"
      share.install
    end

    ENV.deparallelize

    system "./autogen.sh" if build.head?
    system "./configure", *common_args
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
