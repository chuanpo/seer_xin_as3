package com.robot.app.teacher
{
   import com.robot.app.teacherAward.SevenNoLoginInfo;
   import com.robot.core.CommandID;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.PeopleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.Answer;
   import flash.display.Sprite;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.ArrayUtil;
   import org.taomee.utils.DisplayUtil;
   
   public class TeacherSysManager
   {
      private static var sprite:Sprite;
      
      public function TeacherSysManager()
      {
         super();
      }
      
      public static function hideSendTip() : void
      {
         DisplayUtil.removeForParent(sprite);
         sprite = null;
      }
      
      public static function addTeacher(id:uint) : void
      {
         sprite = Alarm.show("申请已发送，请耐心等待对方的答复！");
         SocketConnection.send(CommandID.REQUEST_ADD_TEACHER,id);
      }
      
      public static function addStudent(id:uint) : void
      {
         sprite = Alarm.show("申请已发送，请耐心等待对方的答复！");
         SocketConnection.send(CommandID.REQUEST_ADD_STUDENT,id);
      }
      
      public static function delTeacher() : void
      {
         Answer.show("你确定要和你的教官解除关系吗？",function():void
         {
            SocketConnection.send(CommandID.DELETE_TEACHER);
         });
      }
      
      public static function delStudent() : void
      {
         SocketConnection.send(CommandID.SEVENNOLOGIN_COMPLETE);
         SocketConnection.addCmdListener(CommandID.SEVENNOLOGIN_COMPLETE,onCompleteHandler);
      }
      
      private static function onCompleteHandler(e:SocketEvent) : void
      {
         var data:SevenNoLoginInfo;
         SocketConnection.removeCmdListener(CommandID.SEVENNOLOGIN_COMPLETE,onCompleteHandler);
         data = e.data as SevenNoLoginInfo;
         if(data.getStatus == 0)
         {
            Answer.show("你确定要和你的学员解除关系吗？教官主动解除需要<font color=\'#ff0000\'>支付200赛尔豆</font>哦！",function():void
            {
               SocketConnection.send(CommandID.DELETE_STUDENT);
               if(MainManager.actorInfo.coins > 200)
               {
                  MainManager.actorInfo.coins -= 200;
               }
               else
               {
                  MainManager.actorInfo.coins = 0;
               }
            });
            return;
         }
         if(data.getStatus == 1)
         {
            Answer.show("由于你的学员连续7天没登陆飞船，你可以免费解除关系。",function():void
            {
               SocketConnection.send(CommandID.DELETE_STUDENT);
            });
         }
      }
      
      public static function checkMapUser() : void
      {
         var i:PeopleModel = null;
         var mode:BasePeoleModel = null;
         var array:Array = UserManager.getUserModelList();
         var ids:Array = [];
         for each(i in array)
         {
            ids.push(i.info.userID);
         }
         for each(i in array)
         {
            if(ArrayUtil.arrayContainsValue(ids,i.info.teacherID))
            {
               mode = UserManager.getUserModel(i.info.teacherID);
               mode.addProtectMC();
               i.addProtectMC();
            }
            else if(ArrayUtil.arrayContainsValue(ids,i.info.studentID))
            {
               mode = UserManager.getUserModel(i.info.studentID);
               mode.addProtectMC();
               i.addProtectMC();
            }
            if(i.info.teacherID == MainManager.actorID || i.info.studentID == MainManager.actorID)
            {
               MainManager.actorModel.addProtectMC();
               i.addProtectMC();
            }
         }
      }
      
      public static function updateAfterDel() : void
      {
         var i:BasePeoleModel = null;
         var id:uint = 0;
         var array:Array = UserManager.getUserModelList();
         for each(i in array)
         {
            id = uint(i.info.userID);
            if(id == MainManager.actorInfo.teacherID || id == MainManager.actorInfo.studentID)
            {
               i.delProtectMC();
            }
         }
         MainManager.actorModel.delProtectMC();
      }
      
      public static function updateAfterAdd() : void
      {
         var i:BasePeoleModel = null;
         var id:uint = 0;
         var array:Array = UserManager.getUserModelList();
         for each(i in array)
         {
            id = uint(i.info.userID);
            if(id == MainManager.actorInfo.teacherID || id == MainManager.actorInfo.studentID)
            {
               MainManager.actorModel.addProtectMC();
               i.addProtectMC();
            }
         }
      }
   }
}

