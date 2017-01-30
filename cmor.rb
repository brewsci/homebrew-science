class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "http://cmor.llnl.gov/"
  url "https://github.com/PCMDI/cmor/archive/3.2.1.tar.gz"
  sha256 "4838a695be1830a10f7e01bb1b4142fd151f28e0e417d4470aa49b821e3b31a8"
  revision 1
  # doi "10.5281/zenodo.61943"

  bottle do
    sha256 "2db7f8269a594374a4af4830b2ae2dcb10a15a3de6321ee026f65f4170aeead6" => :sierra
    sha256 "d29670401ad519deaeaff292f3f27c2d98557682314d080a3ca753d6b6307481" => :el_capitan
    sha256 "0cb355a6bd0aabf8c15bd73c11adf52babd01297131d0e7a2c67412230e95151" => :yosemite
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
