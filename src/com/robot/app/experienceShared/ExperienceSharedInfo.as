package com.robot.app.experienceShared
{
   import flash.utils.IDataInput;
   
   public class ExperienceSharedInfo
   {
      private var fraction:uint = 0;
      
      public function ExperienceSharedInfo(data:IDataInput)
      {
         super();
         this.fraction = data.readUnsignedInt();
         trace("fraction====" + this.fraction);
      }
      
      public function get getFraction() : uint
      {
         return this.fraction;
      }
   }
}

