require 'formula'

class Primer3 < Formula
  homepage 'http://primer3.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/primer3/primer3/2.3.6/primer3-src-2.3.6.tar.gz'
  sha1 '7dbd33a4e9c2a4fe06c74d6b83f8ff0f9ed1c49a'

  def install
    cd "src" do
      system "make all"
      bin.install %w(primer3_core ntdpal oligotm long_seq_tm_test)
    end
  end

  test do
    system "#{bin}/long_seq_tm_test AAAAGGGCCCCCCCCTTTTTTTTTTT 3 20"
  end
end
