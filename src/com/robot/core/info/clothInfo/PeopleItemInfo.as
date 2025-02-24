package com.robot.core.info.clothInfo
{
   public class PeopleItemInfo
   {
      public var id:uint;
      
      public var level:uint;
      
      public function PeopleItemInfo(id:uint, level:uint = 1)
      {
         super();
         this.id = id;
         this.level = level;
      }
   }
}

