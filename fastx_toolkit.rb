require 'formula'

class FastxToolkit < Formula
  homepage 'http://hannonlab.cshl.edu/fastx_toolkit/'

  stable do
    url 'https://github.com/agordon/fastx_toolkit/releases/download/0.0.14/fastx_toolkit-0.0.14.tar.bz2'
    sha1 'd8434af2dd647e303506a54ab14fe667aabc1a86'

    resource 'libgtextutils' do
      url 'https://github.com/agordon/libgtextutils/releases/download/0.7/libgtextutils-0.7.tar.gz'
      sha1 '92aef0099369d2e57ce47599a5339ca14abfd953'
    end
  end

  head do
    url 'https://github.com/agordon/fastx_toolkit.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource 'libgtextutils' do
      url 'https://github.com/agordon/libgtextutils.git'
    end
  end

  depends_on 'pkg-config' => :build

  fails_with :clang do
     build (MacOS.version >= :mavericks ? 425 : 503)
     cause 'clang build fails on Mountain Lion, but works on Mavericks. See issue #620'
  end

  def install
    resource('libgtextutils').stage do
      if build.head?
        inreplace 'reconf', 'libtoolize', 'glibtoolize'
        system 'sh', './reconf'
      end
      system './configure', '--disable-debug',
        '--disable-dependency-tracking',
        "--prefix=#{prefix}"
      system 'make'
      system 'make', 'install'
    end

    # --disable-debug causes fastx_trimmer to crash. See #216.
    if build.head?
      inreplace 'reconf', 'libtoolize', 'glibtoolize'
      system 'sh', './reconf'
    end
    system './configure', '--disable-dependency-tracking',
      "--prefix=#{prefix}", "PKG_CONFIG_PATH=#{lib}/pkgconfig"
    system 'make', 'install'
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
