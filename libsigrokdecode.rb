class Libsigrokdecode < Formula
  desc "Library for (streaming) protocol decoding"
  homepage "http://sigrok.org/"

  stable do
    url "http://sigrok.org/download/source/libsigrokdecode/libsigrokdecode-0.4.0.tar.gz"
    sha256 "fd7e9d1b73245e844ead97a16d5321c766196f946c9b28a8646cab2e98ec3537"

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
    sha256 "9f00e902cc67765b56d3d377ef27e49f41445c889fb31788d468fbf294794d1b" => :el_capitan
    sha256 "7e64006458494989213a2a70bf0d8a3f72bb7f67360395c42524c0abd9c0e230" => :yosemite
    sha256 "6eb9503d9b22617221856ae4efdf63e9c71b6273486ce503d3f3f5db89c990d5" => :mavericks
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
  depends_on "libusb"   => :recommended

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
    end

    ENV.deparallelize

    system "./autogen.sh" if build.head?
    system "./configure", *common_args
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
