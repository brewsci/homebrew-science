require "formula"

class Primer3 < Formula
  homepage "http://primer3.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/primer3/primer3/2.3.6/primer3-src-2.3.6.tar.gz"
  sha1 "7dbd33a4e9c2a4fe06c74d6b83f8ff0f9ed1c49a"

  option "with-check", "Run build-time tests"

  def install
    cd "src" do
      system "make", "test" if build.with? "check"
      system "make", "all"
      bin.install %w[primer3_core ntdpal ntthal oligotm long_seq_tm_test]
      share.install "primer3_config"
    end
  end

  test do
    system "#{bin}/long_seq_tm_test AAAAGGGCCCCCCCCTTTTTTTTTTT 3 20"
  end
end
