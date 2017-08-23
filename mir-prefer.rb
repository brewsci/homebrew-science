class MirPrefer < Formula
  desc "MicroRNA prediction from small RNA-seq data"
  homepage "https://github.com/hangelwen/miR-PREFeR"
  # doi "10.1093/bioinformatics/btu380"
  # tag "bioinformatics"
  url "https://github.com/hangelwen/miR-PREFeR/archive/v0.24.tar.gz"
  sha256 "457545478e2d3bc7497d350f3972cf0855b82fa7cb0263a6d91756732f487faf"
  revision 1
  head "https://github.com/hangelwen/miR-PREFeR.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d0744718b793452895b9bca665b6971abc782dc7e21801a30c1fe929d84a558" => :sierra
    sha256 "056724ad2e506db2cf73c467c37cb96d49e0af66756386c86214e0d260295b25" => :el_capitan
    sha256 "056724ad2e506db2cf73c467c37cb96d49e0af66756386c86214e0d260295b25" => :yosemite
    sha256 "49b5825f5cf2ba0550b741e5436da8461bce49e768dd2bf40a1aa465b40f03c5" => :x86_64_linux
  end

  depends_on "samtools"
  depends_on "viennarna"
  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "ncurses"
    depends_on "zlib"
    depends_on :python
  end

  def install
    inreplace "miR_PREFeR.py", /^import sys$/, "#!/usr/bin/env python\nimport sys"
    chmod 0755, "miR_PREFeR.py"
    prefix.install Dir["*"]
    bin.install_symlink "../miR_PREFeR.py"
    bin.install_symlink "miR_PREFeR.py" => "miR_PREFeR"
    if OS.linux?
      # Use the brewed ncurses rather than the host's.
      system "patchelf",
        "--set-rpath", [HOMEBREW_PREFIX, Formula["ncurses"].lib, Formula["zlib"].lib].join(":"),
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        prefix/"dependency/Linux/x64/samtools"
      system "patchelf",
        "--replace-needed", "libncurses.so.5", "libncurses.so.6",
        "--remove-needed", "libtinfo.so.5",
        prefix/"dependency/Linux/x64/samtools"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/miR_PREFeR -h")
  end
end
