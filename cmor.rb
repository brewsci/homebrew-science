class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "https://cmor.llnl.gov/"
  url "https://github.com/PCMDI/cmor/archive/CMOR-3.2.6.tar.gz"
  sha256 "63a3656ed5a37bfb748766770e61665d6f94b2465d7df47fc03c568e5eb3104a"
  # doi "10.5281/zenodo.61943"

  bottle do
    sha256 "653ef16a8ea45e4d9823350549a1422d1f8900194778269f3389e339d76fc240" => :sierra
    sha256 "f3c6f4bca656c103274dda65ec6e77a33eb9d1d67ba0e927a3593bcd441f0e31" => :el_capitan
    sha256 "b109e83b35f6f2beb965d5d60c21ec350ae4b29b7b63bcc39c68568350e6ae21" => :yosemite
  end

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
