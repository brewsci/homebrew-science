class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "https://cmor.llnl.gov/"
  url "https://github.com/PCMDI/cmor/archive/CMOR-3.2.7.tar.gz"
  sha256 "a82b023111975e03ea109a32806f0fc1657e81e5f1805bd4aa61adafa25ed7af"
  revision 1
  # doi "10.5281/zenodo.61943"

  bottle :disable, "needs to be rebuilt with latest netcdf"

  keg_only "conflicts with json-c in main repository"

  depends_on "ossp-uuid"
  depends_on "udunits"
  depends_on "netcdf"
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
    pkgshare.install "Test"
  end
end
