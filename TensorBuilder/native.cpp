#include "native.h"
#include <QDebug>
#include <QTextStream>
#include <QFile>
#include <QMutex>
#include <QtConcurrent/QtConcurrent>

Native* Native::current = nullptr;

Native::Native(QObject *parent) : QObject(parent)
{
	this->python_process = nullptr;
	this->python_running = false;
	
	Native::current = this;
}

void Native::init(QGuiApplication& app, QQmlApplicationEngine& engine) {
	engine.rootContext()->setContextProperty("Native", this);
    this->app_path = app.applicationDirPath();
}

bool Native::is_python_running() {
	this->python_running_mutex.lock();
	bool result = this->python_running;
	this->python_running_mutex.unlock();
	return result;
}

QString Native::get_python_stream() {
	this->python_stream_mutex.lock();
	QString result = this->python_stream;
	this->python_stream.clear();
	this->python_stream_mutex.unlock();
	return result;
}

void Native::run_python(QString script) {
	Native::current->python_running_mutex.lock();
    bool running = this->python_running;
    Native::current->python_running_mutex.unlock();
	if (running) return;
	
	this->python_temp_path = Native::current->app_path + "/temp.py";
    qDebug() << "writing: " << this->python_temp_path;
    
    QFile file(this->python_temp_path);
    if (file.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text)){
        QTextStream outText(&file);
        outText << script;
        
        file.close();
    }
    else {
        qDebug() << "!!!WARNING: writing failed!!!";
    }
	
	Native::current->python_running_mutex.lock();
    Native::current->python_running = true;
    Native::current->python_running_mutex.unlock();
	
	QtConcurrent::run(Native::python_thread);
}

void Native::python_thread() {
	QStringList arguments;
    arguments << Native::current->python_temp_path;
	
	QProcess process;
	process.setWorkingDirectory(Native::current->app_path);
	process.start("python", arguments);
	
	QString output;
	while (true) {
		if (process.state() == QProcess::NotRunning) break;
		process.waitForReadyRead();
        Native::current->python_stream_mutex.lock();
		
		QString output;
		output += process.readAllStandardOutput();
		output += process.readAllStandardError();
		output.replace("\r\n", "\n");
        Native::current->python_stream += output;
		// qDebug() << output;
		// qDebug() << error;
        Native::current->python_stream_mutex.unlock();
	}
	
    Native::current->python_running_mutex.lock();
    Native::current->python_running = false;
    Native::current->python_running_mutex.unlock();
}
