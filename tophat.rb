require 'formula'

class Tophat < Formula
  homepage 'http://tophat.cbcb.umd.edu/'
  url 'http://tophat.cbcb.umd.edu/downloads/tophat-2.0.9.tar.gz'
  sha1 '6ca77ae70caf44cf78adca240987300baa72b3c5'

  depends_on 'samtools'
  depends_on 'boost'

  def install
    # Variable length arrays using non-POD element types. Initialize with length=1
    # Reported upstream via email to tophat-cufflinks@gmail.com on 28OCT2012
    inreplace 'src/tophat_reports.cpp', '[num_threads]', '[1]'

    # This can only build serially, otherwise it errors with no make target.
    ENV.deparallelize

    # Must add this to fix missing boost symbols. Autoconf doesn't include it.
    ENV.append 'LIBS', '-lboost_system-mt -lboost_thread-mt'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/tophat", "--version"
  end
end
