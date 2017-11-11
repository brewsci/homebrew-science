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
    sha256 "3d001a6f8c0710032216ec8d8bf17443c31835fad1e020d94e11cd2a40010a62" => :sierra
    sha256 "9dce4d9acfeac6980894ff1e6af4537ef526789d9cb3e5b3ec5a2ce3c90440bc" => :el_capitan
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
