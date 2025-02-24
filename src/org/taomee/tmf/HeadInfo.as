package org.taomee.tmf
{
   import flash.utils.IDataInput;
   import org.taomee.net.SocketVersion;
   
   public class HeadInfo
   {
      private var _version:String;
      
      private var _userID:uint;
      
      private var _error:uint;
      
      private var _cmdID:uint;
      
      private var _result:int;
      
      public function HeadInfo(headData:IDataInput, vs:String)
      {
         super();
         _version = headData.readUTFBytes(1);
         _cmdID = headData.readUnsignedInt();
         _userID = headData.readUnsignedInt();
         _result = headData.readInt();
         _version = vs;
         if(_version == SocketVersion.SV_2)
         {
            _error = headData.readUnsignedInt();
         }
      }
      
      public function get userID() : uint
      {
         return _userID;
      }
      
      public function get error() : uint
      {
         return _error;
      }
      
      public function get cmdID() : uint
      {
         return _cmdID;
      }
      
      public function get result() : int
      {
         return _result;
      }
      
      public function get version() : String
      {
         return _version;
      }
   }
}

