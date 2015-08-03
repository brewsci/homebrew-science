class Primer3 < Formula
  desc "Program for designing PCR primers"
  homepage "http://primer3.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/primer3/primer3/2.3.6/primer3-src-2.3.6.tar.gz"
  sha256 "2ff54faf957f0d7e4c79d9536fa1027b028bc5e4c6005f142df42ef85562ecd4"

  bottle do
    cellar :any
    sha256 "a2063477d744b6f8a941b12e0858db9068aeae9d5b3b80c358037a54f6b0502f" => :yosemite
    sha256 "68df30a6984ad73ec68e2200180f8c8f21e906a2b4c4af8f62d2909a9cdbd7d3" => :mavericks
    sha256 "0eb3406fb87e960f7c46656f746db8849f2daf3ab9aee31154107312ebab0bf2" => :mountain_lion
  end

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
