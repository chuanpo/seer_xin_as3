package com.robot.app.spriteFusion2
{
   import com.robot.core.info.userItem.SingleItemInfo;
   
   public class ElementItemInfo
   {
      private var _num:int;
      
      private var _info:SingleItemInfo;
      
      public function ElementItemInfo()
      {
         super();
      }
      
      public function get num() : int
      {
         return _num;
      }
      
      public function set num(param1:int) : void
      {
         _num = param1;
      }
      
      public function set info(param1:SingleItemInfo) : void
      {
         _info = param1;
      }
      
      public function get info() : SingleItemInfo
      {
         return _info;
      }
   }
}

