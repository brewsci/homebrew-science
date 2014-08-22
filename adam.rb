require "formula"

class Adam < Formula
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://github.com/bigdatagenomics/adam/releases/download/adam-parent-0.13.0/adam-0.13.0-bin.tar.gz"
  sha1 "5cfe704c768b7be0d493e3052257578f971fc3ec"

  head do
    url "https://github.com/bigdatagenomics/adam.git", :branch => "master"
    depends_on "maven" => :build
  end

  option "without-check", "Disable build-time checking (not recommended)"

  def install
    if build.head?
      system "mvn", "clean", "install",
                    "-DskipAssembly=True",
                    "-DskipTests=" + (build.with?("check") ? "False" : "True")
      system "chmod", "+x", "adam-cli/target/appassembler/bin/adam"
      prefix.install "adam-cli/target/appassembler/repo"
      bin.install "adam-cli/target/appassembler/bin/adam"
    else
      prefix.install "repo"
      bin.install "bin/adam"
    end
  end

  test do
    system "#{bin}/adam buildinfo"
  end
end
