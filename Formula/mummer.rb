class Mummer < Formula
  desc "Alignment of large-scale DNA and protein sequences"
  homepage "https://mummer.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mummer/mummer/3.23/MUMmer3.23.tar.gz"
  sha256 "1efad4f7d8cee0d8eaebb320a2d63745bb3a160bb513a15ef7af46f330af662f"
  revision 2
  # doi "10.1186/gb-2004-5-2-r12"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d89405b88cf2157ce7c819cf21a2db431471c6290d87de02aacd8e4e9c2fd63" => :sierra
    sha256 "4f01363cabe72a13d87f2a42ae29d9875735331e703a34b4756bf8c69d8a7099" => :el_capitan
    sha256 "5478784d9576e5a475ba66f21a8f8014a8bfac43e7ef19d44e3ac32ca5c57768" => :yosemite
    sha256 "50dff6044633b86b4f0f0388fb56cbf1ace2881c9bd4ec30b52f7df3049a2d5e" => :x86_64_linux
  end

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
    mv bin/"annotate", bin/"annotate-mummer"
  end

  test do
    TOOLS.each do |tool|
      # Skip two tools that do not have a help flag
      next if ["gaps", "nucmer2xfig"].include?(tool.to_s)
      assert_match /U(sage|SAGE)/, pipe_output("#{prefix}/#{tool} -h 2>&1")
    end
  end
end
