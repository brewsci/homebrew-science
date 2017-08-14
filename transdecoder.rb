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
    sha256 "05955821eb2ace7c8ef8bfd5a36ff35321355e35f3b432235c08ce29b4cd7411" => :sierra
    sha256 "b1c90616d9d140b4e313c1ea831d435965cad5d6a680083a3f00b70f0cb1efe1" => :el_capitan
    sha256 "4a812936c775a6c2edca2c8e1930c143596bfe4c2817e9a71b0bcc7d45af38ec" => :yosemite
    sha256 "d71073ab9daca3ff95cbba7c241e1066ff7b17a62ce180744e26692e1062caa9" => :x86_64_linux
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
