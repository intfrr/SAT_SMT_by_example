; checked with Z3 and MK85

(set-logic QF_BV)
(set-info :smt-lib-version 2.0)

(declare-fun v () (_ BitVec 32))
(declare-fun out () (_ BitVec 32))

; (((v) - 0x01010101UL) & ~(v) & 0x80808080UL)
(assert (= out (bvand (bvsub v #x01010101) (bvnot v) #x80808080)))

(declare-fun HasZeroByte () Bool)

(assert (= HasZeroByte 
	(or 
		(= (bvand v #xff000000) #x00000000)
		(= (bvand v #x00ff0000) #x00000000)
		(= (bvand v #x0000ff00) #x00000000)
		(= (bvand v #x000000ff) #x00000000)
	)
	)
)

; at least one zero byte must be present
(assert HasZeroByte)

; out==0
(assert (= out #x00000000))

; must be unsat (no counterexample)
(check-sat)

