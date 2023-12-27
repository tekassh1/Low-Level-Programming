enable_language(ASM_NASM)

include_directories(${PROJECT_SOURCE_DIR}/include)

file(GLOB_RECURSE image_lib_sources CONFIGURE_DEPENDS image/*.c)
file(GLOB_RECURSE filter_lib_sources CONFIGURE_DEPENDS filter/*.c)
file(GLOB_RECURSE asm_lib_sources CONFIGURE_DEPENDS asm/*.asm asm/*.c)
file(GLOB_RECURSE util_lib_sources CONFIGURE_DEPENDS util/*.c)

add_library(image_lib STATIC ${image_lib_sources})
add_library(filter_lib STATIC ${filter_lib_sources})
add_library(util_lib STATIC ${util_lib_sources})
add_library(asm_lib STATIC ${asm_lib_sources})

add_executable(app main.c)
target_link_libraries(app PRIVATE image_lib)
target_link_libraries(app PRIVATE filter_lib)
target_link_libraries(app PRIVATE util_lib)
target_link_libraries(app PRIVATE asm_lib)