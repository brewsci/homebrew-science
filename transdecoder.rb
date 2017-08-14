class Transdecoder < Formula
  desc "Identifies candidate coding regions within transcript sequences"
  homepage "https://transdecoder.github.io/"
  url "https://github.com/TransDecoder/TransDecoder.git",
      :tag => "v4.0.1",
      :revision => "ad437aee6e06213fd0c8778a7c7e3fbe7a013b5f"
  head "https://github.com/TransDecoder/TransDecoder.git"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "62791174d83a4655aa3528db0013b9e5cf1094adf28dc2ba7cb4def12d1582c7" => :sierra
    sha256 "4951a7abb70285be57c38ba50104213e5d7c90e33f61b4821ae5d3843ef4c72b" => :el_capitan
    sha256 "dcd341b6cd8607a7f0ee276bed52a5b4e37d3b8f4b8dc4d1d8c5e3ca51700d8d" => :yosemite
    sha256 "fb5224366a2b65b97322244f566727b0d63d37d99cf54f4f5f741f8a8244e9a6" => :x86_64_linux
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
