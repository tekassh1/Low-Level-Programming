# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/tekashi/Lab5

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/tekashi/Lab5/build

# Include any dependencies generated for this target.
include src/CMakeFiles/app_lib.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include src/CMakeFiles/app_lib.dir/compiler_depend.make

# Include the progress variables for this target.
include src/CMakeFiles/app_lib.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/app_lib.dir/flags.make

src/CMakeFiles/app_lib.dir/check.c.o: src/CMakeFiles/app_lib.dir/flags.make
src/CMakeFiles/app_lib.dir/check.c.o: ../src/check.c
src/CMakeFiles/app_lib.dir/check.c.o: src/CMakeFiles/app_lib.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tekashi/Lab5/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object src/CMakeFiles/app_lib.dir/check.c.o"
	cd /home/tekashi/Lab5/build/src && $(CMAKE_COMMAND) -E __run_co_compile --tidy="/usr/bin/clang-tidy;-header-filter=/home/tekashi/Lab5;-checks=clang-analyzer-*,llvm-include-order,misc-*,performance-*,readability-redundant-*,readability-simplify-*,readability-const-*,readability-implicit-bool-*,readability-identifier-naming,readability-inconsistent-declaration-parameter-name,readability-misleading-indentation,readability-named-parameter,bugprone-argument-comment,bugprone-assert-side-effect,bugprone-bad-signal-to-kill-thread,bugprone-bool-pointer-implicit-conversion,bugprone-branch-clone,bugprone-copy-constructor-init,bugprone-dangling-handle,bugprone-dynamic-static-initializers,bugprone-exception-escape,bugprone-fold-init-type,bugprone-forward-declaration-namespace,bugprone-forwarding-reference-overload,bugprone-inaccurate-erase,bugprone-incorrect-roundings,bugprone-infinite-loop,bugprone-integer-division,bugprone-lambda-function-name,bugprone-macro-parentheses,bugprone-macro-repeated-side-effects,bugprone-misplaced-operator-in-strlen-in-alloc,bugprone-misplaced-pointer-arithmetic-in-alloc,bugprone-misplaced-widening-cast,bugprone-move-forwarding-reference,bugprone-multiple-statement-macro,bugprone-narrowing-conversions,bugprone-no-escape,bugprone-not-null-terminated-result,bugprone-parent-virtual-call,bugprone-posix-return,bugprone-signed-char-misuse,bugprone-sizeof-container,bugprone-sizeof-expression,bugprone-spuriously-wake-up-functions,bugprone-string-constructor,bugprone-string-integer-assignment,bugprone-string-literal-with-embedded-nul,bugprone-suspicious-enum-usage,bugprone-suspicious-include,bugprone-suspicious-memset-usage,bugprone-suspicious-missing-comma,bugprone-suspicious-semicolon,bugprone-suspicious-string-compare,bugprone-swapped-arguments,bugprone-terminating-continue,bugprone-throw-keyword-missing,bugprone-too-small-loop-variable,bugprone-undefined-memory-manipulation,bugprone-undelegated-constructor,bugprone-unhandled-self-assignment,bugprone-unused-raii,bugprone-unused-return-value,bugprone-use-after-move,bugprone-virtual-near-miss;-warnings-as-errors=*;--extra-arg-before=--driver-mode=gcc" --source=/home/tekashi/Lab5/src/check.c -- /usr/bin/gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT src/CMakeFiles/app_lib.dir/check.c.o -MF CMakeFiles/app_lib.dir/check.c.o.d -o CMakeFiles/app_lib.dir/check.c.o -c /home/tekashi/Lab5/src/check.c

src/CMakeFiles/app_lib.dir/check.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/app_lib.dir/check.c.i"
	cd /home/tekashi/Lab5/build/src && /usr/bin/gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/tekashi/Lab5/src/check.c > CMakeFiles/app_lib.dir/check.c.i

src/CMakeFiles/app_lib.dir/check.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/app_lib.dir/check.c.s"
	cd /home/tekashi/Lab5/build/src && /usr/bin/gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/tekashi/Lab5/src/check.c -o CMakeFiles/app_lib.dir/check.c.s

src/CMakeFiles/app_lib.dir/lib.c.o: src/CMakeFiles/app_lib.dir/flags.make
src/CMakeFiles/app_lib.dir/lib.c.o: ../src/lib.c
src/CMakeFiles/app_lib.dir/lib.c.o: src/CMakeFiles/app_lib.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tekashi/Lab5/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object src/CMakeFiles/app_lib.dir/lib.c.o"
	cd /home/tekashi/Lab5/build/src && $(CMAKE_COMMAND) -E __run_co_compile --tidy="/usr/bin/clang-tidy;-header-filter=/home/tekashi/Lab5;-checks=clang-analyzer-*,llvm-include-order,misc-*,performance-*,readability-redundant-*,readability-simplify-*,readability-const-*,readability-implicit-bool-*,readability-identifier-naming,readability-inconsistent-declaration-parameter-name,readability-misleading-indentation,readability-named-parameter,bugprone-argument-comment,bugprone-assert-side-effect,bugprone-bad-signal-to-kill-thread,bugprone-bool-pointer-implicit-conversion,bugprone-branch-clone,bugprone-copy-constructor-init,bugprone-dangling-handle,bugprone-dynamic-static-initializers,bugprone-exception-escape,bugprone-fold-init-type,bugprone-forward-declaration-namespace,bugprone-forwarding-reference-overload,bugprone-inaccurate-erase,bugprone-incorrect-roundings,bugprone-infinite-loop,bugprone-integer-division,bugprone-lambda-function-name,bugprone-macro-parentheses,bugprone-macro-repeated-side-effects,bugprone-misplaced-operator-in-strlen-in-alloc,bugprone-misplaced-pointer-arithmetic-in-alloc,bugprone-misplaced-widening-cast,bugprone-move-forwarding-reference,bugprone-multiple-statement-macro,bugprone-narrowing-conversions,bugprone-no-escape,bugprone-not-null-terminated-result,bugprone-parent-virtual-call,bugprone-posix-return,bugprone-signed-char-misuse,bugprone-sizeof-container,bugprone-sizeof-expression,bugprone-spuriously-wake-up-functions,bugprone-string-constructor,bugprone-string-integer-assignment,bugprone-string-literal-with-embedded-nul,bugprone-suspicious-enum-usage,bugprone-suspicious-include,bugprone-suspicious-memset-usage,bugprone-suspicious-missing-comma,bugprone-suspicious-semicolon,bugprone-suspicious-string-compare,bugprone-swapped-arguments,bugprone-terminating-continue,bugprone-throw-keyword-missing,bugprone-too-small-loop-variable,bugprone-undefined-memory-manipulation,bugprone-undelegated-constructor,bugprone-unhandled-self-assignment,bugprone-unused-raii,bugprone-unused-return-value,bugprone-use-after-move,bugprone-virtual-near-miss;-warnings-as-errors=*;--extra-arg-before=--driver-mode=gcc" --source=/home/tekashi/Lab5/src/lib.c -- /usr/bin/gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT src/CMakeFiles/app_lib.dir/lib.c.o -MF CMakeFiles/app_lib.dir/lib.c.o.d -o CMakeFiles/app_lib.dir/lib.c.o -c /home/tekashi/Lab5/src/lib.c

src/CMakeFiles/app_lib.dir/lib.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/app_lib.dir/lib.c.i"
	cd /home/tekashi/Lab5/build/src && /usr/bin/gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/tekashi/Lab5/src/lib.c > CMakeFiles/app_lib.dir/lib.c.i

src/CMakeFiles/app_lib.dir/lib.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/app_lib.dir/lib.c.s"
	cd /home/tekashi/Lab5/build/src && /usr/bin/gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/tekashi/Lab5/src/lib.c -o CMakeFiles/app_lib.dir/lib.c.s

# Object files for target app_lib
app_lib_OBJECTS = \
"CMakeFiles/app_lib.dir/check.c.o" \
"CMakeFiles/app_lib.dir/lib.c.o"

# External object files for target app_lib
app_lib_EXTERNAL_OBJECTS =

src/libapp_lib.a: src/CMakeFiles/app_lib.dir/check.c.o
src/libapp_lib.a: src/CMakeFiles/app_lib.dir/lib.c.o
src/libapp_lib.a: src/CMakeFiles/app_lib.dir/build.make
src/libapp_lib.a: src/CMakeFiles/app_lib.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/tekashi/Lab5/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking C static library libapp_lib.a"
	cd /home/tekashi/Lab5/build/src && $(CMAKE_COMMAND) -P CMakeFiles/app_lib.dir/cmake_clean_target.cmake
	cd /home/tekashi/Lab5/build/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/app_lib.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/CMakeFiles/app_lib.dir/build: src/libapp_lib.a
.PHONY : src/CMakeFiles/app_lib.dir/build

src/CMakeFiles/app_lib.dir/clean:
	cd /home/tekashi/Lab5/build/src && $(CMAKE_COMMAND) -P CMakeFiles/app_lib.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/app_lib.dir/clean

src/CMakeFiles/app_lib.dir/depend:
	cd /home/tekashi/Lab5/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/tekashi/Lab5 /home/tekashi/Lab5/src /home/tekashi/Lab5/build /home/tekashi/Lab5/build/src /home/tekashi/Lab5/build/src/CMakeFiles/app_lib.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/CMakeFiles/app_lib.dir/depend
