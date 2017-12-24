class Cmor < Formula
  desc "Climate Model Output Rewriter for producing CF-compliant netCDF files"
  homepage "https://cmor.llnl.gov/"
  url "https://github.com/PCMDI/cmor/archive/cmor-3.3.0.tar.gz"
  sha256 "d09f24acbffd11c47791e2e86df0dc39ab7276cb46d449f89781d6cce5b488be"
  bottle do
    sha256 "ff1afee32df6f96df3ea12fbb302156fc332e00e42536cd5863e82460d472997" => :high_sierra
    sha256 "271eec456e1f44ec961ad8044d47c8b14ae8cf75cfea3edd64cd5134f642738a" => :sierra
    sha256 "f72c93db27dba89a8923b70e8e77737f8d253d1ed3cf7e87dda3b3cb50df0d6b" => :el_capitan
  end

  # doi "10.5281/zenodo.61943"

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
