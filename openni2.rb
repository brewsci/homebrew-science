require "formula"

class Openni2 < Formula
  homepage "http://structure.io/openni"
  url "https://github.com/occipital/OpenNI2/archive/2.2-beta2.tar.gz"
  version "2.2.0.33"
  sha1 "8c9a57de7224cd0a0a4c4bb03a7637bd179df34c"
  head "https://github.com/occipital/OpenNI2.git"

  option :universal
  option "with-docs", "Build documentation using javadoc (might fail with Java 1.8)"

  depends_on :python
  depends_on "libusb"
  depends_on "doxygen" => :build if build.with? "docs"

  patch :DATA if build.without? "docs"

  stable do
    patch do
      url "https://github.com/occipital/OpenNI2/pull/18.patch"
      sha1 "4beb04a31a64677618801f0e95141807592442ef"
    end
  end

  def install
    ENV.universal_binary if build.universal?

    system "make", "all"
    system "make", "doc" if build.with? "docs"
    mkdir "out"
    arch = (MacOS.version <= :leopard && !build.universal?) ? "x86" :"x64"
    system "python", "Packaging/Harvest.py", "out", arch

    cd "out"

    (lib+"ni2").install Dir["Redist/*"]
    (include+"ni2").install Dir["Include/*"]
    (share+"openni2/tools").install Dir["Tools/*"]
    (share+"openni2/samples").install Dir["Samples/*"]
    doc.install "Documentation" if build.with? "docs"
  end

  def caveats; <<-EOS.undent
    Add the recommended variables to your dotfiles.
     * On Bash, add them to `~/.bash_profile`.
     * On Zsh, add them to `~/.zprofile` instead.

    export OPENNI2_INCLUDE=#{HOMEBREW_PREFIX}/include/ni2
    export OPENNI2_REDIST=#{HOMEBREW_PREFIX}/lib/ni2
    EOS
  end
end

__END__
diff --git a/Packaging/Harvest.py b/Packaging/Harvest.py
index 4ce9ed2..fad7017 100755
--- a/Packaging/Harvest.py
+++ b/Packaging/Harvest.py
@@ -312,7 +312,7 @@ $(OUTPUT_FILE): copy-redist
         
         # Documentation
         docDir = os.path.join(self.outDir, 'Documentation')
-        self.copyDocumentation(docDir)
+        #self.copyDocumentation(docDir)
         
         # Include
         shutil.copytree(os.path.join(rootDir, 'Include'), os.path.join(self.outDir, 'Include'))
