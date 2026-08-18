#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QLocale>
#include <QTranslator>
#include "cpp/QuranModel.h"
#include "cpp/Downloader.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QuranModel qurModel;
    Downloader* _downloader = new Downloader;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("quranModel", &qurModel);
    engine.rootContext()->setContextProperty("networkDownloader", _downloader);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Quran", "Main");

    return QGuiApplication::exec();
}
