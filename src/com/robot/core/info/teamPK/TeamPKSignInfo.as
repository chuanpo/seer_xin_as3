package com.robot.core.info.teamPK
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.utils.StringUtil;
   
   public class TeamPKSignInfo
   {
      private var _sign:ByteArray = new ByteArray();
      
      private var _ip:String;
      
      private var _port:uint;
      
      public function TeamPKSignInfo(data:IDataInput)
      {
         super();
         data.readBytes(this._sign,0,24);
         this._ip = StringUtil.hexToIp(data.readUnsignedInt());
         this._port = data.readUnsignedShort();
      }
      
      public function get sign() : ByteArray
      {
         return this._sign;
      }
      
      public function get ip() : String
      {
         return this._ip;
      }
      
      public function get port() : uint
      {
         return this._port;
      }
   }
}

