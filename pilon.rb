class Pilon < Formula
  desc "Improve draft assemblies and find variation"
  homepage "https://github.com/broadinstitute/pilon/wiki"
  url "https://github.com/broadinstitute/pilon/releases/download/v1.22/pilon-1.22.jar"
  sha256 "ff738f3bbb964237f6b2cf69243ebf9a21cb7f4edf10bbdcc66fa4ebaad5d13d"
  head "https://github.com/broadinstitute/pilon.git"
  # doi "10.1371/journal.pone.0112963"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ac1fe1cc994db48d83c09f117bd36bd6b6b085aabcd3be7de74a630a3ff1edc" => :sierra
    sha256 "4ac1fe1cc994db48d83c09f117bd36bd6b6b085aabcd3be7de74a630a3ff1edc" => :el_capitan
    sha256 "4ac1fe1cc994db48d83c09f117bd36bd6b6b085aabcd3be7de74a630a3ff1edc" => :yosemite
    sha256 "83323099250c3cfa5a0274c1c8854522cda4fd8488b65cd36c050ca656fcca32" => :x86_64_linux
  end

  depends_on :java

  def install
    opts = "-mx1000m -ms20m"
    jar = "pilon-#{version}.jar"
    prefix.install jar
    bin.write_jar_script prefix/jar, "pilon", opts
  end

  test do
    assert_match "Usage", shell_output("#{bin}/pilon --help")
  end
end
