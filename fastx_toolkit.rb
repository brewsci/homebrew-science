require 'formula'

class Libgtextutils < Formula
  homepage 'http://hannonlab.cshl.edu/fastx_toolkit/'
  url 'http://hannonlab.cshl.edu/fastx_toolkit/libgtextutils-0.6.1.tar.bz2'
  sha1 'dbf1714be75511feae3313904a7449a1f680bc23'
end

class FastxToolkit < Formula
  homepage 'http://hannonlab.cshl.edu/fastx_toolkit/'
  url 'http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit-0.0.13.2.tar.bz2'
  sha1 '51fd9ddc1fc1ffea29d7cabc02e46dd8a1b860ec'

  depends_on 'pkg-config' => :build

  def install
    Libgtextutils.new.brew do
      system './configure', '--disable-debug',
        '--disable-dependency-tracking',
        "--prefix=#{prefix}"
      system 'make'
      system 'make', 'install'
    end

    # --disable-debug causes fastx_trimmer to crash. See #216.
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
