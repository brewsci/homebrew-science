class Primer3 < Formula
  desc "Program for designing PCR primers"
  homepage "http://primer3.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/primer3/primer3/2.3.6/primer3-src-2.3.6.tar.gz"
  sha256 "2ff54faf957f0d7e4c79d9536fa1027b028bc5e4c6005f142df42ef85562ecd4"

  option "without-check", "Skip build-time tests"

  def install
    cd "src" do
      system "make"
      system "make", "test" if build.with? "check"
      bin.install %w[primer3_core ntdpal ntthal oligotm long_seq_tm_test]
      pkgshare.install "primer3_config"
    end
  end

  test do
    system "#{bin}/long_seq_tm_test AAAAGGGCCCCCCCCTTTTTTTTTTT 3 20"
  end
end
