class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "https://cmor.llnl.gov/"
  url "https://github.com/PCMDI/cmor/archive/CMOR-3.2.3.tar.gz"
  sha256 "e4dcd7e16f6bce5817470e628ae9ba7cb51d7f5cd9e2e3ba86b26ee6a9a916bf"
  revision 1
  # doi "10.5281/zenodo.61943"

  bottle do
    sha256 "1848e05c97d342bb198aa39815d4940259787744fb53a85aaa64d5934d4297ab" => :sierra
    sha256 "7245825b27f0a5611f60f73af3573215b761aceadca3c3690078d0861068528c" => :el_capitan
    sha256 "8d61a3b4b129495941c7f915397263e3c6cc7e8614f48b9abe3a489b81553ca4" => :yosemite
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
