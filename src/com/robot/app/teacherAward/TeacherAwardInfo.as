package com.robot.app.teacherAward
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.ui.alert.Alarm;
   import flash.utils.IDataInput;
   
   public class TeacherAwardInfo
   {
      private var info_a:Array;
      
      public function TeacherAwardInfo(data:IDataInput)
      {
         var i1:int = 0;
         var id:uint = 0;
         super();
         this.info_a = new Array();
         var cc:uint = data.readUnsignedInt();
         MainManager.actorInfo.graduationCount = cc;
         var count:uint = data.readUnsignedInt();
         if(count > 0)
         {
            for(i1 = 0; i1 < count; i1++)
            {
               id = data.readUnsignedInt();
               this.info_a.push(id);
            }
         }
         else if(cc == 0)
         {
            Alarm.show("你还没有培养出一个赛尔精英,加油");
         }
         else
         {
            Alarm.show("你已经培养了 " + cc + " 个精英赛尔");
         }
      }
      
      public function get getInfo() : Array
      {
         return this.info_a;
      }
   }
}

