require 'formula'

class Gmt4 < Formula
  homepage 'http://gmt.soest.hawaii.edu/'
  url 'ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.12-src.tar.bz2'
  sha1 'a5ce7419a1aeb523540d2f93ca62153e47ce72fc'

  depends_on 'gdal'
  depends_on 'netcdf'

  conflicts_with 'gmt', :because => 'Both versions install the same binaries.'

  resource 'gshhg' do
    url 'ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.0.tar.gz'
    sha1 'eb62a0a9bceee4297055be18b8727b603cd0e9cb'
  end

  def install
    ENV.deparallelize # Parallel builds don't work due to missing makefile dependencies
    datadir = share/name
    system "./configure", "--prefix=#{prefix}",
                          "--datadir=#{datadir}",
                          "--enable-gdal=#{HOMEBREW_PREFIX}",
                          "--enable-netcdf=#{HOMEBREW_PREFIX}",
                          "--enable-shared",
                          "--enable-triangle",
                          "--disable-xgrid",
                          "--disable-mex"
    system "make"
    system "make install-gmt"
    system "make install-data"
    system "make install-suppl"
    system "make install-man"
    datadir.install resource('gshhg')
  end
end
