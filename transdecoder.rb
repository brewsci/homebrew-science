class Transdecoder < Formula
  desc "Identifies candidate coding regions within transcript sequences"
  homepage "https://transdecoder.github.io/"
  url "https://github.com/TransDecoder/TransDecoder.git",
      :tag => "v5.0.1",
      :revision => "946f2ee05395a04060f070fab56936bb448caeba"
  head "https://github.com/TransDecoder/TransDecoder.git"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3a510bea681625d2c5f0d7031da14e6ccdfbb206dc19c65b08b1853b870dad1" => :sierra
    sha256 "04c0f23885f20314bf260571ecee8c2169e89a6e9fb66e1b802d9bd6678f0137" => :el_capitan
    sha256 "9fce0a271bce8d297117e8ced5d4e6afe3c3991466361d45b1b2dc9df497275d" => :yosemite
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
