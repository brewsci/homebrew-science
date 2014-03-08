require 'formula'

class Openni < Formula
  homepage 'http://www.openni.org/'
  url 'https://github.com/OpenNI/OpenNI/archive/Stable-1.5.7.10.tar.gz'
  sha1 '5793222bd8f0f3f2ff152f619624bef2d6da427a'
  head 'https://github.com/OpenNI/OpenNI.git'

  devel do
    url 'https://github.com/OpenNI/OpenNI/archive/Unstable-1.5.8.5.tar.gz'
    sha1 '0292cdacf34964a087f3e07bbc8ca21a627b6b64'
  end

  option :universal

  depends_on :automake
  depends_on :libtool
  depends_on 'libusb'
  depends_on 'doxygen' => :build

  def patches
    # Fix for Mavericks (it's the same patch with different whitespaces)
    if build.devel?
      "https://github.com/OpenNI/OpenNI/pull/95.patch"
    else
      "https://github.com/OpenNI/OpenNI/pull/92.patch"
    end
  end

  def install
    ENV.universal_binary if build.universal?

    # Fix build files
    inreplace 'Source/OpenNI/XnOpenNI.cpp', '/var/lib/ni/', "#{var}/lib/ni/"
    inreplace 'Platform/Linux/Build/Common/CommonJavaMakefile', '/usr/share/java', "#{share}/java"

    # Build OpenNI
    cd 'Platform/Linux/CreateRedist'
    chmod 0755, 'RedistMaker'
    system './RedistMaker'

    cd Dir.glob('../Redist/OpenNI-Bin-Dev-MacOSX-v*')[0]

    bin.install Dir['Bin/ni*']
    lib.install Dir['Lib/*']
    (include+'ni').install Dir['Include/*']
    (share+'java').install Dir['Jar/*']
    (share+'openni/samples').install Dir['Samples/*']
    doc.install 'Documentation'

    # Create and install a pkg-config file
    (lib/"pkg-config/libopenni.pc").write <<-EOS.undent
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
    system "#{bin}/niReg #{lib}/libnimMockNodes.dylib"
    system "#{bin}/niReg #{lib}/libnimCodecs.dylib"
    system "#{bin}/niReg #{lib}/libnimRecorder.dylib"
  end
end
