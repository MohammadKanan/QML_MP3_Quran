#ifndef QURANMODEL_H
#define QURANMODEL_H

#include <QAbstractListModel>
#include "XLSParser.h"

class Sora {

public:
    Sora (const int index , const QString& name , const int versts , const QString& location){
        SoraName = name;
        Index = index;
        VerstCount = versts;
        Location = location;
    }
    QString getName() const{
        return SoraName;
    }
    const QString getIndex() const{
        return QString("%1").arg(Index);
    }
    const int getVerstCount()const {
        return VerstCount;
    }
    const QString getLocation()const {
        return Location;
    }
private:
    int Index;
    QString SoraName;
    int VerstCount;
    QString Location;

};

class QuranModel : public QAbstractListModel
{
    Q_OBJECT
    enum Roles
    {
        SORAINDEX = Qt::UserRole + 1,
        SORANAME,
        SORAPLACE,
        SORAVERSTCOUNT
    };
public:
    explicit QuranModel(QObject *parent = nullptr);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    void updateModel();
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override
    {
        QHash<int, QByteArray> roles;
        roles[SORAINDEX] = "SoraNumber";
        roles[SORAPLACE] = "SoraLocation";
        roles[SORAVERSTCOUNT] = "SoraCount";
        roles[SORANAME] = "SoraName";
        return roles;
    }
private:
    XLSParser parser;
    QVector<Sora> Quran;
};

#endif // QURANMODEL_H
