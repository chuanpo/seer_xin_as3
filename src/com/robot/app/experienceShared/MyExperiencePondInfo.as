package com.robot.app.experienceShared
{
   import flash.utils.IDataInput;
   
   public class MyExperiencePondInfo
   {
      private var myExp:uint = 0;
      
      public function MyExperiencePondInfo(data:IDataInput)
      {
         super();
         this.myExp = data.readUnsignedInt();
      }
      
      public function get getMyExp() : uint
      {
         return this.myExp;
      }
   }
}

