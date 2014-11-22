class Cmor < Formula
  homepage "http://www2-pcmdi.llnl.gov/cmor"
  url "https://github.com/PCMDI/cmor/archive/CMOR-2.9.2.tar.gz"
  sha1 "78a7c198690aa53a403b00b273be5d400fac16dc"

  depends_on "ossp-uuid"
  depends_on "udunits"
  depends_on "netcdf" => "with-fortran"
  depends_on :fortran

  def install
    ENV.append "CFLAGS", "-Wno-error=unused-command-line-argument-hard-error-in-future"
    inreplace "configure", "${with_uuid}/include", "${with_uuid}/include/ossp"

    args = %W[
      --prefix=#{prefix}
      --with-uuid=#{Formula["ossp-uuid"].opt_prefix}
      --with-udunits2=#{Formula["udunits"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
    share.install "Test"
  end
end
