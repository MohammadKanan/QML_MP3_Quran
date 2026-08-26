#include "Settings.h"

Settings::Settings(QObject *parent)
    : QObject{parent}
{
    HamsaSettings = QSharedPointer<QSettings>(new QSettings , &QObject::deleteLater);
    loadSettings();
}

void Settings::saveSettings(const int _reader, const int& _sora , const QString& _soraURL, const double _position)
{
    this->HamsaSettings->setValue("Reader" , _reader);
    this->HamsaSettings->setValue("Sora" , _sora);
    this->HamsaSettings->setValue("url" , _soraURL);
    this->HamsaSettings->setValue("Position" , _position);
}

void Settings::loadSettings()
{
    if(this->HamsaSettings->value("Reader").isValid() )
        this->theReader = this->HamsaSettings->value("Reader").toInt();
    else
        this->theReader = 0;
    // Sora
    if(this->HamsaSettings->value("Sora").isValid())
        this->theSoraIndex = this->HamsaSettings->value("Sora").toInt();
    else
        this->theSoraIndex = 001;
    // Position
    if(this->HamsaSettings->value("Position").isValid())
        this->thePosition = this->HamsaSettings->value("Position").toDouble();
    else
        this->thePosition = 0;
    if(this->HamsaSettings->value("soraURL").isValid())
        this->SoraURL = this->HamsaSettings->value("soraURL").toString();
    else this->SoraURL = "";
}
