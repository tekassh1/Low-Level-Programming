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
include src/CMakeFiles/filter_lib.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include src/CMakeFiles/filter_lib.dir/compiler_depend.make

# Include the progress variables for this target.
include src/CMakeFiles/filter_lib.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/filter_lib.dir/flags.make

src/CMakeFiles/filter_lib.dir/filter/filter.c.o: src/CMakeFiles/filter_lib.dir/flags.make
src/CMakeFiles/filter_lib.dir/filter/filter.c.o: ../src/filter/filter.c
src/CMakeFiles/filter_lib.dir/filter/filter.c.o: src/CMakeFiles/filter_lib.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tekashi/Lab5/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object src/CMakeFiles/filter_lib.dir/filter/filter.c.o"
	cd /home/tekashi/Lab5/build/src && /usr/bin/gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT src/CMakeFiles/filter_lib.dir/filter/filter.c.o -MF CMakeFiles/filter_lib.dir/filter/filter.c.o.d -o CMakeFiles/filter_lib.dir/filter/filter.c.o -c /home/tekashi/Lab5/src/filter/filter.c

src/CMakeFiles/filter_lib.dir/filter/filter.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/filter_lib.dir/filter/filter.c.i"
	cd /home/tekashi/Lab5/build/src && /usr/bin/gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/tekashi/Lab5/src/filter/filter.c > CMakeFiles/filter_lib.dir/filter/filter.c.i

src/CMakeFiles/filter_lib.dir/filter/filter.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/filter_lib.dir/filter/filter.c.s"
	cd /home/tekashi/Lab5/build/src && /usr/bin/gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/tekashi/Lab5/src/filter/filter.c -o CMakeFiles/filter_lib.dir/filter/filter.c.s

# Object files for target filter_lib
filter_lib_OBJECTS = \
"CMakeFiles/filter_lib.dir/filter/filter.c.o"

# External object files for target filter_lib
filter_lib_EXTERNAL_OBJECTS =

src/libfilter_lib.a: src/CMakeFiles/filter_lib.dir/filter/filter.c.o
src/libfilter_lib.a: src/CMakeFiles/filter_lib.dir/build.make
src/libfilter_lib.a: src/CMakeFiles/filter_lib.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/tekashi/Lab5/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C static library libfilter_lib.a"
	cd /home/tekashi/Lab5/build/src && $(CMAKE_COMMAND) -P CMakeFiles/filter_lib.dir/cmake_clean_target.cmake
	cd /home/tekashi/Lab5/build/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/filter_lib.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/CMakeFiles/filter_lib.dir/build: src/libfilter_lib.a
.PHONY : src/CMakeFiles/filter_lib.dir/build

src/CMakeFiles/filter_lib.dir/clean:
	cd /home/tekashi/Lab5/build/src && $(CMAKE_COMMAND) -P CMakeFiles/filter_lib.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/filter_lib.dir/clean

src/CMakeFiles/filter_lib.dir/depend:
	cd /home/tekashi/Lab5/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/tekashi/Lab5 /home/tekashi/Lab5/src /home/tekashi/Lab5/build /home/tekashi/Lab5/build/src /home/tekashi/Lab5/build/src/CMakeFiles/filter_lib.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/CMakeFiles/filter_lib.dir/depend

