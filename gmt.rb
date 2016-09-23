class Gmt < Formula
  desc "Tools for processing and displaying xy and xyz datasets"
  homepage "http://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-5.2.1-src.tar.xz"
  mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gmt-5.2.1-src.tar.xz"
  mirror "ftp://gd.tuwien.ac.at/pub/gmt/gmt-5.2.1-src.tar.xz"
  sha256 "01c199525bdfa78ad388959e739f34eca8effb8d82475c8786a066e04b5e19af"
  revision 1

  bottle do
    sha256 "b4d92a86b065be956b3bd44ad2fe739e24608790441b01d1d74d291622258d46" => :el_capitan
    sha256 "3e3a2c7b9c6a30f0034157fda4f1370b5f412e10af24b8c89b29c2ba96c7bbe7" => :yosemite
    sha256 "02cf0850b7418e0661df235842060b9ccbcdda4af6685a89e0c6fea11c1acb80" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "netcdf"
  depends_on "fftw"
  depends_on "pcre"

  conflicts_with "gmt4", because: "both versions install the same binaries"

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.5.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gshhg-gmt-2.3.5.tar.gz"
    mirror "ftp://gd.tuwien.ac.at/pub/gmt/gshhg-gmt-2.3.5.tar.gz"
    sha256 "dec86939b40fe80d992307352505d89e4ce55ec2cfa67d693f117ba6f6ea6c5e"
  end

  resource "dcw" do
    url "ftp://ftp.soest.hawaii.edu/gmt/dcw-gmt-1.1.2.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/dcw-gmt-1.1.2.tar.gz"
    mirror "ftp://gd.tuwien.ac.at/pub/gmt/dcw-gmt-1.1.2.tar.gz"
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
