# Similar to configure_file, but also expands variables
# that are set at generate time, like generator expressions.
function (carla_two_step_configure_file DESTINATION SOURCE)
  carla_message ("Configuring file ${DESTINATION}")
  # Configure-time step; evaluate variables:
  configure_file (${SOURCE} ${DESTINATION} @ONLY)
  # Generate-time step; evaluate generator expressions:
  file (GENERATE OUTPUT ${DESTINATION} INPUT ${DESTINATION})
endfunction ()



# message wrapper for normal messages.
function (carla_message)
  message (STATUS "CARLA: " ${ARGN})
endfunction ()



# message() wrapper for warnings.
function (carla_warning)
  message (WARNING ${ARGN})
endfunction ()



# message() wrapper for errors.
function (carla_error)
  message (FATAL_ERROR ${ARGN})
endfunction ()



function (carla_get_option_docs OUT_VAR)
  get_property (DOCS GLOBAL PROPERTY CARLA_OPTION_DOCS)
  set (${OUT_VAR} ${DOCS})
  return (PROPAGATE ${OUT_VAR})
endfunction ()

macro (carla_option NAME DESCRIPTION VALUE)
  option (${NAME} ${DESCRIPTION} ${VALUE})
  carla_message ("(option) ${NAME} : ${${NAME}}")
  get_property (DOCS GLOBAL PROPERTY CARLA_OPTION_DOCS)
  string (
    APPEND
    DOCS
    "- ${NAME}\n"
    "\t- Description: ${DESCRIPTION}\n"
    "\t- Default: ${VALUE}\n"
  )
  set_property (GLOBAL PROPERTY CARLA_OPTION_DOCS ${DOCS})
endmacro ()



macro (carla_string_option NAME DESCRIPTION VALUE)
  set (${NAME} "${VALUE}")
  carla_message ("(option) ${NAME} : \"${${NAME}}\"")
  get_property (DOCS GLOBAL PROPERTY CARLA_OPTION_DOCS)
  string (
    APPEND
    DOCS
    "- ${NAME}\n"
    "\t- Description: ${DESCRIPTION}\n"
    "\t- Default: \"${VALUE}\"\n"
  )
  set_property (GLOBAL PROPERTY CARLA_OPTION_DOCS ${DOCS})
endmacro ()



# If, for some reason, CARLA is configured with CMake<3.5, this is necessary:
if (${CMAKE_VERSION} VERSION_LESS 3.5)
  include (CMakeParseArguments)
endif ()

function (carla_add_target_docs)
  set (OPTIONS)
  set (ONE_VAL_ARGS NAME TYPE DOCS_BRIEF)
  set (MULTI_VAL_ARGS)
  cmake_parse_arguments (
    ARG
    "${OPTIONS}"
    "${ONE_VAL_ARGS}"
    "${MULTI_VAL_ARGS}"
    ${ARGN}
  )
  get_property (DOCS GLOBAL PROPERTY CARLA_TARGET_DOCS)
  string (APPEND DOCS "- ${ARG_NAME}\n")
  if (NOT ${ARG_TYPE} STREQUAL "")
    string (APPEND DOCS "\t- Type: ${ARG_TYPE}\n")
  endif ()
  if (NOT ${ARG_DOCS_BRIEF} STREQUAL "")
    string (APPEND DOCS "\t- Description: ${ARG_DOCS_BRIEF}\n")
  endif ()
  set_property (GLOBAL PROPERTY CARLA_TARGET_DOCS ${DOCS})
endfunction ()



function (carla_get_target_docs OUT_VAR)
  get_property (DOCS GLOBAL PROPERTY CARLA_TARGET_DOCS)
  set (${OUT_VAR} ${DOCS})
  return (PROPAGATE ${OUT_VAR})
endfunction ()



function (carla_add_library NAME DESCRIPTION)
  carla_add_target_docs (
    NAME ${NAME}
    TYPE Library
    DOCS_BRIEF ${DESCRIPTION}
  )
  add_library (${NAME} ${ARGN})
endfunction ()



function (carla_add_executable NAME DESCRIPTION)
  carla_add_target_docs (
    NAME ${NAME}
    TYPE Executable
    DOCS_BRIEF ${DESCRIPTION}
  )
  add_executable (${NAME} ${ARGN})
endfunction ()



function (carla_add_custom_target NAME DESCRIPTION)
  carla_add_target_docs (
    NAME ${NAME}
    TYPE CustomTarget
    DOCS_BRIEF ${DESCRIPTION}
  )
  add_custom_target (${NAME} ${ARGN})
endfunction ()



function (carla_install_common NAME HEADERS)
  install (
    TARGETS
      ${NAME}
  )
  install (
    FILES
      ${HEADERS}
    DESTINATION
      include/${NAME}
  )
endfunction ()




carla_add_target_docs (
  NAME clean
  TYPE Builtin
  DOCS_BRIEF "Removes all build directories and files."
)
