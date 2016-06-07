class TransrateTools < Formula
  desc "Aggregate BAM read mapping information"
  homepage "https://github.com/Blahah/transrate-tools"
  # tag "bioinformatics"

  # Use git to get submodules
  # url "https://github.com/Blahah/transrate-tools/archive/v1.0.0.beta4.tar.gz"
  # sha256 "d6edd8f06dc59beed9c70dc1ef16a4dd42675f85b81751b5e51716c1a4cbc4e8"
  url "https://github.com/Blahah/transrate-tools.git",
    :revision => "08c4c5b02c946ed3ab286e492f972600538a3692",
    :tag => "v1.0.0.beta4"
  version "1.0.0.beta4"

  head "https://github.com/Blahah/transrate-tools.git"

  bottle do
    cellar :any
    sha256 "47947f01e619d29edd4576c45a1114e0b454cf747295a5fae9e8cf87ee5d0dbe" => :yosemite
    sha256 "c19b295330ce5c4c2d7db7900ee74ee0fdddb3ac41ca263e618afee4727ff3dc" => :mavericks
    sha256 "ad076deade726b03813b300510467e385b6fce5f00a4577a5104bf164bef7407" => :mountain_lion
    sha256 "432fe5d1a508221db5cfc5396768aae4fed19d2b7e09b679d798702731145987" => :x86_64_linux
  end

  depends_on "cmake" => :build

  # Vendored: depends_on "bamtools"

  def install
    mkdir "bamtools/build" do
      system "cmake", "..", *std_cmake_args
      system "make"
    end

    # Fix error: Could NOT find ZLIB (missing: ZLIB_LIBRARY)
    # If anyone reading this knows why this fix is necessary,
    # please contact @sjackman
    args = std_cmake_args
    args << "-DZLIB_LIBRARY=/usr/lib/libz.dylib" if OS.mac?

    system "cmake", ".", *args
    system "make"

    bin.install "src/bam-read"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/bam-read", 1)
  end
end
