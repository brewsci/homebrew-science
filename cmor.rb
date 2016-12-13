class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "http://www2-pcmdi.llnl.gov/cmor"
  url "https://github.com/PCMDI/cmor/archive/3.1.2.tar.gz"
  sha256 "ee58b6d405f081e4e0633af931b7992f1a570953b71ece17c01ab9e15889211a"
  revision 1
  # doi "10.5281/zenodo.61943"

  bottle do
    sha256 "652cc1010791eccbc52907c809033ed5ed30e7a3c82aaf29b3dce38ddfad3782" => :el_capitan
    sha256 "d01148d52e2f26a1eccf46d1351bf1131434ba488f533858c8401ee6ad9e0898" => :yosemite
    sha256 "8548ba7e8ce1933abcb59b9dcaf3305842ecf2d5f1cdcbfda14a28809e2a5617" => :mavericks
  end

  keg_only "Conflicts with json-c in main repository."

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
    pkgshare.install "Test"
  end
end
