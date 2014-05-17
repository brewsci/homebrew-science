require 'formula'

class Moab < Formula
  homepage 'https://trac.mcs.anl.gov/projects/ITAPS/wiki/MOAB'
  url 'https://bitbucket.org/fathomteam/moab/get/4.6.2.tar.gz'
  sha1 'cecd30aaf9bdbb58078e06b0097a9144cac63d7f'

  option 'without-check', "Skip build-time checks (not recommended)"

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'netcdf'
  depends_on 'hdf5'
  depends_on :fortran if build.with? 'check'

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--libdir=#{libexec}/lib"

    system "make install"
    # Moab installs non-lib files in libdir. Link only the libraries.
    lib.install_symlink Dir["#{libexec}/lib/*.a"]
    system "make check" if build.with? 'check'
  end
end
