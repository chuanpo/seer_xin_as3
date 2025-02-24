package com.robot.core.info
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GetImgAddrInfo
   {
      private var _ip:String;
      
      private var _port:uint;
      
      private var _session:ByteArray;
      
      public function GetImgAddrInfo(data:IDataInput)
      {
         super();
         this._ip = data.readUTFBytes(16);
         this._port = data.readShort();
         this._session = new ByteArray();
         data.readBytes(this._session,0,16);
      }
      
      public function get ip() : String
      {
         return this._ip;
      }
      
      public function get port() : uint
      {
         return this._port;
      }
      
      public function get session() : ByteArray
      {
         return this._session;
      }
   }
}

