class Mummer < Formula
  desc "Alignment of large-scale DNA and protein sequences"
  homepage "http://mummer.sourceforge.net/"
  # doi "10.1186/gb-2004-5-2-r12"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/mummer/mummer/3.23/MUMmer3.23.tar.gz"
  sha256 "1efad4f7d8cee0d8eaebb320a2d63745bb3a160bb513a15ef7af46f330af662f"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "cb364eccca060e00b858efb9ff9d1b4fc019e75fb6547a0f678092c1f9b976c8" => :sierra
    sha256 "379cb6612e658485c9cd3f4e8faad31f0fc4a5134e39b1eab7ed023a150ed62a" => :el_capitan
    sha256 "e7aa1f70d35e3e4d6fb4d0192e09b6a919894a704a776ee2a1cf3bbf1d54d6b0" => :yosemite
  end

  # annotate conflicts with gd
  TOOLS = %w[
    combineMUMs delta-filter dnadiff exact-tandems mapview mgaps
    mummer mummerplot nucmer promer repeat-match
    run-mummer1 run-mummer3 show-coords show-diff show-snps show-tiling
  ].freeze

  def install
    prefix.install Dir["*"]
    cd prefix do
      system "make"
      rm_r "src"
    end
    TOOLS.each { |tool| bin.install_symlink prefix/tool }
  end

  test do
    TOOLS.each do |tool|
      assert_match /U(sage|SAGE)/, pipe_output("#{bin}/#{tool} -h 2>&1")
    end
  end
end
