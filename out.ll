@.int_format = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@.float_format = private unnamed_addr constant [7 x i8] c"%.08f\0A\00"
@.bool_true = private unnamed_addr constant [6 x i8] c"true\0A\00"
@.bool_false = private unnamed_addr constant [7 x i8] c"false\0A\00"
@.null_str = external global i8

declare i32 @printf(i8* , ...)

define i32 @print_int(i32 %num) {
    %1 = getelementptr [4 x i8], [4 x i8]* @.int_format, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %1, i32 %num)
    ret i32 0
}

define i32 @print_float(double %num) {
    %1 = getelementptr [7 x i8], [7 x i8]* @.float_format, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %1, double %num)
    ret i32 0
}

define i32 @print_string(i8* %str) {
    call i32 (i8*, ...) @printf(i8* %str)
    ret i32 0
}

define i32 @print_bool(i1 %num) {
    br i1 %num, label %true, label %end

    true:
    %1 = getelementptr [6 x i8], [6 x i8]* @.bool_true, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %1)
    br label %end

    false:
    %3 = getelementptr [7 x i8], [7 x i8]* @.bool_false, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %3)
    br label %end

    end:
    ret i32 0
}

declare i32 @atoi(i8*)
@ia = external global i32
@ib = external global i32
@ic = external global i32
@id = external global i32
@ie = external global i32
@fa = external global double
@fb = external global double
@fc = external global double
@fd = external global double
@fe = external global double
@ba = external global i1
@bb = external global i1
@bc = external global i1
@bd = external global i1
@sa = external global i8*
@sb = external global i8*
@sc = external global i8*
define i32 @fca() {
ret i32 0
}
define i32 @fcb() {
%fafcb = alloca i32
%.1 = add i32 0, 132
store i32 %.1, i32* %fafcb
%.2 = load i32, i32* %fafcb
ret i32 %.2
ret i32 0
}
define double @fcd() {
%.1 = fadd double 0.1e1, 0.0
%.2 = fadd double 0.007, 0.0
%.3 = fadd double %.1, %.2
ret double %.3
ret double 0.0
}
define i8* @fce() {
%strfce = alloca i8*
%.1 = load i8*, i8** %strfce
ret i8* %.1
ret i8* @.null_str
}
define i1 @fcf() {
%bafcf = alloca i1
%.1 = load i1, i1* %bafcf
ret i1 %.1
ret i1 0
}
define i32 @fcg(i32, double) {
%iafcg = alloca i32
store i32 %0, i32* %iafcg
%fafcg = alloca double
store double %1, double* %fafcg
%.3 = call double @fcd()
%.4 = load double, double* %fafcg
%.5 = fcmp ogt double %.3, %.4
br i1 %.5, label %l_0, label %l_1

l_0:
%.6 = call i32 @fca()
%.7 = load i32, i32* %iafcg
ret i32 %.7
br label %l_2

l_1:
br label %l_2

l_2:
%.8 = call i32 @fcb()
ret i32 %.8
ret i32 0
}
define double @fch(i32, double, i8*) {
%iafch = alloca i32
store i32 %0, i32* %iafch
%fafch = alloca double
store double %1, double* %fafch
%safch = alloca i8*
store i8* %2, i8** %safch
%.4 = call i32 @fcb()
%.5 = call double @fcd()
%.6 = call i32 @fcg(i32 %.4, double %.5)
%.7 = load i8*, i8** %safch
call i32 @print_string(i8* %.7)
%.8 = load i1, i1* @bb
br i1 %.8, label %l_3, label %l_4

l_3:
%.9 = load i32, i32* @ia
%.10 = load i32, i32* @ib
%.11 = add i32 %.9, %.10
store i32 %.11, i32* %iafch
%.12 = load double, double* @fa
store double %.12, double* %fafch
%.13 = load double, double* %fafch
store double %.13, double* @fb
%.14 = load i32, i32* %iafch
store i32 %.14, i32* @id
br label %l_5

l_4:
br label %l_5

l_5:
%.15 = fadd double 0.01, 0.0
ret double %.15
ret double 0.0
}
define double @fci(i32, i32, double, double, i8*) {
%iafci = alloca i32
store i32 %0, i32* %iafci
%ibfci = alloca i32
store i32 %1, i32* %ibfci
%fafci = alloca double
store double %2, double* %fafci
%fbfci = alloca double
store double %3, double* %fbfci
%safci = alloca i8*
store i8* %4, i8** %safci
%.6 = call i32 @fcb()
%.7 = call double @fcd()
%.8 = call i32 @fcg(i32 %.6, double %.7)
%.9 = call double @fcd()
%.10 = call i8* @fce()
%.11 = call double @fch(i32 %.8, double %.9, i8* %.10)
%.12 = load i32, i32* %ibfci
%.13 = add i32 0, 12
%.14 = add i32 %.12, %.13
%.15 = load i32, i32* @ic
%.16 = add i32 %.14, %.15
%.17 = call i32 @fcb()
%.18 = add i32 %.16, %.17
store i32 %.18, i32* %iafci
%.19 = call i1 @fcf()
br i1 %.19, label %l_6, label %l_7

l_6:
%.20 = load i8*, i8** %safci
call i32 @print_string(i8* %.20)
%.21 = load i32, i32* @ia
%.22 = load double, double* @fa
%.23 = load i8*, i8** @sa
%.24 = call double @fch(i32 %.21, double %.22, i8* %.23)
ret double %.24
br label %l_8

l_7:
%.25 = load double, double* @fa
%.26 = load double, double* %fbfci
%.27 = fmul double %.25, %.26
%.28 = call double @fcd()
%.29 = fadd double %.27, %.28
store double %.29, double* %fafci
%.30 = call double @fcd()
ret double %.30
br label %l_8

l_8:
ret double 0.0
}
define i32 @fcj(i32, i32, double, double, i1) {
%iafcj = alloca i32
store i32 %0, i32* %iafcj
%ibfcj = alloca i32
store i32 %1, i32* %ibfcj
%fafcj = alloca double
store double %2, double* %fafcj
%fbfcj = alloca double
store double %3, double* %fbfcj
%bafcj = alloca i1
store i1 %4, i1* %bafcj
%fcjia = alloca i32
%fcjib = alloca i32
%.6 = load i32, i32* @ia
%.7 = load i32, i32* @ib
%.8 = add i32 %.6, %.7
%.9 = load i32, i32* @ic
%.10 = load i32, i32* @id
%.11 = mul i32 %.9, %.10
%.12 = load i32, i32* @ie
%.13 = srem i32 %.11, %.12
%.14 = sub i32 %.8, %.13
store i32 %.14, i32* %fcjia
%.15 = load i32, i32* %fcjia
%.16 = load i32, i32* %fcjia
%.17 = call i32 @fcb()
%.18 = load i32, i32* %fcjib
%.19 = call i32 @fcb()
%.20 = load double, double* @fb
%.21 = load i8*, i8** @sa
%.22 = call double @fch(i32 %.19, double %.20, i8* %.21)
%.23 = load double, double* @fd
%.24 = load i8*, i8** @sb
%.25 = call double @fci(i32 %.17, i32 %.18, double %.22, double %.23, i8* %.24)
%.26 = call i32 @fcg(i32 %.16, double %.25)
%.27 = icmp sgt i32 %.15, %.26
br i1 %.27, label %l_9, label %l_10

l_9:
%.28 = load i1, i1* @ba
br i1 %.28, label %l_12, label %l_13

l_12:
%.29 = fadd double 0.01, 0.0
store double %.29, double* @fc
br label %l_14

l_13:
%.30 = load double, double* @fc
%.31 = load double, double* @fe
%.32 = fadd double %.30, %.31
store double %.32, double* @fc
%.33 = load i1, i1* %bafcj
br i1 %.33, label %l_15, label %l_16

l_15:
br label %l_18

l_18:
%.34 = call i1 @fcf()
br i1 %.34, label %l_19, label %l_20

l_19:%.35 = load i32, i32* %fcjia
%.36 = call i32 @fcb()
%.37 = add i32 0, 12
%.38 = sdiv i32 %.36, %.37
%.39 = add i32 %.35, %.38
%.40 = load i32, i32* @ia
%.41 = load i32, i32* %iafcj
%.42 = add i32 %.40, %.41
%.43 = load double, double* @fa
%.44 = call i32 @fcg(i32 %.42, double %.43)
%.45 = add i32 %.39, %.44
%.46 = load i32, i32* %ibfcj
%.47 = sub i32 %.45, %.46
store i32 %.47, i32* %fcjib
%.48 = load double, double* %fafcj
store double %.48, double* %fbfcj
br label %l_18

l_20:br label %l_17

l_16:
br label %l_17

l_17:
br label %l_14

l_14:
br label %l_11

l_10:
br label %l_11

l_11:
br label %l_21

l_21:
%.49 = load i1, i1* @bb
br i1 %.49, label %l_22, label %l_23

l_22:%.50 = load i1, i1* @bc
br i1 %.50, label %l_24, label %l_25

l_24:
%.51 = load i1, i1* @bd
%.52 = load i1, i1* @ba
%.53 = or i1 %.51, %.52
store i1 %.53, i1* @bd
%.54 = load i1, i1* @ba
%.55 = call i1 @fcf()
%.56 = or i1 %.54, %.55
%.57 = load i1, i1* @bd
%.58 = load i1, i1* @bc
%.59 = icmp eq i1 0, %.58%.60 = or i1 %.57, %.59
%.61 = and i1 %.56, %.60
store i1 %.61, i1* @bd
br label %l_26

l_25:
br label %l_26

l_26:
br label %l_21

l_23:%.62 = add i32 0, 101
%.63 = mul i32 -1, %.62
add i32 0, %.62
ret i32 %.63
ret i32 0
}
define i32 @main(i32, i8**) {
%osargs = alloca i8**
store i8** %1, i8*** %osargs
%mia = alloca i32
%mib = alloca i32
%.3 = add i32 0, 1
store i32 %.3, i32* @ia
%.4 = add i32 0, 1
store i32 %.4, i32* @ib
%.5 = add i32 0, 1
store i32 %.5, i32* @ic
%.6 = add i32 0, 1
store i32 %.6, i32* @id
%.7 = add i32 0, 1
store i32 %.7, i32* @ie
%.8 = fadd double 0.1, 0.0
store double %.8, double* @fa
%.9 = fadd double 0.1, 0.0
store double %.9, double* @fb
%.10 = fadd double 0.1, 0.0
store double %.10, double* @fc
%.11 = fadd double 0.1, 0.0
store double %.11, double* @fd
%.12 = fadd double 0.1, 0.0
store double %.12, double* @fe
br label %l_27

l_27:
%.13 = load i32, i32* @ia
%.14 = load i32, i32* @ib
%.15 = icmp sgt i32 %.13, %.14
%.16 = call i1 @fcf()
%.17 = or i1 %.15, %.16
br i1 %.17, label %l_28, label %l_29

l_28:%.18 = call i32 @fcb()
%.19 = call i32 @fcb()
%.20 = load double, double* @fe
%.21 = call i32 @fcg(i32 %.19, double %.20)
%.22 = load i32, i32* %mia
%.23 = call i32 @fcb()
%.24 = call double @fcd()
%.25 = call i32 @fcg(i32 %.23, double %.24)
%.26 = add i32 0, 123
%.27 = load i32, i32* @ia
%.28 = call double @fcd()
%.29 = call i8* @fce()
%.30 = call double @fch(i32 %.27, double %.28, i8* %.29)
%.31 = call double @fcd()
%.32 = load i8*, i8** @sc
%.33 = call double @fci(i32 %.25, i32 %.26, double %.30, double %.31, i8* %.32)
%.34 = call double @fcd()
%.35 = call i1 @fcf()
%.36 = call i32 @fcj(i32 %.21, i32 %.22, double %.33, double %.34, i1 %.35)
%.37 = icmp sgt i32 %.18, %.36
br i1 %.37, label %l_30, label %l_31

l_30:
%.38 = add i32 0, 12
%.39 = load i32, i32* @ia
%.40 = load double, double* @fa
%.41 = fadd double 0.1e12, 0.0
%.42 = load i1, i1* @ba
%.43 = call i32 @fcj(i32 %.38, i32 %.39, double %.40, double %.41, i1 %.42)
store i32 %.43, i32* %mib
br label %l_32

l_31:
%.44 = load i32, i32* @ia
%.45 = call i32 @fcb()
%.46 = add i32 %.44, %.45
store i32 %.46, i32* %mib
br label %l_32

l_32:
br label %l_27

l_29:%.47 = load i32, i32* %mib
%.48 = add i32 0, 123
%.49 = add i32 0, 456
%.50 = call i32 @fcb()
%.51 = add i32 %.49, %.50
%.52 = call double @fcd()
%.53 = fadd double 123.321, 0.0
%.54 = fadd double %.52, %.53
%.55 = call i32 @fcg(i32 %.51, double %.54)
%.56 = add i32 %.48, %.55
%.57 = load i32, i32* @ia
%.58 = load i32, i32* @ib
%.59 = add i32 %.57, %.58
%.60 = load i32, i32* @ic
%.61 = add i32 0, 12
%.62 = sdiv i32 %.60, %.61
%.63 = sub i32 %.59, %.62
%.64 = load i32, i32* @id
%.65 = load i32, i32* @ie
%.66 = mul i32 %.64, %.65
%.67 = call i32 @fcb()
%.68 = load double, double* @fa
%.69 = call i32 @fcg(i32 %.67, double %.68)
%.70 = srem i32 %.66, %.69
%.71 = add i32 %.63, %.70
%.72 = load i32, i32* @ia
%.73 = load i32, i32* @ib
%.74 = add i32 %.72, %.73
%.75 = add i32 0, 123
%.76 = load double, double* @fa
%.77 = call double @fcd()
%.78 = fadd double 0.1e12, 0.0
%.79 = fdiv double %.77, %.78
%.80 = fsub double %.76, %.79
%.81 = call double @fcd()
%.82 = call i8* @fce()
%.83 = call double @fci(i32 %.74, i32 %.75, double %.80, double %.81, i8* %.82)
%.84 = add i32 0, 312
%.85 = add i32 0, 12
%.86 = add i32 %.84, %.85
%.87 = call double @fcd()
%.88 = fadd double 0.1e23, 0.0
%.89 = fadd double %.87, %.88
%.90 = call i8* @fce()
%.91 = call double @fch(i32 %.86, double %.89, i8* %.90)
%.92 = call i1 @fcf()
%.93 = load i1, i1* @ba
%.94 = or i1 %.92, %.93
%.95 = load i1, i1* @bb
%.96 = and i1 %.94, %.95
%.97 = call i32 @fcj(i32 %.56, i32 %.71, double %.83, double %.91, i1 %.96)
%.98 = add i32 %.47, %.97
store i32 %.98, i32* %mia
ret i32 0
}
