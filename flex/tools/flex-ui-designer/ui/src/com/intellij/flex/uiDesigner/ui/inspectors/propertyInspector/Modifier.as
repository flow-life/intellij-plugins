package com.intellij.flex.uiDesigner.ui.inspectors.propertyInspector {
import com.intellij.flex.uiDesigner.Document;
import com.intellij.flex.uiDesigner.DocumentFactoryManager;
import com.intellij.flex.uiDesigner.ElementAddress;
import com.intellij.flex.uiDesigner.PlatformDataKeys;
import com.intellij.flex.uiDesigner.ServerMethod;
import com.intellij.flex.uiDesigner.SocketManager;
import com.intellij.flex.uiDesigner.io.Amf3Types;

import flash.net.Socket;

import org.jetbrains.actionSystem.DataContext;

public class Modifier {
  private var socketManager:SocketManager;

  public function Modifier(socketManager:SocketManager) {
    this.socketManager = socketManager;
  }

  public function applyBoolean(description:Object, value:Boolean, dataContext:DataContext):void {
    var document:Document = PlatformDataKeys.DOCUMENT.getData(dataContext);
    var element:Object = PlatformDataKeys.COMPONENT.getData(dataContext);
    var elementAddress:ElementAddress = DocumentFactoryManager.getInstance().findElementAddress(element, document);
    if (elementAddress == null) {
      return;
    }

    var propertyName:String = description.name;
    element[propertyName ] = value;

    var socket:Socket = socketManager.getSocket();
    socket.writeByte(ServerMethod.SET_PROPERTY);
    socket.writeShort(document.module.project.id);
    socket.writeShort(elementAddress.factory.id);
    socket.writeInt(elementAddress.id);

    socket.writeUTF(propertyName);
    socket.writeByte(value ? Amf3Types.TRUE : Amf3Types.FALSE);
    socket.flush();
  }

  public function applyString(description:Object, value:String, dataContext:DataContext):void {
    var document:Document = PlatformDataKeys.DOCUMENT.getData(dataContext);
    var element:Object = PlatformDataKeys.COMPONENT.getData(dataContext);
    var elementAddress:ElementAddress = DocumentFactoryManager.getInstance().findElementAddress(element, document);
    if (elementAddress == null) {
      return;
    }

    var propertyName:String = description.name;
    element[propertyName ] = value;

    var socket:Socket = socketManager.getSocket();
    socket.writeByte(ServerMethod.SET_PROPERTY);
    socket.writeShort(document.module.project.id);
    socket.writeShort(elementAddress.factory.id);
    socket.writeInt(elementAddress.id);

    socket.writeUTF(propertyName);
    socket.writeByte(Amf3Types.STRING);
    socket.writeUTF(value);
    socket.flush();
  }
}
}