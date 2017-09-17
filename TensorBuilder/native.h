#ifndef NATIVE_H
#define NATIVE_H

#include <QObject>
#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include <QProcess>
#include <QMutex>


class Native : public QObject
{
	Q_OBJECT
public:
	explicit Native(QObject *parent = nullptr);
	
	void init(QGuiApplication&, QQmlApplicationEngine&);
	
	Q_INVOKABLE void run_python(QString);
	Q_INVOKABLE bool is_python_running();
	Q_INVOKABLE QString get_python_stream();
	

private:
	QProcess* python_process;
    QString app_path, python_temp_path;
    QMutex python_stream_mutex, python_running_mutex;
    QString python_stream;
	bool python_running;
	
	static void python_thread();
	
	static Native* current;
	
signals:
	
public slots:
};

#endif // NATIVE_H
