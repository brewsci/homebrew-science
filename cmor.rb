class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "http://www2-pcmdi.llnl.gov/cmor"
  url "https://github.com/PCMDI/cmor/archive/3.2.1.tar.gz"
  sha256 "4838a695be1830a10f7e01bb1b4142fd151f28e0e417d4470aa49b821e3b31a8"
  # doi "10.5281/zenodo.61943"

  bottle do
    sha256 "2d6879223f7e31dad0a9b0bc149ff4e518bfca45ec36a04146336e4b857569de" => :sierra
    sha256 "a836f017e61c6671b915f6f899678a95146354dea9de47b414916506edf8501c" => :el_capitan
    sha256 "5cd3c325f35380846f7fba15daab71915e6b0c8da332655af8709856c7ecf5b7" => :yosemite
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
