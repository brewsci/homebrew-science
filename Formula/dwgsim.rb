class Dwgsim < Formula
  homepage "https://github.com/nh13/DWGSIM"
  url "https://github.com/nh13/DWGSIM.git",
    :tag => "dwgsim.0.1.12",
    :revision => "4fd56bf39dbba3801856fa0512aed68726e3ca6e"
  head "https://github.com/nh13/DWGSIM.git"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "b192be1a5f9e084d1611578edf3e2e9f12e41b4c95135b43ca5d95243e811363" => :sierra
    sha256 "efa87bd65372f93ce3ee7141e60b559dae71a1db9a6f4e72648f04e05e6236d0" => :el_capitan
    sha256 "1ca0062c7ae8e5185604bd34d3e6d60d63e99adfffa3659cac10fdfd5d5f4788" => :yosemite
    sha256 "43b7ffae90cbd82cc456e786f83efdfecbf222c1a8c337a1a30fbe01b9dca2d6" => :x86_64_linux
  end

  unless OS.mac?
    # dwgsim builds a vendored copy of samtools, which requires ncurses.
    depends_on "ncurses" => :build
    depends_on "zlib"
  end

  def install
    system "make"
    bin.install "dwgsim", "dwgsim_eval"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/dwgsim -h 2>&1", 1)
  end
end
