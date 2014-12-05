require 'formula'

class Moab < Formula
  homepage 'https://trac.mcs.anl.gov/projects/ITAPS/wiki/MOAB'
  url 'https://bitbucket.org/fathomteam/moab/get/4.6.2.tar.gz'
  sha1 '20494f8f13ea621a7b3fa30d98e0535957b237aa'

  option 'without-check', "Skip build-time checks (not recommended)"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
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
