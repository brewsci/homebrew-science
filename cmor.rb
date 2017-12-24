class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "https://cmor.llnl.gov/"
  url "https://github.com/PCMDI/cmor/archive/cmor-3.3.0.tar.gz"
  sha256 "d09f24acbffd11c47791e2e86df0dc39ab7276cb46d449f89781d6cce5b488be"
  # doi "10.5281/zenodo.61943"

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
