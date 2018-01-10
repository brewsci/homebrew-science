class FastqTools < Formula
  homepage "https://homes.cs.washington.edu/~dcjones/fastq-tools/"
  # tag "bioinformatics"

  url "https://homes.cs.washington.edu/~dcjones/fastq-tools/fastq-tools-0.8.tar.gz"
  sha256 "df069a982e4750dd783b96b4dabd5e70830a6d50270110f80aa30fed00f1e14b"

  bottle do
    cellar :any
    sha256 "fc6d0fd33d43cd37122c1a57ff6378da67eeac2dc38939913547dfd510918854" => :high_sierra
    sha256 "ef3f6cfb458a061dafd325b6f16b6ab6e546084ff246088e085cd07600099970" => :sierra
    sha256 "63edd331dc15dd6d907eb629dbc40d020f3bb3e87d9f96dcb723fb403a724cdf" => :el_capitan
    sha256 "5be8af5fc1d3265c218ab64c04879ebd31de73391b47a1cd8b1799176220d163" => :x86_64_linux
  end

  depends_on "pcre"

  def install
    system "./configure",
      "--disable-debug", "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fastq-grep", "--version"
  end
end
