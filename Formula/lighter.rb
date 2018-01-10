class Lighter < Formula
  desc "Fast and memory-efficient sequencing error corrector"
  homepage "https://github.com/mourisl/Lighter"
  # tag 'bioinformatics'
  # doi '10.1186/s13059-014-0509-9'

  url "https://github.com/mourisl/Lighter/archive/v1.1.1.tar.gz"
  sha256 "9b29b87cd87f6d57ef8c39d22fb8679977128a1bdf557d8c161eae2816e374b7"
  revision 1

  head "https://github.com/mourisl/Lighter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "129004ab93574d602061f29aced32df646e45e7372a173dde9b3b11c399f94ea" => :sierra
    sha256 "04b6b4bc51e564403d1c8e5433a76ba5ea0fe3d3ba02d89d731de19fe51aaa58" => :el_capitan
    sha256 "dfa7874d6bf0ed13d655deadc66759fcef141cb66e4c0f2c8a9c48f9187cdc78" => :yosemite
  end

  depends_on "zlib" unless OS.mac?

  def install
    # Miscompiles with -Os, see https://github.com/mourisl/Lighter/issues/24
    ENV.O2
    system "make"
    bin.install "lighter"
    doc.install "README.md", "LICENSE"
  end

  test do
    assert_match "num_of_threads", shell_output("#{bin}/lighter -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/lighter -v 2>&1")
  end
end
