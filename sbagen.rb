class Sbagen < Formula
  homepage "https://uazu.net/sbagen/"
  url "https://uazu.net/sbagen/sbagen-1.4.5.tgz"
  sha256 "02b05d0f89f1baa6e6b282f4a5db279b4c59ee6fc400a5a9686aa11287f220e4"

  patch :DATA

  option "without-river", "Skip downloading loopable river sounds"

  resource "river" do
    url "https://uazu.net/sbagen/sbagen-river-1.4.1.tgz"
    sha256 "81545ec71461421f938dc2febd9379dc36886a84df30deee20cd43eae81a5765"
  end

  def install
    system "./mk-macosx"

    bin.install "sbagen"
    doc.install Dir["*.txt"]

    sbagen_share = share + "sbagen"
    sbagen_share.install "examples", "scripts"

    sbagen_share.install resource("river") if build.with? "river"
  end

  test do
    File.open("test.sbg", "w") do |file|
      file.write <<-EOS.undent
        -SE
        silent: -
        0:00:00 == silent
        0:00:01 == silent
      EOS
    end
    system "#{bin}/sbagen", "test.sbg"
  end
end

__END__
--- a/sbagen.c
+++ b/sbagen.c
@@ -149,7 +149,7 @@
  #include <mmsystem.h>
 #endif
 #ifdef MAC_AUDIO
- #include <Carbon.h>
+ #include <Carbon/Carbon.h>
  #include <CoreAudio/CoreAudio.h>
 #endif
 #ifdef UNIX_TIME
