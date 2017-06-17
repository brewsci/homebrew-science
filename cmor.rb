class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "https://cmor.llnl.gov/"
  url "https://github.com/PCMDI/cmor/archive/CMOR-3.2.4.tar.gz"
  sha256 "55e3dc817b0ecfd0286a187321fc748cd0e0e88e8ebdc01d9667c46df081395f"
  # doi "10.5281/zenodo.61943"

  bottle do
    sha256 "77fa48901bada3472fd88eb2c7bf08c9ddca57bcaa8cc9d91590f744a2ee42cf" => :sierra
    sha256 "83efc240aacb9fd4c0faeb227a60f7e15249f1bd3265ed7f32bd6d4d0e198ad4" => :el_capitan
    sha256 "b7124ebf9f04f6e84400357ee78c9b2b55f81d3b562956040513d767d1904988" => :yosemite
  end

  keg_only "conflicts with json-c in main repository"

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
