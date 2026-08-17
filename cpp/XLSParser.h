#ifndef XLSPARSER_H
#define XLSPARSER_H

#include <QObject>
#include <QtSql/QSqlDatabase>
#include <QJsonArray>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QList>
#include "xlsxdocument.h"
#include "xlsxworkbook.h"
class XLSParser : public QObject
{
    Q_OBJECT
public:
    explicit XLSParser(QObject *parent = nullptr);
    Q_INVOKABLE void fetchDocsFromFile();
    Q_INVOKABLE bool createAndOpenDB();
    Q_INVOKABLE QJsonArray getListOfQuran();
    Q_INVOKABLE void initialize();
private:
    QSqlDatabase _quranDB;
    QSqlQuery databaseQuery;
    QXlsx::Document xlsxR;
    const QString excelPath = QString(":/qml/Resfiles/Quran_Index.xlsx");
    QList<QString> Country_List;
    QList<QString> Cities_Per_Country;
    QList<QString> Doctors_City;

signals:
};

#endif // XLSPARSER_H
