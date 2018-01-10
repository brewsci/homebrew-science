class Transdecoder < Formula
  desc "Identifies candidate coding regions within transcript sequences"
  homepage "https://transdecoder.github.io/"
  url "https://github.com/TransDecoder/TransDecoder.git",
      :tag => "TransDecoder-v5.0.2",
      :revision => "53a8b411839287cbf0d7268e42ac1c8e9a97e4de"
  head "https://github.com/TransDecoder/TransDecoder.git"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fca076f9d345432c3d9cfd1158e79e1e27dc91273b7d4acfe47e8ac5b9562c6" => :high_sierra
    sha256 "f2792d0332287605bd5d93c540818091b655380951e6c344b6504f929ee986f7" => :sierra
    sha256 "9eab945f87a538fce4389daa47fd30204b99bd06d9cf913e5a39d81dc762bd9a" => :el_capitan
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
