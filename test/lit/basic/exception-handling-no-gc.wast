;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.

;; Test that we do not emit an invalid (ref exn) when exceptions are enabled
;; but not GC. GC is required for us to be non-nullable.

;; RUN: wasm-opt %s --enable-reference-types --enable-exception-handling --disable-gc --roundtrip -S -o - | filecheck %s

(module
 ;; CHECK:      (func $test (result exnref)
 ;; CHECK-NEXT:  (block $label$1 (result exnref)
 ;; CHECK-NEXT:   (try_table (catch_all_ref $label$1)
 ;; CHECK-NEXT:    (unreachable)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $test (result exnref)
  ;; It is valid to write (ref exn) in Binaryen IR, and internally that is how
  ;; we represent things, but when we emit the binary we emit a nullable type,
  ;; so after the roundtrip we are less refined.
  (block $label (result (ref exn))
   (try_table (catch_all_ref $label)
    (unreachable)
   )
  )
 )
)

