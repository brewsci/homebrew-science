class Transdecoder < Formula
  desc "Identifies candidate coding regions within transcript sequences"
  homepage "https://transdecoder.github.io/"
  url "https://github.com/TransDecoder/TransDecoder.git",
      :tag => "v3.0.1",
      :revision => "9b52e6933371c89a62b8dde8310d486d7df73d12"
  head "https://github.com/TransDecoder/TransDecoder.git"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "05955821eb2ace7c8ef8bfd5a36ff35321355e35f3b432235c08ce29b4cd7411" => :sierra
    sha256 "b1c90616d9d140b4e313c1ea831d435965cad5d6a680083a3f00b70f0cb1efe1" => :el_capitan
    sha256 "4a812936c775a6c2edca2c8e1930c143596bfe4c2817e9a71b0bcc7d45af38ec" => :yosemite
    sha256 "d71073ab9daca3ff95cbba7c241e1066ff7b17a62ce180744e26692e1062caa9" => :x86_64_linux
  end

  depends_on "cd-hit"

  resource "URI::Escape" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/URI-1.71.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/E/ET/ETHER/URI-1.71.tar.gz"
    sha256 "9c8eca0d7f39e74bbc14706293e653b699238eeb1a7690cc9c136fb8c2644115"
  end

  def install
    inreplace "TransDecoder.Predict",
      "= &check_program('cd-hit-est');",
      "= '#{Formula["cd-hit"].opt_bin}/cd-hit-est';"

    rm "Makefile"
    rm_rf "transdecoder_plugins" # Remove the cd-hit source code
    rm_rf Dir["TransDecoder.lrgTests/{.git,README.md}"]

    prefix.install_metafiles
    libexec.install Dir["*"]

    ["sample_data", "TransDecoder.lrgTests", "util"].each do |f|
      pkgshare.install_symlink libexec/f
    end

    resource("URI::Escape").stage do
      system "perl", "Makefile.PL", "LIB=#{libexec}/PerlLib", "PREFIX=#{libexec}/vendor"
      system "make", "install"
    end

    bin.write_exec_script Dir[libexec/"*"].select { |f| File.file?(f) && File.executable?(f) }
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/TransDecoder.LongOrfs 2>&1", 1)
    assert_match "USAGE", shell_output("#{bin}/TransDecoder.Predict 2>&1", 1)
    cp_r "#{libexec}/.", testpath
    cd "sample_data" do
      system "make", "test"
    end
  end
end
