class Transdecoder < Formula
  desc "Identifies candidate coding regions within transcript sequences"
  homepage "https://transdecoder.github.io/"
  url "https://github.com/TransDecoder/TransDecoder.git",
      :tag => "v4.0.3",
      :revision => "ea5b111dc6d49c076d080cb903e4932cf3d73130"
  head "https://github.com/TransDecoder/TransDecoder.git"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "6192f3b9dafa190ca6b2f861f188152af77963c874bbd09baa1143cc6961ed81" => :sierra
    sha256 "b777d3ed649ddff22794904d955190a9c67b649e67da511bb10327adf580be07" => :el_capitan
    sha256 "5af84db0235bea68e352876466079d0d33809c5d0f70442f159103707cd5c26b" => :yosemite
  end

  def install
    system "make", "test"
    rm "Makefile"
    rm_rf Dir["TransDecoder.lrgTests/{.git,README.md}"]

    prefix.install_metafiles
    libexec.install Dir["*"]

    ["sample_data", "TransDecoder.lrgTests", "util"].each do |f|
      pkgshare.install_symlink libexec/f
    end

    bin.write_exec_script Dir[libexec/"*"].select { |f| File.file?(f) && File.executable?(f) }
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/TransDecoder.LongOrfs 2>&1", 1)
    assert_match "USAGE", shell_output("#{bin}/TransDecoder.Predict 2>&1", 1)
  end
end
