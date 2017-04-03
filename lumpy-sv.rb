class LumpySv < Formula
  desc "General probabilistic framework for structural variant discovery"
  homepage "https://github.com/arq5x/lumpy-sv"
  url "https://github.com/arq5x/lumpy-sv/archive/0.2.13.tar.gz"
  sha256 "3672b86ef0190ebe520648a6140077ee9f15b0549cb233dca18036e63bbf6375"
  # doi "10.1186/gb-2014-15-6-r84"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1f571d7d8757b2daadb579f6de1c450b55ccded198ff839eb3cb666706c93113" => :el_capitan
    sha256 "47909b1938634e7649094958d04ca3e9253d62ec75d75cdb4ed02a54d9777d6f" => :yosemite
    sha256 "2c7698685d3a58d1c594bc1b318b18f864af2c7d5969440c5a03978107761d04" => :mavericks
    sha256 "eb106f5abe0c4940959cf6746e55ccad69c138d61dcf31aef933776cb09a2b4b" => :x86_64_linux
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
