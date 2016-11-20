class Mummer < Formula
  desc "Alignment of large-scale DNA and protein sequences"
  homepage "http://mummer.sourceforge.net/"
  # doi "10.1186/gb-2004-5-2-r12"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/mummer/mummer/3.23/MUMmer3.23.tar.gz"
  sha256 "1efad4f7d8cee0d8eaebb320a2d63745bb3a160bb513a15ef7af46f330af662f"

  bottle do
    cellar :any
    revision 2
    sha256 "6aa44d5a02b5e39bb7858581e6380954e9ea7049a2b0767fdae6ca4069d79e16" => :yosemite
    sha256 "bfc60ae7f0f87e56fc8cba0c50c4e93004c100f8ea51daaf941bb94ec1ed69b3" => :mavericks
    sha256 "e7910c5501c92e38c0ccdeeb7e91984e3349e0cf9ca99f5b48a780f7d7bffd58" => :mountain_lion
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
