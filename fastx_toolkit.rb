class FastxToolkit < Formula
  desc "Process short-read FASTA/FASTQ sequencing files"
  homepage "http://hannonlab.cshl.edu/fastx_toolkit/"
  # tag "bioinformatics"
  revision 1

  stable do
    url "https://github.com/agordon/fastx_toolkit/releases/download/0.0.14/fastx_toolkit-0.0.14.tar.bz2"
    sha256 "9e1f00c4c9f286be59ac0e07ddb7504f3b6433c93c5c7941d6e3208306ff5806"

    resource "libgtextutils" do
      url "https://github.com/agordon/libgtextutils/releases/download/0.7/libgtextutils-0.7.tar.gz"
      sha256 "792e0ea3c96ffe3ad65617a104b7dc50684932bc96d2adab501c952fd65c3e4a"
    end
  end

  bottle do
    cellar :any
    sha256 "cf10cdcfe2c2bc0adbf9a2c07ed23d5135486ab5ab55aebc96801d894261165f" => :sierra
    sha256 "f3dbac857c75c60929ff580dc54de8469cb86f368806b2234f8bb656bd4288ad" => :el_capitan
    sha256 "ba43d2da9dbde551ddb2e1dddee3ac0aad224fa78df3de739a246bceb378eab4" => :yosemite
    sha256 "ebaee0cba18ef482fe4ed0045b36c721335c77fbc82cfcd0101cad589c143059" => :x86_64_linux
  end

  head do
    url "https://github.com/agordon/fastx_toolkit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource "libgtextutils" do
      url "https://github.com/agordon/libgtextutils.git"
    end
  end

  depends_on "pkg-config" => :build

  fails_with :clang do
    build (MacOS.version >= :mavericks ? 425 : 503)
    cause "clang build fails on Mountain Lion, but works on Mavericks. See issue #620"
  end

  def install
    resource("libgtextutils").stage do
      if build.head?
        inreplace "reconf", "libtoolize", "glibtoolize"
        system "sh", "./reconf"
      end
      system "./configure", "--disable-debug",
        "--disable-dependency-tracking",
        "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end

    # --disable-debug causes fastx_trimmer to crash. See #216.
    if build.head?
      inreplace "reconf", "libtoolize", "glibtoolize"
      system "sh", "./reconf"
    end
    system "./configure", "--disable-dependency-tracking",
      "--prefix=#{prefix}", "PKG_CONFIG_PATH=#{lib}/pkgconfig"
    system "make", "install"
    # Hack to fix conflicts with autoconf-archive. See:
    # https://github.com/Homebrew/homebrew-science/issues/5267
    # https://github.com/agordon/fastx_toolkit/issues/6
    rm_rf share
  end

  test do
    fixture = <<-EOS.undent
      >MY-ID
      AAAAAGGGGG
      CCCCCTTTTT
      AGCTN
      EOS
    expect = <<-EOS.undent
      >MY-ID
      AAAAAGGGGGCCCCCTTTTTAGCTN
      EOS
    actual = `echo "#{fixture}" | #{bin}/fasta_formatter`
    actual == expect
  end
end
