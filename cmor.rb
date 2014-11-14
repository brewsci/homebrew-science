require "formula"

class Cmor < Formula
  homepage "http://www2-pcmdi.llnl.gov/cmor"
  url "https://github.com/PCMDI/cmor/archive/CMOR-2.9.1.tar.gz"
  sha1 "1e2d8e539ff4deb76b98886f28b1881464017a2a"

  depends_on "ossp-uuid"
  depends_on "udunits"
  depends_on "netcdf" => "with-fortran"
  depends_on :fortran

  def install
    ENV.append "CFLAGS", "-Wno-error=unused-command-line-argument-hard-error-in-future"

    args = %W[
      --prefix=#{prefix}
      --with-uuid=#{Formula["ossp-uuid"].opt_prefix}
      --with-udunits2=#{Formula["udunits"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
    ]

    system "./configure", *args
    system "make install"
  end
end
