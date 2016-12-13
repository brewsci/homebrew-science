class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "http://www2-pcmdi.llnl.gov/cmor"
  url "https://github.com/PCMDI/cmor/archive/3.1.2.tar.gz"
  sha256 "ee58b6d405f081e4e0633af931b7992f1a570953b71ece17c01ab9e15889211a"
  revision 1
  # doi "10.5281/zenodo.61943"

  bottle do
    sha256 "698f8d627745f4c3b2f0a99562b2db8a8247d32ae747e30699b142a40fa590a5" => :sierra
    sha256 "850471fc588336a1ae27ad31b626ecdb6eb7fdc9e964265368d6b2febdca834f" => :el_capitan
    sha256 "06ed1fa72c4edc16f295bf8d6461a2b4875ac89ce023acc29e56d015de4a9808" => :yosemite
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
