package com.robot.core.info.item
{
   import com.robot.core.config.xml.DoodleXMLInfo;
   import flash.utils.IDataInput;
   
   public class DoodleInfo
   {
      public var userID:uint;
      
      public var id:uint;
      
      public var color:uint;
      
      public var texture:uint;
      
      public var URL:String;
      
      public var preURL:String;
      
      public var price:uint;
      
      public var coins:uint;
      
      public function DoodleInfo(data:IDataInput = null)
      {
         super();
         if(Boolean(data))
         {
            this.userID = data.readUnsignedInt();
            this.color = data.readUnsignedInt();
            this.texture = data.readUnsignedInt();
            this.coins = data.readUnsignedInt();
            this.URL = DoodleXMLInfo.getSwfURL(this.texture);
            this.preURL = DoodleXMLInfo.getPrevURL(this.texture);
         }
      }
   }
}

