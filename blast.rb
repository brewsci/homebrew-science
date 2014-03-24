require 'formula'

class Blast < Formula
  homepage 'http://blast.ncbi.nlm.nih.gov/'
  url 'ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.29/ncbi-blast-2.2.29+-src.tar.gz'
  version '2.2.29'
  sha1 '6b1e8a4b172ae01dbf2ee1ec3b4c4fce392f3eca'

  depends_on 'gnutls' => :optional

  option 'with-dll', "Create dynamic binaries instead of static"
  option 'without-check', 'Skip the self tests'

  fails_with :clang do
    build 503
    cause "error: 'bits/c++config.h' file not found"
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-dll" if build.with? "dll"
    # Boost is used only for unit tests.
    args << '--without-boost' if build.without? 'check'

    cd 'c++' do
      system './configure', '--without-debug', '--with-mt', *args
      system "make"
      system "make install"

      # libproj.a conflicts with the formula proj
      # mv gives the error message:
      # fileutils.rb:1552:in `stat'
      # Errno::ENOENT: No such file or directory -
      # $HOMEBREW_PREFIX/Cellar/blast/2.2.28/lib/libaccess-static.a
      libexec.mkdir
      # Does not work: mv Dir[lib / 'lib*.a'], libexec
      system "mv #{lib}/lib*.a #{libexec}/"
    end
  end

  def caveats; <<-EOS.undent
    Using the option '--with-dll' will create dynamic binaries instead of
    static. The NCBI Blast static installation is approximately 7 times larger
    than the dynamic.

    Static binaries should be used for speed if the executable requires
    fast startup time, such as if another program is frequently restarting
    the blast executables.

    Static libraries are installed in #{libexec}
    EOS
  end

  test do
    system 'blastn -version'
  end
end
