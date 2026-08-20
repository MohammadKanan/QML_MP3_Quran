#include "XLSParser.h"
#include <QJsonArray>
#include <QJsonObject>
using namespace QXlsx;

XLSParser::XLSParser(QObject *parent)
    : QObject{parent}
{initialize();}

void XLSParser::initialize()
{
    if( createAndOpenDB()){
        fetchDocsFromFile();
        //getCountryList();
        //getCitiesPerCountry("Saudia Arabia");
        //this->doctors_In_Location("Morocco" , "Casablanca");
    }
}
void XLSParser::fetchDocsFromFile()
{
    //Cell* cell = xlsxR.cellAt(4,1); // get cell pointer.
    Document xlsxR(excelPath);
    if (xlsxR.load()) // load excel file
    {
        QString Number , Name , MakiMadani , AyatCount;

        for (int i=2 ; i < 116 ; i++){
            const auto A = QString("A%1").arg(i);
            Number = xlsxR.read(A).toString().trimmed();
            const auto B = QString("B%1").arg(i);
            Name = xlsxR.read(B).toString().trimmed();
            const auto C = QString("C%1").arg(i);
            MakiMadani = xlsxR.read(C).toString().trimmed();
            const auto D = QString("D%1").arg(i);
            AyatCount = xlsxR.read(D).toString().trimmed();
            const auto E = QString("E%1").arg(i);
            const auto wordCount = xlsxR.read(E).toString().trimmed();
            const auto F = QString("F%1").arg(i);
            const auto letterCount = xlsxR.read(F).toString().trimmed();
            //const auto Country_ID = xlsxR.read(QString("F%1").arg(i)).toString();
            //qDebug() << Number << "/" << Name << "/" << AyatCount;
            // Query!!

            databaseQuery.prepare(QString("INSERT INTO quranTable( SoraIndex , Name , VerstCount , MakiMadani) VALUES(:index , :name , :count , :whereis);"));
            databaseQuery.bindValue(":index" , Number);
            databaseQuery.bindValue(":name" , Name);
            databaseQuery.bindValue(":count" , AyatCount);
            databaseQuery.bindValue(":whereis" , MakiMadani);
            if(!databaseQuery.exec()){
                qDebug() << "Failed to insert record! .." << databaseQuery.lastQuery();
                qDebug() << databaseQuery.lastError();
            }

        }
    }else
        qDebug() << "Could not load excel file .....";
}

bool XLSParser::createAndOpenDB()
{
    // Create memory DB
    QSqlDatabase quranDB = QSqlDatabase::addDatabase("QSQLITE");
    quranDB.setDatabaseName(":memory:");
    if(!quranDB.open()){
        qDebug() << "Could not create DB";
    }
    databaseQuery = QSqlQuery(quranDB);
    databaseQuery.prepare("CREATE TABLE IF NOT EXISTS quranTable (id integer not null primary key, SoraIndex integer , Name text , Verstcount integer , MakiMadani text);");
    if (!databaseQuery.exec()){
        qDebug() << "Could not create table!" << databaseQuery.lastError();
        return false;
    }
    return true;
    //
}

QJsonArray XLSParser::getListOfQuran()
{
    QJsonArray array;
    QSqlQuery aQuery(_quranDB);
    aQuery.prepare("Select SoraIndex, Name , Verstcount , MakiMadani from quranTable;");
    if(!aQuery.exec()){
        qDebug() << " getListOfQuran / Failed to fetch Table! .." << aQuery.lastQuery();
        qDebug() << aQuery.lastError();
    }
    while (aQuery.next()) {
        const int soraIndex = aQuery.value(0).toInt();
        const QString name = aQuery.value(1).toString();
        const int Verstcount = aQuery.value(2).toInt();
        const QString makiMadani  = aQuery.value(3).toString();
        //qDebug() << name << "/" << Verstcount;

        if(!name.isEmpty()){

            QJsonObject obj;
            obj.insert("name" , name);
            obj.insert("index" , soraIndex);
            obj.insert("count" , Verstcount);
            obj.insert("location" , makiMadani);
            array.append(obj);
        }
    }
    return array;
}

