class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "https://cmor.llnl.gov/"
  url "https://github.com/PCMDI/cmor/archive/CMOR-3.2.3.tar.gz"
  sha256 "e4dcd7e16f6bce5817470e628ae9ba7cb51d7f5cd9e2e3ba86b26ee6a9a916bf"
  revision 1
  # doi "10.5281/zenodo.61943"

  bottle do
    sha256 "74500839059681729908a3ef4913e03a8f3869331221221cd6234124223b2652" => :sierra
    sha256 "8ae5f3444890515c758ba8489595f2f89496543bfe5804c38644d49e8d214d29" => :el_capitan
    sha256 "7fbcab47f335401ec00b3157233cb8a5f9a4636a5589b07301a747f323bd3177" => :yosemite
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
