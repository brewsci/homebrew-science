class Mummer < Formula
  desc "Alignment of large-scale DNA and protein sequences"
  homepage "https://mummer.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mummer/mummer/3.23/MUMmer3.23.tar.gz"
  sha256 "1efad4f7d8cee0d8eaebb320a2d63745bb3a160bb513a15ef7af46f330af662f"
  revision 1
  # doi "10.1186/gb-2004-5-2-r12"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "92a632236c115bb1b36f18e1a1eda4e7c654b634fa3f1c3efbc3d0d4628ab399" => :sierra
    sha256 "f959fe1436ab925952dcc51854fc1954e145305895a28268bf0bd894a098ed8f" => :el_capitan
    sha256 "7820dd18cb5b874424d5227e4ab3504e451268894846be3e1be49020f83337e7" => :yosemite
    sha256 "6231bee3253c98e178ae272f2cd5c39fa60ba0637256ce02c4f9480a796ceae2" => :x86_64_linux
  end

  conflicts_with "gd", :because => "/usr/local/bin/annotate is a symlink belonging to gd"

  depends_on "tcsh" unless OS.mac?

  TOOLS = %w[
    annotate combineMUMs delta-filter dnadiff exact-tandems gaps mapview mgaps
    mummer mummerplot nucmer nucmer2xfig promer repeat-match
    run-mummer1 run-mummer3 show-aligns show-coords show-diff show-snps show-tiling
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
      # Skip two tools that do not have a help flag
      next if ["gaps", "nucmer2xfig"].include?(tool.to_s)
      assert_match /U(sage|SAGE)/, pipe_output("#{bin}/#{tool} -h 2>&1")
    end
  end
end
