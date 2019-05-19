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
@i = external global double
@f = external global i32
@s = external global i1
@b = external global i8*
define i32 @main(i32, i8**) {
%osargs = alloca i8**
store i8** %1, i8*** %osargs
%i = alloca i32
%f = alloca double
%s = alloca i8*
%b = alloca i1
%.3 = fadd double 1.1, 0.0
store double %.3, double* @i
%.4 = add i32 0, 1
store i32 %.4, i32* %i
%.5 = load i32, i32* %i
%.6 = load i32, i32* %i
%.7 = icmp ne i32 %.5, %.6
store i1 %.7, i1* %b
%.8 = load double, double* %f
%.9 = load double, double* %f
%.10 = fcmp oeq double %.8, %.9
store i1 %.10, i1* %b
%.11 = load i1, i1* %b
%.12 = load i1, i1* %b
%.13 = or i1 %.11, %.12
store i1 %.13, i1* %b
%.14 = load i1, i1* %b
%.15 = load i1, i1* %b
%.16 = icmp eq i1 %.14, %.15
store i1 %.16, i1* %b
%.17 = load i32, i32* %i
%.18 = load i32, i32* %i
%.19 = add i32 %.17, %.18
store i32 %.19, i32* %i
%.20 = load i32, i32* %i
%.21 = load i32, i32* %i
%.22 = sdiv i32 %.20, %.21
store i32 %.22, i32* %i
%.23 = load double, double* %f
%.24 = load double, double* %f
%.25 = fmul double %.23, %.24
store double %.25, double* %f
%.26 = load double, double* %f
%.27 = load double, double* %f
%.28 = fsub double %.26, %.27
store double %.28, double* %f
%.29 = load i32, i32* %i
%.30 = load i32, i32* %i
%.31 = srem i32 %.29, %.30
%.32 = load i32, i32* %i
%.33 = load i32, i32* %i
%.34 = srem i32 %.32, %.33
%.35 = load i32, i32* %i
%.36 = mul i32 %.34, %.35
%.37 = load i32, i32* %i
%.38 = srem i32 %.36, %.37
%.39 = add i32 %.31, %.38
%.40 = load i32, i32* %i
%.41 = load i32, i32* %i
%.42 = srem i32 %.40, %.41
%.43 = load i32, i32* %i
%.44 = sdiv i32 %.42, %.43
%.45 = load i32, i32* %i
%.46 = srem i32 %.44, %.45
%.47 = sub i32 %.39, %.46
store i32 %.47, i32* %i
%.48 = load double, double* %f
%.49 = fmul double -1, %.48
fadd double 0, %.48
store double %.49, double* %f
%.50 = load double, double* %f
%.51 = fadd double 0, %.50
store double %.51, double* %f
%.52 = load i8*, i8** %s
call i32 @print_string(i8* %.52)
%.53 = add i32 0, 1
%.54 = load i8**, i8*** %osargs
%.55 = getelementptr i8*, i8** %.54, i32 %.53
%.56 = load i8*, i8** %.55%.57 = call i32 @atoi(i8* %.56)
store i32 %.57, i32* %i
ret i32 0
}
