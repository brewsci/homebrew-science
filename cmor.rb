class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "https://cmor.llnl.gov/"
  url "https://github.com/PCMDI/cmor/archive/CMOR-3.2.7.tar.gz"
  sha256 "a82b023111975e03ea109a32806f0fc1657e81e5f1805bd4aa61adafa25ed7af"
  # doi "10.5281/zenodo.61943"

  bottle do
    sha256 "6fa510a26424638d0dda17ed0e804334f9afd511848fe8da9ee7e75ccf66c675" => :sierra
    sha256 "3d47bc89af00c28e8c56fdfb02ac866c4214dba25fe79b34ddd99ce7caa727a9" => :el_capitan
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
