class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "https://cmor.llnl.gov/"
  url "https://github.com/PCMDI/cmor/archive/CMOR-3.2.6.tar.gz"
  sha256 "63a3656ed5a37bfb748766770e61665d6f94b2465d7df47fc03c568e5eb3104a"
  # doi "10.5281/zenodo.61943"

  bottle do
    sha256 "88d8e1041fd80c9c6d0fd2986abf5e9a15ed96607471eaa65a3a8274817e1edd" => :sierra
    sha256 "a41ab61e0af500b614c3fc95a0844e2f1ac2d3dc852801bada7b68bf6722411c" => :el_capitan
    sha256 "e5cc129c4527f5439dfe0d7627f788b43892c83af339fdfc3a8e35dc25cb0942" => :yosemite
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
