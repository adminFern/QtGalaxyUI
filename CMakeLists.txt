cmake_minimum_required(VERSION 3.16)

project(QtGalaxyUI VERSION 0.1 LANGUAGES CXX)

#开启Qt的信号与槽等特性
set(CMAKE_AUTOMOC ON)
#开启资源文件
set(CMAKE_AUTORCC ON)
# 设置C++标准为C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


#设置程序名称
set(ITEMS_NAME example)
#设置程序输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)
#设置头文件目录
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.5)


# #资源文件
set(RES_PATHS
   favicon.ico
   Controls/Font/FluentIcons.ttf
   Controls/qmldir
  # rcs.qrc

)
#资源文件
set(RES_qml
   example/Main.qml
)

#收集到的文件列表将存储在ALL_SOURCE_FILES变量中
set(SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")
file(GLOB_RECURSE ALL_SOURCE_FILES
    "${SOURCE_DIR}/*.cpp"
    "${SOURCE_DIR}/*.h"
)
#然后将这些相对路径形式的文件名添加到sources_files列表中
foreach (filepath ${ALL_SOURCE_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND SOURCES_FILES ${filename})
endforeach (filepath)


# 查找指定目录（${QML_SEARCH_DIR}）下所有以.qml结尾的文件，并将结果存储在变量ALL_QML_FILES中
set(QML_SEARCH_DIR "${CMAKE_CURRENT_SOURCE_DIR}/Controls")
file(GLOB_RECURSE ALL_QML_FILES "${QML_SEARCH_DIR}/*.qml")
# 遍历查找到的所有QML文件路径列表
foreach (filepath ${ALL_QML_FILES})
    # 将文件路径中的${CMAKE_CURRENT_SOURCE_DIR}/部分替换为空字符串，得到相对路径形式的文件名
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    # 将处理后的相对路径文件名添加到QML_FILES列表中
    list(APPEND QML_FILES ${filename})
endforeach (filepath)


qt_add_executable(${ITEMS_NAME}
    main.cpp
    ico.rc
)

qt_add_qml_module(${ITEMS_NAME}
    URI GalaxyUI
    VERSION 1.0
    QML_FILES ${RES_qml} ${QML_FILES}
    SOURCES ${SOURCES_FILES}
    RESOURCES ${RES_PATHS}
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(${ITEMS_NAME} PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQtGalaxyUI
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(${ITEMS_NAME}
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS ${ITEMS_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
