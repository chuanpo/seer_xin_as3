package com.robot.app.teacherAward
{
   import flash.utils.IDataInput;
   
   public class SevenNoLoginInfo
   {
      private var isLogin:uint;
      
      public function SevenNoLoginInfo(data:IDataInput)
      {
         super();
         this.isLogin = data.readUnsignedInt();
      }
      
      public function get getStatus() : uint
      {
         return this.isLogin;
      }
   }
}

