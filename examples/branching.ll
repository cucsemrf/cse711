; ModuleID = 'main'
source_filename = "main"

@.str = private constant [4 x i8] c"%d\0A\00"

declare i32 @printf(i8*, ...)

define internal void @echo(i64 %toPrint) {
entry:
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i64 %toPrint)
  ret void
}

define internal void @main() {
entry:
  %0 = call i64 @baz(i64 1)
  ret void
}

declare i64 @printi(i64)

define internal i64 @foo() {
entry:
  %0 = call i64 @printi(i64 1)
  ret i64 0
}

define internal i64 @bar() {
entry:
  %0 = call i64 @printi(i64 0)
  ret i64 1
}

define internal i64 @baz(i64 %x1) {
entry:
  %x = alloca i64, addrspace(1)
  store i64 %x1, i64 addrspace(1)* %x
  %0 = icmp ne i64 1, 0
  br i1 %0, label %then, label %else
  ret i64 0

then:                                             ; preds = %entry
  %2 = call i64 @foo()
  br label %ifcont

else:                                             ; preds = %entry
  %3 = call i64 @bar()
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %iftmp = phi i64 [ %2, %then ], [ %3, %else ]
  ret i64 %iftmp
}