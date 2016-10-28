class Gmt < Formula
  desc "Tools for processing and displaying xy and xyz datasets"
  homepage "http://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-5.3.1-src.tar.xz"
  mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gmt-5.3.1-src.tar.xz"
  mirror "ftp://gd.tuwien.ac.at/pub/gmt/gmt-5.3.1-src.tar.xz"
  mirror "ftp://ftp.iris.washington.edu/pub/gmt/gmt-5.3.1-src.tar.xz"
  sha256 "e46934c356561b15e81f6b766723a577f0c476b685a307d2a351b8569ac350a2"

  bottle do
    sha256 "fdbfe5d4426f29021d297416d8d54e1c5fa869a46423d9594d98c932392f4ce1" => :sierra
    sha256 "d5d5d57a42096d22582ea8a3eadd997c0c372e9df4ce6e2f90b6dbc42f0da124" => :el_capitan
    sha256 "9bd429e628d70322e92b47ded6a8dbd60c7184638f4642f776a50cd9f81acbc7" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "netcdf"
  depends_on "fftw"
  depends_on "pcre"

  conflicts_with "gmt4", :because => "both versions install the same binaries"

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.6.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gshhg-gmt-2.3.6.tar.gz"
    mirror "ftp://gd.tuwien.ac.at/pub/gmt/gshhg-gmt-2.3.6.tar.gz"
    mirror "ftp://ftp.iris.washington.edu/pub/gmt/gshhg-gmt-2.3.6.tar.gz"
    sha256 "ccffff9d96fd6c9cc4f9fbc897d7420c5fc3862fb98d1fd1b03dc4a15c95124e"
  end

  resource "dcw" do
    url "ftp://ftp.soest.hawaii.edu/gmt/dcw-gmt-1.1.2.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/dcw-gmt-1.1.2.tar.gz"
    mirror "ftp://gd.tuwien.ac.at/pub/gmt/dcw-gmt-1.1.2.tar.gz"
    mirror "ftp://ftp.iris.washington.edu/pub/gmt/dcw-gmt-1.1.2.tar.gz"
    sha256 "f719054f8d657e7b10b5182d4c15bc7f38ef7483ed05cdaa9f94ab1a0008bfb6"
  end

  def install
    gshhgdir = buildpath/"gshhg"
    dcwdir = buildpath/"dcw"

    args = std_cmake_args.concat %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DGMT_INSTALL_TRADITIONAL_FOLDERNAMES:BOOL=FALSE
      -DGMT_INSTALL_MODULE_LINKS:BOOL=TRUE
      -DGMT_DOCDIR=#{share}/doc/gmt
      -DGMT_MANDIR=#{man}
      -DGSHHG_ROOT=#{gshhgdir}
      -DCOPY_GSHHG:BOOL=TRUE
      -DDCW_ROOT=#{dcwdir}
      -DCOPY_DCW:BOOL=TRUE
      -DNETCDF_ROOT=#{Formula["netcdf"].opt_prefix}
      -DGDAL_ROOT=#{Formula["gdal"].opt_prefix}
      -DPCRE_ROOT=#{Formula["pcre"].opt_prefix}
      -DFFTW3_ROOT=#{Formula["fftw"].opt_prefix}
      -DLICENSE_RESTRICTED:BOOL=FALSE
      -DFLOCK:BOOL=TRUE
    ]

    mkdir "build" do
      gshhgdir.install resource("gshhg")
      dcwdir.install resource("dcw")
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
      GMT 5 is mostly (but not 100%) compatible with previous versions.
      Moreover, the compatibility mode is expected to exist only during a
      transitional period.

      If you want to continue using GMT 4:
      `brew install gmt4`

      We agreed to the `triangle` license
      (http://www.cs.cmu.edu/~quake/triangle.html) for you.
      If this is unacceptable you should uninstall.
    EOS
  end

  test do
    # Test command sourced from Purdue University
    # Prof. Eric Calais, 'Graphs and Maps with GMT'
    # http://web.ics.purdue.edu/~ecalais/teaching/gmt/GMT_1.pdf
    system "#{bin}/pscoast -R0/360/-70/70 -Jm1.2e-2i -Ba60f30/a30f15 -Dc -G240 -W1/0 -P > GMT_mercator.ps"
    assert File.exist? "GMT_mercator.ps"
  end
end
