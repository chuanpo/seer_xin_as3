package org.taomee.net
{
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketErrorEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.tmf.HeadInfo;
   import org.taomee.tmf.TMF;

   public class SocketImpl extends Socket
   {
      public static const PACKAGE_MAX:uint = 8388608;

      public var port:int;

      private var _headLength:uint = 17;

      private var _headInfo:HeadInfo;

      private var _dataLen:uint;

      private var _isGetHead:Boolean = true;

      private var _packageLen:uint;

      public var session:ByteArray;

      private var _version:String = "1";

      public var userID:uint = 0;

      public var ip:String;

      private var outTime:int = 0;

      private var _result:uint = 0;

      public function SocketImpl(sv:String = "1")
      {
         super();
         _version = sv;
         _headLength = SocketVersion.getHeadLength(sv);
      }

      private function XOREncrypt(data:ByteArray, key:ByteArray):ByteArray
      {
         var encryptedData:ByteArray = new ByteArray();
         var keyLength:uint = key.length;
         var keyPosition:uint = 0;

         data.position = 0;
         while (data.bytesAvailable > 0)
         {
            encryptedData.writeByte(data.readByte() ^ key.readByte());
            keyPosition++;
            if (keyPosition >= keyLength)
            {
               key.position = 0;
               keyPosition = 0;
            }
         }
         return encryptedData;
      }

      private function XORDecrypt(data:ByteArray, key:ByteArray):ByteArray
      {
         return XOREncrypt(data, key);
      }

      public function send(cmdID:uint, args:Array):uint
      {
         var i:* = undefined;
         var data:ByteArray = new ByteArray();
         for each (i in args)
         {
            if (i is String)
            {
               data.writeUTFBytes(i);
            }
            else if (i is ByteArray)
            {
               data.writeBytes(i);
            }
            else
            {
               data.writeUnsignedInt(i);
            }
         }
         if (cmdID > 1000)
         {
            ++_result;
         }
         var length:uint = data.length + _headLength;
         writeUnsignedInt(length);
         writeUTFBytes(_version);
         writeUnsignedInt(cmdID);
         writeUnsignedInt(userID);
         writeInt(_result);
         if (_version == SocketVersion.SV_2)
         {
            writeInt(0);
         }

         // 创建 key
         var key:ByteArray = new ByteArray();

         key.writeUnsignedInt(cmdID);
         key.writeUnsignedInt(userID);
         key.writeUTFBytes("your_secret_key");
         key.position = 0;

         // 加密数据
         var encryptedData:ByteArray = XOREncrypt(data, key);
         writeBytes(encryptedData);
         flush();
         trace(">>Socket[" + ip + ":" + port.toString() + "][cmdID:" + cmdID + "]", CmdName.getName(cmdID), "[data length:" + data.length + "]");
         return _result;
      }

      public function get version():String
      {
         return _version;
      }

      private function onData(e:Event):void
      {
         var data:ByteArray = null;
         var tmfClass:Class = null;
         trace("socket onData handler....................");
         outTime = 0;
         while (bytesAvailable > 0)
         {
            if (_isGetHead)
            {
               if (bytesAvailable >= _headLength)
               {
                  _packageLen = readUnsignedInt();
                  if (_packageLen < _headLength || _packageLen > PACKAGE_MAX)
                  {
                     SocketDispatcher.getInstance().dispatchEvent(new SocketErrorEvent(SocketErrorEvent.ERROR, null));
                     readBytes(new ByteArray());
                     return;
                  }
                  _headInfo = new HeadInfo(this, _version);
                  trace("<<Socket[" + ip + ":" + port.toString() + "][cmdID:" + _headInfo.cmdID + "]", CmdName.getName(_headInfo.cmdID));
                  if (_version == SocketVersion.SV_1)
                  {
                     if (_headInfo.result != 0)
                     {
                        SocketDispatcher.getInstance().dispatchEvent(new SocketErrorEvent(SocketErrorEvent.ERROR, _headInfo));
                        continue;
                     }
                  }
                  else if (_version == SocketVersion.SV_2)
                  {
                     if (_headInfo.error != 0)
                     {
                        SocketDispatcher.getInstance().dispatchEvent(new SocketErrorEvent(SocketErrorEvent.ERROR, _headInfo));
                        continue;
                     }
                  }
                  _dataLen = _packageLen - _headLength;
                  if (_dataLen == 0)
                  {
                     SocketDispatcher.getInstance().dispatchEvent(new SocketEvent(_headInfo.cmdID.toString(), _headInfo, null));
                     continue;
                  }
                  _isGetHead = false;
               }
            }
            else if (bytesAvailable >= _dataLen)
            {
               data = new ByteArray();
               readBytes(data, 0, _dataLen);

               // 创建 key
               var key:ByteArray = new ByteArray();
               key.writeUTFBytes("1");
               key.position = 0;

               // 解密数据
               // t;
               // var decryptedData:ByteArray = XORDecrypt(data, key);
               // 解密数据
              // var hexString:String = "0000003c0000000000000006000000040000003c79642e736a636d632e636e00000000003e8a00000001000000030000003c6d332e6374796d632e636e00000000005e3b00000000000000020000003c62322e736a636d632e636e00000000003e8a00000001000000010000003c3132372e302e302e3100000000000000232700000000000000050000003c6d332e6374796d632e636e00000000005e3b00000000000000060000003c79642e736a636d632e636e00000000003e8a0000000100000000";
               //var decryptedData:ByteArray = hexToByteArray(hexString);
               var decryptedData:ByteArray =  data;

               tmfClass = TMF.getClass(_headInfo.cmdID);
               SocketDispatcher.getInstance().dispatchEvent(new SocketEvent(_headInfo.cmdID.toString(), _headInfo, new tmfClass(decryptedData)));
               _isGetHead = true;
            }
            if (outTime > 200 || !connected)
            {
               break;
            }
            ++outTime;
         }
      }
      private function byteArrayToHex(byteArray:ByteArray):String
      {
         var hexString:String = "";
         byteArray.position = 0;
         while (byteArray.bytesAvailable > 0)
         {
            var byte:uint = byteArray.readUnsignedByte();
            hexString += (byte < 16 ? "0" : "") + byte.toString(16);
         }
         return hexString;
      }
      override public function connect(host:String, port:int):void
      {
         super.connect(host, port);
         _result = 0;
         trace("连接SOCKET：：：：", host, port);
         addEvent();
      }

      private function removeEvent():void
      {
         removeEventListener(ProgressEvent.SOCKET_DATA, onData);
      }

      private function addEvent():void
      {
         addEventListener(ProgressEvent.SOCKET_DATA, onData);
      }

      override public function close():void
      {
         removeEvent();
         if (connected)
         {
            super.close();
         }
         ip = "";
         port = -1;
         _result = 0;
      }
      private function hexToByteArray(hex:String):ByteArray
      {
         var byteArray:ByteArray = new ByteArray();
         for (var i:uint = 0; i < hex.length; i += 2)
         {
            var byte:uint = parseInt(hex.substr(i, 2), 16);
            byteArray.writeByte(byte);
         }
         byteArray.position = 0;
         return byteArray;
      }
   }
}