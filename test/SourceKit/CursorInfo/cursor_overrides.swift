import FooClangModule

protocol Prot {
  func meth()
}

class Cls : S1, Prot {
  override func meth() {}
}

class SubCls : Cls {
  override func meth() {}
}

func goo(x: SubCls) {
  x.meth()
}

public protocol WithAssocType {
  /// Some kind of associated type
  associatedtype AssocType
}

public protocol WithInheritedAssocType : WithAssocType {
  associatedtype AssocType = Int
}

extension P1 {
  func meth() {}
}

extension Prot {
  func meth() {}
}

// REQUIRES: objc_interop
// RUN: %sourcekitd-test -req=cursor -pos=16:7 %s -- -embed-bitcode -I %S/Inputs/cursor-overrides %s | %FileCheck -check-prefix=CHECK1 %s
// CHECK1: source.lang.swift.ref.function.method.instance (12:17-12:23)
// CHECK1: c:@M@cursor_overrides@objc(cs)SubCls(im)meth
// CHECK1: (SubCls) -> () -> ()
// CHECK1:      OVERRIDES BEGIN
// CHECK1-NEXT: c:@M@cursor_overrides@objc(cs)Cls(im)meth
// CHECK1-NEXT: s:16cursor_overrides4ProtP4methyyF
// CHECK1-NEXT: c:objc(cs)S1(im)meth
// CHECK1-NEXT: c:objc(cs)B1(im)meth
// CHECK1-NEXT: c:objc(pl)P1(im)meth
// CHECK1-NEXT: OVERRIDES END

// RUN: %sourcekitd-test -req=cursor -pos=25:20 %s -- -embed-bitcode -I %S/Inputs/cursor-overrides %s | %FileCheck -check-prefix=CHECK2 %s
// CHECK2: s:16cursor_overrides22WithInheritedAssocTypeP0eF0
// CHECK2: OVERRIDES BEGIN
// CHECK2-NEXT: s:16cursor_overrides13WithAssocTypeP0dE0
// CHECK2-NEXT: OVERRIDES END

// RUN: %sourcekitd-test -req=cursor -pos=29:8 %s -- -embed-bitcode -I %S/Inputs/cursor-overrides %s | %FileCheck -check-prefix=CHECK3 %s
// CHECK3: source.lang.swift.decl.function.method.instance (29:8-29:14)
// CHECK3: s:So2P1P16cursor_overridesE4methyyF
// CHECK3:      OVERRIDES BEGIN
// CHECK3-NEXT: c:objc(pl)P1(im)meth
// CHECK3-NEXT: OVERRIDES END

// RUN: %sourcekitd-test -req=cursor -pos=33:8 %s -- -embed-bitcode -I %S/Inputs/cursor-overrides %s | %FileCheck -check-prefix=CHECK4 %s
// CHECK4: source.lang.swift.decl.function.method.instance (33:8-33:14)
// CHECK4: s:16cursor_overrides4ProtPAAE4methyyF
// CHECK4:      OVERRIDES BEGIN
// CHECK4-NEXT: s:16cursor_overrides4ProtP4methyyF
// CHECK4-NEXT: OVERRIDES END
