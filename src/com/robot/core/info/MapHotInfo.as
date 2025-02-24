package com.robot.core.info
{
   import flash.utils.IDataInput;
   import org.taomee.ds.HashMap;
   
   public class MapHotInfo
   {
      private var _infos:HashMap;
      
      public function MapHotInfo(data:IDataInput)
      {
         var id:uint = 0;
         var userNum:uint = 0;
         super();
         this._infos = new HashMap();
         var num:uint = data.readUnsignedInt();
         for(var i:uint = 0; i < num; i++)
         {
            id = data.readUnsignedInt();
            userNum = data.readUnsignedInt();
            this._infos.add(id,userNum);
         }
      }
      
      public function get infos() : HashMap
      {
         return this._infos;
      }
   }
}

