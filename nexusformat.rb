require "formula"

class Nexusformat < Formula
  homepage "http://www.nexusformat.org"
  url "http://download.nexusformat.org/kits/4.3.1/nexus-4.3.1.tar.gz"
  sha1 "ed75a442acad8bc14745df42822286fb735ed526"

  depends_on 'hdf5'
  depends_on 'libmxml'
  depends_on 'readline' => :recommended
  depends_on 'doxygen' => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-debug
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/nxdir"
  end
end
