class Openni < Formula
  homepage "http://www.openni.org/"

  stable do
    url "https://github.com/OpenNI/OpenNI/archive/Stable-1.5.7.10.tar.gz"
    sha256 "34b0bbf68633bb213dcb15408f979d5384bdceb04e151fa519e107a12e225852"

    # Fix for Mavericks
    patch do
      url "https://github.com/OpenNI/OpenNI/pull/92.diff"
      sha256 "d2bc9bd628cc463b4e7cdc9bf3abc3ba78d04e4d451d02f7f6cf7d0c4d032634"
    end
  end

  bottle do
    cellar :any
    sha256 "32d787ed336f7e44ad706a46ae9e130c3684d0f7ec1559d3f418eece8812de4b" => :el_capitan
    sha256 "c0084f6590d7fd79854868ac4e5d34e05f1a61e103589a2bcfbb46c09a0b2162" => :yosemite
    sha256 "cabb19d1ae8ae8166d7bad26d433ce1bfb4d2de27999fc7431024a750c0ab86d" => :mavericks
  end

  devel do
    url "https://github.com/OpenNI/OpenNI/archive/Unstable-1.5.8.5.tar.gz"
    sha256 "766d3b9745e8d486ad2998e1437bb161188282cfc1553502386457d1438df42f"

    # Fix for Mavericks
    patch do
      url "https://github.com/OpenNI/OpenNI/pull/95.diff"
      sha256 "722fb0a6e6e99a5cc7c7e862ac802dfd3d03785c27af1d20d7f48314ff5154dd"
    end
  end

  head do
    url "https://github.com/OpenNI/OpenNI.git"
    patch do
      url "https://github.com/OpenNI/OpenNI/pull/106.diff"
      sha256 "4aa53e8d6447417be32d1d7ff93788838ee837de291620cb753395be57a25d1d"
    end
  end

  option :universal

  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libusb"
  depends_on "doxygen" => :build

  def install
    ENV.universal_binary if build.universal?

    # Fix build files
    inreplace "Source/OpenNI/XnOpenNI.cpp", "/var/lib/ni/", "#{var}/lib/ni/"
    inreplace "Platform/Linux/Build/Common/CommonJavaMakefile", "/usr/share/java", "#{share}/java"

    # Build OpenNI
    cd "Platform/Linux/CreateRedist"
    chmod 0755, "RedistMaker"
    system "./RedistMaker"

    cd Dir.glob("../Redist/OpenNI-Bin-Dev-MacOSX-v*")[0]

    bin.install Dir["Bin/ni*"]
    lib.install Dir["Lib/*"]
    (include+"ni").install Dir["Include/*"]
    (share+"java").install Dir["Jar/*"]
    (share+"openni/samples").install Dir["Samples/*"]
    doc.install "Documentation"

    # Create and install a pkg-config file
    (lib/"pkgconfig/libopenni.pc").write <<-EOS.undent
      prefix=#{prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include/ni

      Name: OpenNI
      Description: A general purpose driver for all OpenNI cameras.
      Version: #{version}
      Cflags: -I${includedir}
      Libs: -L${libdir} -lOpenNI -lOpenNI.jni -lnimCodecs -lnimMockNodes -lnimRecorder
    EOS
  end

  def post_install
    mkpath "#{var}/lib/ni"
    system "#{bin}/niReg", "#{lib}/libnimMockNodes.dylib"
    system "#{bin}/niReg", "#{lib}/libnimCodecs.dylib"
    system "#{bin}/niReg", "#{lib}/libnimRecorder.dylib"
  end
end
