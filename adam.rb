class Adam < Formula
  desc "Genomics analysis platform with specialized file formats built using Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://github.com/bigdatagenomics/adam/releases/download/adam-parent-0.13.0/adam-0.13.0-bin.tar.gz"
  sha256 "76ef3054695dbeefb91a29936d05595df6090716e09d189feb3307d3efd47cce"

  bottle do
    cellar :any
    sha256 "f6dc4e21f9264f9110504445a33a099076c75052d28551ad520377a8356915e4" => :yosemite
    sha256 "5bdd0363cdc6d5dd1656a0c576de3e6ccc76f8b81ac74f6d519236d022703988" => :mavericks
    sha256 "bdcc97aca83ff7a56ac771a038fde3832786d39cb01e4d4fe828a9a6bf4700c2" => :mountain_lion
  end

  head do
    url "https://github.com/bigdatagenomics/adam.git"
    depends_on "maven" => :build
  end

  option "without-check", "Disable build-time checking (not recommended)"

  def install
    if build.head?
      system "mvn", "clean", "install",
                    "-DskipAssembly=True",
                    "-DskipTests=" + (build.with?("check") ? "False" : "True")
      chmod 0755, "adam-cli/target/appassembler/bin/adam"
      prefix.install "adam-cli/target/appassembler/repo"
      bin.install "adam-cli/target/appassembler/bin/adam"
    else
      prefix.install "repo"
      bin.install "bin/adam"
    end
  end

  test do
    system "#{bin}/adam", "buildinfo"
  end
end
