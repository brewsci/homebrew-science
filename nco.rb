require 'formula'

# NCO: Tools for slicing and dicing NetCDF files.

class Nco < Formula
  homepage 'http://nco.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/nco/nco-4.4.2.tar.gz'
  sha1 '6253e0d3b00359e1ef2c95f0c86e940697286a10'

  depends_on 'gsl'
  depends_on 'netcdf'
  depends_on 'texinfo'
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
