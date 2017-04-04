class Adam < Formula
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark2_2.11/0.22.0/adam-distribution-spark2_2.11-0.22.0-bin.tar.gz"
  sha256 "31624954eb473f2ec24354af7e6303a47887cf2ca4076bb71f54618aef59e15b"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d8abbbff2fb1ea1744a635bc67e620b9456a6315365e4a3970055ac386d5323" => :sierra
    sha256 "9848eeb79990b911693dbe563a26943935a6758f24e520d5d8fe45d7261c8886" => :el_capitan
    sha256 "9848eeb79990b911693dbe563a26943935a6758f24e520d5d8fe45d7261c8886" => :yosemite
    sha256 "4bc23de98e36c433c66fcf6df3739e700d2c9e51bb7c028b53b1f1a9dd2b4686" => :x86_64_linux
  end

  head do
    url "https://github.com/bigdatagenomics/adam.git", :shallow => false
    depends_on "maven" => :build
  end

  option "without-test", "Disable build-time checking (not recommended)"

  deprecated_option "without-check" => "without-test"

  depends_on "apache-spark"

  def install
    if build.head?
      system "scripts/move_to_scala_2.11.sh"
      system "scripts/move_to_spark_2.sh"
      system "mvn", "clean", "package",
                    "-DskipTests=" + (build.with?("test") ? "False" : "True")
    end
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/adam-submit", "--version"
  end
end
