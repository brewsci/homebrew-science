class Transdecoder < Formula
  desc "Identifies candidate coding regions within transcript sequences"
  homepage "https://transdecoder.github.io/"
  url "https://github.com/TransDecoder/TransDecoder.git",
      :tag => "v4.1.0",
      :revision => "8f0e552ff76bb842182870d4e001d3d4d1412c5f"
  head "https://github.com/TransDecoder/TransDecoder.git"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "c354950ed9b4f2e79be065fe770307d748f6ad13bd8f8be07d7d961d25e1878f" => :sierra
    sha256 "4bc31084ede4ea4cf2b17e6ce1c3c19b33058d5ca2501a69fbe8efc01b16e16b" => :el_capitan
    sha256 "5d8df204b6048afbdc9458fd5c0ae84448d24acbec541f5040f499ba1f24a7ce" => :yosemite
    sha256 "dd64184ecb6f94adfb3df75318083413fc080f442a9cda3a4304b17559094248" => :x86_64_linux
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
