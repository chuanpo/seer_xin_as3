package com.robot.app.teacher
{
   import com.robot.core.CommandID;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.event.TeacherEvent;
   import com.robot.core.info.InformInfo;
   import com.robot.core.info.UserInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.RelationManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.Answer;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class TeacherCmdListener extends BaseBeanController
   {
      private static var currentID:uint;
      
      public function TeacherCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.ANSWER_ADD_TEACHER,this.onAnswerTeacher);
         SocketConnection.addCmdListener(CommandID.ANSWER_ADD_STUDENT,this.onAnswerStudent);
         SocketConnection.addCmdListener(CommandID.DELETE_STUDENT,this.onDelStudent);
         SocketConnection.addCmdListener(CommandID.DELETE_TEACHER,this.onDelTeacher);
         EventManager.addEventListener(TeacherEvent.REQUEST_ME_AS_STUDENT,this.addMeAsStudent);
         EventManager.addEventListener(TeacherEvent.REQUEST_ME_AS_TEACHER,this.addMeAsTeacher);
         EventManager.addEventListener(TeacherEvent.REQUEST_STUDENT_HANDLED,this.onStudentRequest);
         EventManager.addEventListener(TeacherEvent.REQUEST_TEACHER_HANDLED,this.onTeacherRequest);
         EventManager.addEventListener(TeacherEvent.DELETE_AS_TEACHER,this.onDelteAsTeacher);
         EventManager.addEventListener(TeacherEvent.DELETE_AS_STUDENT,this.onDelteAsStudent);
         EventManager.addEventListener(RobotEvent.CREATED_MAP_USER,this.onCreatedMapUser);
         finish();
      }
      
      private function addMeAsStudent(event:TeacherEvent) : void
      {
         var info:InformInfo = null;
         info = event.info;
         Answer.show("<font color=\'#ff0000\'>" + info.nick + "(" + info.userID + ")</font>希望做你的<font color=\'#FF0000\'>教官</font>，你同意吗？",function():void
         {
            SocketConnection.send(CommandID.ANSWER_ADD_STUDENT,info.userID,1);
            currentID = info.userID;
         },function():void
         {
            SocketConnection.send(CommandID.ANSWER_ADD_STUDENT,info.userID,0);
         });
      }
      
      private function addMeAsTeacher(event:TeacherEvent) : void
      {
         var info:InformInfo = null;
         info = event.info;
         Answer.show("<font color=\'#ff0000\'>" + info.nick + "(" + info.userID + ")</font>希望做你的<font color=\'#FF0000\'>学员</font>，你同意吗？",function():void
         {
            SocketConnection.send(CommandID.ANSWER_ADD_TEACHER,info.userID,1);
            currentID = info.userID;
         },function():void
         {
            SocketConnection.send(CommandID.ANSWER_ADD_TEACHER,info.userID,0);
         });
      }
      
      private function onAnswerTeacher(event:SocketEvent) : void
      {
         var info:UserInfo = null;
         var data:ByteArray = event.data as ByteArray;
         var accept:uint = data.readUnsignedInt();
         if(accept == 1)
         {
            MainManager.actorInfo.studentID = currentID;
            Alarm.show("恭喜你，你现在有了一名学员，你要尽快帮助他熟悉赛尔号哦！");
            info = new UserInfo();
            info.userID = currentID;
            RelationManager.addFriendInfo(info);
            RelationManager.upDateInfo(currentID);
            RelationManager.setOnLineFriend();
            TeacherSysManager.updateAfterAdd();
         }
      }
      
      private function onAnswerStudent(event:SocketEvent) : void
      {
         var info:UserInfo = null;
         var data:ByteArray = event.data as ByteArray;
         var accept:uint = data.readUnsignedInt();
         if(accept == 1)
         {
            MainManager.actorInfo.teacherID = currentID;
            Alarm.show("恭喜你，你现在有了一名教官，有什么问题你可以向他咨询哦！");
            info = new UserInfo();
            info.userID = currentID;
            RelationManager.addFriendInfo(info);
            RelationManager.upDateInfo(currentID);
            RelationManager.setOnLineFriend();
            TeacherSysManager.updateAfterAdd();
         }
      }
      
      private function onStudentRequest(event:TeacherEvent) : void
      {
         var userInfo:UserInfo = null;
         var info:InformInfo = event.info;
         if(info.accept == 0)
         {
            Alarm.show("很遗憾，<font color=\'#ff0000\'>" + info.nick + "(" + info.userID + ")</font>现在还不想做你的学员！");
         }
         else
         {
            Alarm.show("恭喜你，对方同意了你的请求，已经是你的学员了！你要好好照顾他哦！");
            MainManager.actorInfo.studentID = info.userID;
            userInfo = new UserInfo();
            userInfo.userID = info.userID;
            RelationManager.addFriendInfo(userInfo);
            RelationManager.upDateInfo(info.userID);
            RelationManager.setOnLineFriend();
            TeacherSysManager.updateAfterAdd();
         }
      }
      
      private function onTeacherRequest(event:TeacherEvent) : void
      {
         var userInfo:UserInfo = null;
         var info:InformInfo = event.info;
         if(info.accept == 0)
         {
            Alarm.show("很遗憾，<font color=\'#ff0000\'>" + info.nick + "(" + info.userID + ")</font>现在还不想做你的教官！");
         }
         else
         {
            Alarm.show("恭喜你，对方同意了你的请求，已经是你的教官了！加油哦！");
            MainManager.actorInfo.teacherID = info.userID;
            userInfo = new UserInfo();
            userInfo.userID = info.userID;
            RelationManager.addFriendInfo(userInfo);
            RelationManager.upDateInfo(info.userID);
            RelationManager.setOnLineFriend();
            TeacherSysManager.updateAfterAdd();
         }
      }
      
      private function onDelStudent(event:SocketEvent) : void
      {
         TeacherSysManager.updateAfterDel();
         Alarm.show("你已经和你的学员解除了关系！");
         RelationManager.upDateInfo(MainManager.actorInfo.studentID);
         MainManager.actorInfo.studentID = 0;
         RelationManager.setOnLineFriend();
      }
      
      private function onDelTeacher(event:SocketEvent) : void
      {
         TeacherSysManager.updateAfterDel();
         Alarm.show("你已经和你的教官解除了关系！");
         RelationManager.upDateInfo(MainManager.actorInfo.teacherID);
         MainManager.actorInfo.teacherID = 0;
         RelationManager.setOnLineFriend();
      }
      
      private function onDelteAsTeacher(event:TeacherEvent) : void
      {
         TeacherSysManager.updateAfterDel();
         var data:InformInfo = event.info;
         if(data.accept == 2)
         {
            Alarm.show("你的学员<font color=\'#ff0000\'>" + data.nick + "(" + data.userID + ")</font>已经和你解除了关系！");
         }
         else if(data.accept == 3)
         {
            MainManager.actorInfo.graduationCount += 1;
            Alarm.show("恭喜你，你的学员<font color=\'#ff0000\'>" + data.nick + "(" + data.userID + ")</font>已经可以独挡一面了，你可以招收新的学员。");
         }
         MainManager.actorInfo.studentID = 0;
         RelationManager.upDateInfo(data.userID);
         RelationManager.setOnLineFriend();
      }
      
      private function onDelteAsStudent(event:TeacherEvent) : void
      {
         TeacherSysManager.updateAfterDel();
         var data:InformInfo = event.info;
         Alarm.show("你的教官<font color=\'#ff0000\'>" + data.nick + "(" + data.userID + ")</font>已经和你解除了关系！");
         MainManager.actorInfo.teacherID = 0;
         RelationManager.upDateInfo(data.userID);
         RelationManager.setOnLineFriend();
      }
      
      private function onCreatedMapUser(event:RobotEvent) : void
      {
         TeacherSysManager.checkMapUser();
      }
   }
}

