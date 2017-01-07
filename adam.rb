class Adam < Formula
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark2_2.11/0.21.0/adam-distribution-spark2_2.11-0.21.0-bin.tar.gz"
  sha256 "6ab1cd7073a7b39034bdc342aeab2cbb84e89cfb251e7138cd9811f28fc372d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d8abbbff2fb1ea1744a635bc67e620b9456a6315365e4a3970055ac386d5323" => :sierra
    sha256 "9848eeb79990b911693dbe563a26943935a6758f24e520d5d8fe45d7261c8886" => :el_capitan
    sha256 "9848eeb79990b911693dbe563a26943935a6758f24e520d5d8fe45d7261c8886" => :yosemite
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
