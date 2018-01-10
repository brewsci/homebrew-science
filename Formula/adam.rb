class Adam < Formula
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark2_2.11/0.22.0/adam-distribution-spark2_2.11-0.22.0-bin.tar.gz"
  sha256 "31624954eb473f2ec24354af7e6303a47887cf2ca4076bb71f54618aef59e15b"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "beb29a0f019c560cd50fc88181a718af15a0ada2d4edcb6ee9cd7ee445cf5351" => :sierra
    sha256 "b2eff2fa6902d8b88f897916211bb430b38357547eff380b7c6052602674f458" => :el_capitan
    sha256 "b2eff2fa6902d8b88f897916211bb430b38357547eff380b7c6052602674f458" => :yosemite
    sha256 "05fa62cf881fbd25653a38d7c73aa497101f86f0317ddb75151bfe512a2fc662" => :x86_64_linux
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
