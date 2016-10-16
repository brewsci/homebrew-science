class FastxToolkit < Formula
  desc "Process short-read FASTA/FASTQ sequencing files"
  homepage "http://hannonlab.cshl.edu/fastx_toolkit/"
  # tag "bioinformatics"

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
    sha256 "16a206dd63204c3e4df48dea0cd0fe66fdd523eefc896906a88a62c74c5b4049" => :sierra
    sha256 "0281c815a83cf3656e2e54d2f11fa7a7416938e3e0f4f558408db611ac18c42a" => :el_capitan
    sha256 "58b8c0df75f64dae6649f0a67f4aa8cfcb5512f5da763fdb0075a950bd5d0d2b" => :yosemite
    sha256 "fa884833f4065ceb7193be4d74639e66caa187b9986a9d4606877b1ed8bfa209" => :x86_64_linux
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
