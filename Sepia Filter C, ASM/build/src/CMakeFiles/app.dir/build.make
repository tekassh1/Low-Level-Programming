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
include src/CMakeFiles/app.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include src/CMakeFiles/app.dir/compiler_depend.make

# Include the progress variables for this target.
include src/CMakeFiles/app.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/app.dir/flags.make

src/CMakeFiles/app.dir/main.c.o: src/CMakeFiles/app.dir/flags.make
src/CMakeFiles/app.dir/main.c.o: ../src/main.c
src/CMakeFiles/app.dir/main.c.o: src/CMakeFiles/app.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tekashi/Lab5/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object src/CMakeFiles/app.dir/main.c.o"
	cd /home/tekashi/Lab5/build/src && /usr/bin/gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT src/CMakeFiles/app.dir/main.c.o -MF CMakeFiles/app.dir/main.c.o.d -o CMakeFiles/app.dir/main.c.o -c /home/tekashi/Lab5/src/main.c

src/CMakeFiles/app.dir/main.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/app.dir/main.c.i"
	cd /home/tekashi/Lab5/build/src && /usr/bin/gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/tekashi/Lab5/src/main.c > CMakeFiles/app.dir/main.c.i

src/CMakeFiles/app.dir/main.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/app.dir/main.c.s"
	cd /home/tekashi/Lab5/build/src && /usr/bin/gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/tekashi/Lab5/src/main.c -o CMakeFiles/app.dir/main.c.s

# Object files for target app
app_OBJECTS = \
"CMakeFiles/app.dir/main.c.o"

# External object files for target app
app_EXTERNAL_OBJECTS =

src/app: src/CMakeFiles/app.dir/main.c.o
src/app: src/CMakeFiles/app.dir/build.make
src/app: src/libimage_lib.a
src/app: src/libfilter_lib.a
src/app: src/libutil_lib.a
src/app: src/libasm_lib.a
src/app: src/CMakeFiles/app.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/tekashi/Lab5/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable app"
	cd /home/tekashi/Lab5/build/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/app.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/CMakeFiles/app.dir/build: src/app
.PHONY : src/CMakeFiles/app.dir/build

src/CMakeFiles/app.dir/clean:
	cd /home/tekashi/Lab5/build/src && $(CMAKE_COMMAND) -P CMakeFiles/app.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/app.dir/clean

src/CMakeFiles/app.dir/depend:
	cd /home/tekashi/Lab5/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/tekashi/Lab5 /home/tekashi/Lab5/src /home/tekashi/Lab5/build /home/tekashi/Lab5/build/src /home/tekashi/Lab5/build/src/CMakeFiles/app.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/CMakeFiles/app.dir/depend
