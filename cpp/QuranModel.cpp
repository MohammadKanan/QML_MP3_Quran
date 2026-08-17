#include "QuranModel.h"
#include <QJsonObject>
QuranModel::QuranModel(QObject *parent)
    : QAbstractListModel(parent)
{
    updateModel();
}

int QuranModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return Quran.length();
}

QVariant QuranModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    const auto quranSora = Quran.at(index.row());
    switch (role) {
    case Roles::SORAINDEX:
    {
        QString Index = quranSora.getIndex();
        if(Index.length() == 1)
            Index = QString("00%1").arg(Index);
        else if(Index.length() == 2)
            Index = QString("0%1").arg(Index);
        return Index;
    }
    case Roles::SORANAME:
        return quranSora.getName();
    case Roles::SORAVERSTCOUNT:
        return quranSora.getVerstCount();

        break;
    default:
        break;
    }
    return QVariant();
}
void QuranModel::updateModel()
{
    const QJsonArray allQuranArray = parser.getListOfQuran();
    beginResetModel();
    Quran.clear();
    for (const auto v : allQuranArray){
        const auto soraObj = v.toObject();
        const Sora x(soraObj.value("index").toInt() , soraObj.value("name").toString() , soraObj.value("count").toInt() , soraObj.value("location").toString());
        Quran.append(x);
    }
    endResetModel();
}
