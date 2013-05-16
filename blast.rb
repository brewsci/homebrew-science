require 'formula'

class Blast < Formula
  homepage 'http://blast.ncbi.nlm.nih.gov/'
  url 'ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.28/ncbi-blast-2.2.28+-src.tar.gz'
  version '2.2.28'
  sha1 '6941d2b83c410b2e2424266d8ee29ee7581c23d6'

  depends_on 'gnutls' => :optional

  option 'with-dll', "Create dynamic binaries instead of static"

  def patches
    # Support recent versions of gnutls
    'http://www.ncbi.nlm.nih.gov/viewvc/v1/trunk/c%2B%2B/src/connect/ncbi_gnutls.c?view=patch&r1=57856&r2=57915'
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-dll" if build.include? 'with-dll'

    cd 'c++' do
      system './configure', '--without-debug', '--with-mt', *args
      system "make"
      system "make install"
    end
  end

  def caveats; <<-EOS.undent
    Using the option '--with-dll' will create dynamic binaries instead of
    static. The NCBI Blast static installation is approximately 7 times larger
    than the dynamic.

    Static binaries should be used for speed if the executable requires
    fast startup time, such as if another program is frequently restarting
    the blast executables.
    EOS
  end
end
