class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "http://cmor.llnl.gov/"
  url "https://github.com/PCMDI/cmor/archive/CMOR-3.2.2.tar.gz"
  sha256 "7df4b859e18be93639fa0c00743d985c233a506e6dda5ad9e4c68a97696c7087"
  # doi "10.5281/zenodo.61943"

  bottle do
    sha256 "b5e18dddbefad66888585cbb7ade07d9fd88c5ee21c3f774f17e74203dd994c6" => :sierra
    sha256 "100c3edc5f71d34cf46a7562f603d37bb098bf01097f45269a9e136c3a062f05" => :el_capitan
    sha256 "4d33584e8cca40c5ebdf612fc58eb358bb4b5272b577a66782a215553d308206" => :yosemite
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
