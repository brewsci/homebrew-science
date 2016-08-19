class Primer3 < Formula
  desc "Program for designing PCR primers"
  homepage "http://primer3.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/primer3/primer3/2.3.7/primer3-2.3.7.tar.gz"
  sha256 "9e37a301d2ca9e5034c9a9d4afcb3e90041f6cc44c658b63598d0ccfcb176e5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6163ced92c25d26f09b01f407a08ff4a50a17c0aa5a2ab813db586f4f7c4ed6f" => :el_capitan
    sha256 "b63546771335e1d1263ecd9e6c94f5c09d5bb073dee7c879b813d64e788317b8" => :yosemite
    sha256 "437f1028ed79c520133ecfbf885d6fdf3345807e9530be78af4945f6f2b66d53" => :mavericks
  end

  option "without-test", "Skip build-time tests"
  deprecated_option "without-check" => "without-test"

  def install
    cd "src" do
      system "make"
      system "make", "test" if build.with? "test"
      bin.install %w[primer3_core ntdpal ntthal oligotm long_seq_tm_test]
      pkgshare.install "primer3_config"
    end
  end

  test do
    system "#{bin}/long_seq_tm_test", "AAAAGGGCCCCCCCCTTTTTTTTTTT", "3", "20"
  end
end
