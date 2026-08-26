#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QLocale>
#include <QTranslator>
#include "cpp/QuranModel.h"
#include "cpp/Downloader.h"
#include "cpp/Settings.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    // Settings
    QCoreApplication::setOrganizationName("Hamsa");
    QCoreApplication::setOrganizationDomain("hamsa.com");
    QCoreApplication::setApplicationName("Quran");
    //
    Settings theSettings;
    QuranModel qurModel;
    Downloader* _downloader = new Downloader;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("quranModel", &qurModel);
    engine.rootContext()->setContextProperty("networkDownloader", _downloader);
    engine.rootContext()->setContextProperty("theSettings", &theSettings);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Quran", "Main");

    return QGuiApplication::exec();
}
