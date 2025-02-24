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
      
      public function send(cmdID:uint, args:Array) : uint
      {
         var i:* = undefined;
         var data:ByteArray = new ByteArray();
         for each(i in args)
         {
            if(i is String)
            {
               data.writeUTFBytes(i);
            }
            else if(i is ByteArray)
            {
               data.writeBytes(i);
            }
            else
            {
               data.writeUnsignedInt(i);
            }
         }
         if(cmdID > 1000)
         {
            ++_result;
         }
         var length:uint = data.length + _headLength;
         writeUnsignedInt(length);
         writeUTFBytes(_version);
         writeUnsignedInt(cmdID);
         writeUnsignedInt(userID);
         writeInt(_result);
         if(_version == SocketVersion.SV_2)
         {
            writeInt(0);
         }
         writeBytes(data);
         flush();
         trace(">>Socket[" + ip + ":" + port.toString() + "][cmdID:" + cmdID + "]",CmdName.getName(cmdID),"[data length:" + data.length + "]");
         return _result;
      }
      
      public function get version() : String
      {
         return _version;
      }
      
      private function onData(e:Event) : void
      {
         var data:ByteArray = null;
         var tmfClass:Class = null;
         trace("socket onData handler....................");
         outTime = 0;
         while(bytesAvailable > 0)
         {
            if(_isGetHead)
            {
               if(bytesAvailable >= _headLength)
               {
                  _packageLen = readUnsignedInt();
                  if(_packageLen < _headLength || _packageLen > PACKAGE_MAX)
                  {
                     SocketDispatcher.getInstance().dispatchEvent(new SocketErrorEvent(SocketErrorEvent.ERROR,null));
                     readBytes(new ByteArray());
                     return;
                  }
                  _headInfo = new HeadInfo(this,_version);
                  trace("<<Socket[" + ip + ":" + port.toString() + "][cmdID:" + _headInfo.cmdID + "]",CmdName.getName(_headInfo.cmdID));
                  if(_version == SocketVersion.SV_1)
                  {
                     if(_headInfo.result != 0)
                     {
                        SocketDispatcher.getInstance().dispatchEvent(new SocketErrorEvent(SocketErrorEvent.ERROR,_headInfo));
                        continue;
                     }
                  }
                  else if(_version == SocketVersion.SV_2)
                  {
                     if(_headInfo.error != 0)
                     {
                        SocketDispatcher.getInstance().dispatchEvent(new SocketErrorEvent(SocketErrorEvent.ERROR,_headInfo));
                        continue;
                     }
                  }
                  _dataLen = _packageLen - _headLength;
                  if(_dataLen == 0)
                  {
                     SocketDispatcher.getInstance().dispatchEvent(new SocketEvent(_headInfo.cmdID.toString(),_headInfo,null));
                     continue;
                  }
                  _isGetHead = false;
               }
            }
            else if(bytesAvailable >= _dataLen)
            {
               data = new ByteArray();
               readBytes(data,0,_dataLen);
               tmfClass = TMF.getClass(_headInfo.cmdID);
               SocketDispatcher.getInstance().dispatchEvent(new SocketEvent(_headInfo.cmdID.toString(),_headInfo,new tmfClass(data)));
               _isGetHead = true;
            }
            if(outTime > 200 || !connected)
            {
               break;
            }
            ++outTime;
         }
      }
      
      override public function connect(host:String, port:int) : void
      {
         super.connect(host,port);
         _result = 0;
         trace("连接SOCKET：：：：",host,port);
         addEvent();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(ProgressEvent.SOCKET_DATA,onData);
      }
      
      private function addEvent() : void
      {
         addEventListener(ProgressEvent.SOCKET_DATA,onData);
      }
      
      override public function close() : void
      {
         removeEvent();
         if(connected)
         {
            super.close();
         }
         ip = "";
         port = -1;
         _result = 0;
      }
   }
}

