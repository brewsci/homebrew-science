require 'formula'

# NCO: Tools for slicing and dicing NetCDF files.

class Nco < Formula
  homepage 'http://nco.sourceforge.net'
  url 'http://nco.sourceforge.net/src/nco-4.3.1.tar.gz'
  sha1 '0f8cb342905bb310f54c45179ee2c0d0479f905a'

  depends_on 'netcdf'
  depends_on 'gsl'
  depends_on 'udunits'

  # NCO requires the C++ interface in Antlr2.
  depends_on 'homebrew/versions/antlr2'

  def install
    inreplace 'configure' do |s|
      # The Antlr 2.x program installed by Homebrew is called antlr2
      s.gsub! 'for ac_prog in runantlr antlr', 'for ac_prog in runantlr antlr2'
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-netcdf4"
    system "make install"
  end
end
