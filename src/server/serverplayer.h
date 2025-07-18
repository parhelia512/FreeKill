// SPDX-License-Identifier: GPL-3.0-or-later

#ifndef _SERVERPLAYER_H
#define _SERVERPLAYER_H

#include "core/player.h"

class ClientSocket;
class Router;
class Server;
class Room;
class RoomBase;

class ServerPlayer : public Player {
  Q_OBJECT
public:
  explicit ServerPlayer(RoomBase *room);
  ~ServerPlayer();

  void setSocket(ClientSocket *socket);
  void removeSocket();  // For the running players
  ClientSocket *getSocket() const;

  QString getPeerAddress() const;
  QString getUuid() const;
  void setUuid(QString uuid);

  QString getConnId() const { return connId; }

  Server *getServer() const;
  RoomBase *getRoom() const;
  void setRoom(RoomBase *room);

  void speak(const QString &message);

  void doRequest(const QByteArray &command,
           const QByteArray &jsonData, int timeout = -1, qint64 timestamp = -1);
  void abortRequest();
  QString waitForReply(int timeout);
  void doNotify(const QByteArray &command, const QByteArray &jsonData);

  void prepareForRequest(const QString &command,
                        const QString &data);

  volatile bool alive; // For heartbeat
  void kick();
  void reconnect(ClientSocket *socket);

  bool thinking();
  void setThinking(bool t);

  void startGameTimer();
  void pauseGameTimer();
  void resumeGameTimer();
  int getGameTime();

signals:
  void kicked();

public slots:
  void onNotificationGot(const QString &c, const QString &j);
  void onReplyReady();
  void onStateChanged();
  void onReadyChanged();
  void onDisconnected();

private:
  ClientSocket *socket;   // socket for communicating with client
  Router *router;
  Server *server;
  RoomBase *room;       // Room that player is in, maybe lobby
  bool m_thinking; // 是否在烧条？
  QMutex m_thinking_mutex;

  QString connId;

  QString requestCommand;
  QString requestData;

  QString uuid_str;

  int gameTime = 0; // 在这个房间的有效游戏时长(秒)
  QElapsedTimer gameTimer;
};

#endif // _SERVERPLAYER_H
