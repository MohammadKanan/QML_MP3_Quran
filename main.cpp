#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QLocale>
#include <QTranslator>
#include "cpp/QuranModel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QuranModel qurModel;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("quranModel", &qurModel);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Quran", "Main");

    return QGuiApplication::exec();
}
