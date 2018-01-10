class LumpySv < Formula
  desc "General probabilistic framework for structural variant discovery"
  homepage "https://github.com/arq5x/lumpy-sv"
  url "https://github.com/arq5x/lumpy-sv/archive/0.2.13.tar.gz"
  sha256 "3672b86ef0190ebe520648a6140077ee9f15b0549cb233dca18036e63bbf6375"
  # doi "10.1186/gb-2014-15-6-r84"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "712abc8add7fb030e08ed367b0c752ba5c33631e047926346f2e79653e84e9cb" => :sierra
    sha256 "344c9e24aa37ddd01a012a30aad17fa92780739e926ff5e65b1bcb5ac45d87c5" => :el_capitan
    sha256 "225cb0dd852ebb98579f0c72f7f4b48e295e06e9182d4f32f5d05048ba42c15d" => :yosemite
    sha256 "76ba5f96d725ea33703702852c6ced455eb0f160bb75240afbbdf20a17a3d642" => :x86_64_linux
  end

  depends_on "samblaster" => :optional
  depends_on "samtools" => :optional
  depends_on "sambamba" => :optional
  depends_on "bwa" => :optional

  resource "bamkit" do
    url "https://github.com/cc2qe/bamkit.git",
        :revision => "148ef1d3ac05ef7a033ed5ef42749c21956718d6"
  end

  def install
    ENV.deparallelize
    inreplace "scripts/lumpyexpress.config" do |s|
      s.change_make_var! "LUMPY_HOME", "#{HOMEBREW_PREFIX}/share/lumpy-sv"
    end
    system "make"
    bin.install "bin/lumpy"
    bin.install Dir["scripts/lumpyexpress*"]
    (pkgshare/"scripts").install Dir["scripts/*"]
    resource("bamkit").stage pkgshare/"scripts/bamkit"
  end

  test do
    system "#{bin}/lumpy 2>&1 |grep -q structural"
    system "#{bin}/lumpyexpress 2>&1 |grep -q lumpyexpress"
  end
end
