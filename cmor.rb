class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "http://cmor.llnl.gov/"
  url "https://github.com/PCMDI/cmor/archive/CMOR-3.2.2.tar.gz"
  sha256 "7df4b859e18be93639fa0c00743d985c233a506e6dda5ad9e4c68a97696c7087"
  # doi "10.5281/zenodo.61943"

  bottle do
    sha256 "e7976467a569103e889806dd376823b2fdef712636c6100f906d24dbbdcb1f47" => :sierra
    sha256 "714ff0bba2f1a923f38c63bb9b2d5b38283c8e22a99ccee36ea61bd2fed86ed0" => :el_capitan
    sha256 "6f91c78dfa0759aa55295433a19658cb77fec20d62a1a02b4a9d35eb3e25cbcc" => :yosemite
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
