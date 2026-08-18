cmake_minimum_required(VERSION 3.16)

project(Quran VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick LinguistTools Sql Gui Multimedia Network GuiPrivate GuiPrivate)

qt_standard_project_setup(REQUIRES 6.5)
set(TS_FILES Quran_ar_PS.ts)
# Content of downloaded design from Figma to Qt or similar
if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/importedcontent/CMakeLists.txt")
    add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/importedcontent)
endif()

qt_add_executable(appQuran
    main.cpp
    #${TS_FILES}
)

set_target_properties(appQuran PROPERTIES
   QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")

qt_add_qml_module(appQuran
    URI Quran
    QML_FILES
        Main.qml
        RESOURCES Res.qrc
        QML_FILES Player.qml
        QML_FILES qml/Custom/CustomButton.qml qml/Custom/CustomCheckBox.qml qml/Custom/CustomImageButton.qml
        SOURCES cpp/QuranModel.cpp cpp/QuranModel.h cpp/XLSParser.cpp cpp/XLSParser.h
        SOURCES cpp/Downloader.h cpp/Downloader.cpp
        #RESOURCES     qml/Icons/pause.png qml/Icons/playVideo.png qml/Icons/stop_Video.png qml/Icons/volume.png qml/Icons/volume_off.png qml/Icons/volume_on.png
        #RESOURCES qml/Icons/back.png qml/Icons/download.png qml/Icons/folder.png qml/Icons/images.jpg qml/Icons/pause.png qml/Icons/playVideo.png qml/Icons/stop_Video.png qml/Icons/volume.png qml/Icons/volume_off.png qml/Icons/volume_on.png
)
qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQuran PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQuran
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)
if(ANDROID)
   set_property(TARGET appQuran APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
  set_property(TARGET appQuran PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
  set(android_openssl_SOURCE_DIR , "/media/mohammad/Virtualization/Projects/QML_MP3_Quran/openssl-3.3.0/Android")
  set(libs
      ${android_openssl_SOURCE_DIR}/libcrypto.so
      ${android_openssl_SOURCE_DIR}/libcrypto_3.so
      ${android_openssl_SOURCE_DIR}/libssl.so
      ${android_openssl_SOURCE_DIR}/libssl_3.so
  )
set_target_properties(appQuran PROPERTIES  QT_ANDROID_EXTRA_LIBS  "${libs}")

endif()
add_subdirectory(QXlsx/QXlsx)
target_link_libraries(appQuran
    PRIVATE
    QXlsx::QXlsx
    Qt6::Core
    Qt6::Quick
    Qt6::Sql
    Qt6::Multimedia
    Qt6::Network
    ${QT_ANDROID_EXTRA_LIBS}
)

install(TARGETS appQuran
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
