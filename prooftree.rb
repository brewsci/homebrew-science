class Prooftree < Formula
  desc "Proof tree visualization program"
  homepage "http://askra.de/software/prooftree"
  url "http://askra.de/software/prooftree/releases/prooftree-0.12.tar.gz"
  sha256 "952ca2efec290808ffac093abe7ac9b10ae471f5d8cd9ef66db3dd02a431d723"

  bottle do
    cellar :any
    sha256 "ee96affa121c39fde28f30477e8807cf65796dabaf27b80a94b16b9453de4765" => :el_capitan
    sha256 "cbfc1f0b9e9ed01dbcc8e9e086a5a12fb443f3a4286f308692e6f60428ba3b9e" => :yosemite
    sha256 "c9abab545ce0acd7092f38cbef4df8fd9c6711dd2abc15d33f3d503cad2b0581" => :mavericks
  end

  depends_on :x11
  depends_on "lablgtk"
  depends_on "ocaml" => :build

  # Fixes the compilation with OCaml 4.02.x+; reported upstream on 2015/11/18
  patch :DATA

  def install
    system "./configure", "--prefix", prefix
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/prooftree", "--help"
  end
end

__END__
diff --git a/input.ml b/input.ml
index 934943c..aeee520 100644
--- a/input.ml
+++ b/input.ml
@@ -27,7 +27,7 @@

 (*****************************************************************************
  *****************************************************************************)
-(** {2 Communition Protocol with Proof General}
+(**{| {2 Communition Protocol with Proof General}

     The communication protocol with Proof General is almost one-way
     only: Proof General sends display messages to Prooftree and
@@ -207,7 +207,7 @@
     }
     }
     }
-*)
+|}*)

 (** Version number of the communication protocol described and
     implemented by this module.
@@ -438,7 +438,7 @@ let parse_configure com_buf =
   Scanf.bscanf com_buf
     " for \"%s@\" and protocol version %d" configure_prooftree

-(******************************************************************************
+(*{|***************************************************************************
  ******************************************************************************
  * current-goals state %d current-sequent %s {cheated|not-cheated} \
  * {new-layer|current-layer}
@@ -449,7 +449,7 @@ let parse_configure com_buf =
  * <data-current-sequent>\n\
  * <data-additional-ids>\n\
  * <data-existentials>\n
- *)
+ |}*)

 (** {3 Current-goals command parser} *)

@@ -624,13 +624,13 @@ let parse_switch_goal com_buf =



-(******************************************************************************
+(*{|***************************************************************************
  * branch-finished state %d {cheated|not-cheated} \
  * proof-name-bytes %d command-bytes %d existential-bytes %d\n\
  * <data-proof-name>\n\
  * <data-command>\n\
  * <data-existentials>\n
-*)
+ |}*)

 (** {3 Branch-finished command parser} *)
